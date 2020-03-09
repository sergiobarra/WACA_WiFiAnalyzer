function [throughput, num_txs, num_txs_ch, n_agg_array, num_preventions, tx_bw] = ...
        throuhgput_sim_full_buffer_hidden(occupancy_matrix, primary_ch, policy, N_agg_max, L_D, NUM_RFs, COEFF_INT)
    % Get throughput
    % Input:
    % - occupancy_matrix: logical matrix of smaples (0: idle, 1: occupied) num_samples x num_channels
    % - primary_ch: considered primary channel for throughput estimation
    % - dcb_model: DCB model (could be single channel)
    % - N_agg: fixed number of data packets aggregated per frame
    % - pkt_generated_array: binary array (0: no packet generated in sample, 1: packet generated in sample)
    % - L_D: data packet size [bit]
    % Output:
    % - throughput: av. trhoughput estimated
    % - num_txs: no. of transmissions (of every bandwidth)
    % - num_txs_ch: array of the no. of transmissions per channel
    % - num_preventions: no. of times an occupied sample appeared during TX
    % in the transmission bandwidth
    
   
    %% Constants
    T_SAMPLE = 10*1E-6;
    CW = 16;
    MCS = 9;
    T_TXOP_FULL_TX = 5 * 1E-3;  % Time channel will be reserved. Max DATA TXOP in 11ax [5.4 ms]
    %T_TXOP_FULL_TX = 999999 * 1E-3;  % Time channel will be reserved. Max DATA TXOP in 11ax [5.4 ms]
    
    %N_agg = 1;
    [T_DIFS,T_SIFS,Te,L_MH,L_BACK,L_RTS,L_CTS,L_SF,L_MD,L_TB,L_ACK] = ieee11axMACParams() ;
    T_BO = (CW-1)/2 * Te;
    T_RTS = 52*1E-6;
    T_CTS = 44*1E-6;
    T_BACK = 50*1E-6;
    T_PIFS = 25*1E-6;
    T_EMPTY = 9*1E-6;
    num_samples = size(occupancy_matrix,1);
    
    BW_SC = 20; % SC bandwidth [MHz]

    % Convert durations from time to samples (1 sample ---> 10 us)
    s_BO_ORIGINAL = round(T_BO / T_SAMPLE);
    s_BO = s_BO_ORIGINAL;
    m_BO = 0;
    m_BO_max = 5;
    s_RTS = round(T_RTS / T_SAMPLE);
    s_CTS = round(T_CTS / T_SAMPLE);
    s_BACK = round(T_BACK / T_SAMPLE);
    s_DIFS = round(T_DIFS / T_SAMPLE);
    s_SIFS = round(T_SIFS / T_SAMPLE);
    s_PIFS = round(T_PIFS / T_SAMPLE);
    s_EMPTY = round(T_EMPTY / T_SAMPLE);
    s_TXOP_FULL_TX = round(T_TXOP_FULL_TX / T_SAMPLE);
    
    % T_success = T_RTS + T_SIFS + T_CTS + T_SIFS + T_DATA + T_SIFS + T_BACK + T_DIFS + Te
    s_OVERHEAD = s_RTS + 3 * s_SIFS + s_CTS + s_BACK + s_DIFS + s_EMPTY;
    
    %% for
    % States
    STATE_IDLE = -1;
    STATE_DIFS = 0;
    STATE_BO = 1;
    STATE_TX = 2;
    
    state = STATE_DIFS;
    num_data_bits_sent = 0;
    num_txs = 0;
    num_preventions = 0;
    s = 1;
    c = 0;  % DIFS counter
    b = 0;  % Backoff counter
    
    POLICY_CBCONT = 1;
    POLICY_CBNONCONT = 2;
    POLICY_SC = 3;
    POLICY_SCB = 4;
    POLICY_DCB = 5;
    POLICY_PP = 6;
    
    num_txs_ch = zeros(NUM_RFs + 1,1);
    
    tx_bw = 0;
    
    % Buffer
    num_pkt_sent = 0;
    n_agg_array = [];
    
    %% Apply DCB (or single-channel) model
    
    switch policy
        
                %% CB Contiguous
    case POLICY_CBCONT
        num_channels = 1;
        next_tx_free = true;
        while s < num_samples
            
            % Is the sample busy?
            sample_busy = occupancy_matrix(s,primary_ch);
            % fprintf('s = %d: state = %d, c = %d, busy = %d\n', s, state, c, sample_busy);
            
            switch state
                
                case STATE_DIFS
                    s = s + 1;

                    % Idle sample
                    if ~sample_busy
                        if c < s_DIFS
                            c = c + 1;
                            state = STATE_DIFS;
                        else
                            state = STATE_BO;
                        end
                    % Busy sample
                    else
                        c = 0;
                        state = STATE_DIFS;
                    end

                case STATE_BO

                    s = s + 1;
                    if ~sample_busy % Idle sample
                        if b < s_BO
                            b = b + 1;
                            state = STATE_BO;
                        else
                            
                            % Contiguous CB
                            ch_range = 1:NUM_RFs;
                            occupancy_at_access = occupancy_matrix(s-1,ch_range);
                            [num_channels, ch_left, ch_right] = get_num_contiguous_channels(occupancy_at_access,primary_ch);
                            ch_range = ch_left:ch_right;
                            
                            bw = num_channels * BW_SC;
                            [s_FULL_TX, s_DATA, n_agg] = find_max_pkts_aggregated(N_agg_max, bw, s_TXOP_FULL_TX, s_OVERHEAD);
                            
                            if(s+s_FULL_TX <= num_samples)
                                
                                % Check if all samples during transmission
                                % will be free in all channels
                                next_DATA_samples = occupancy_matrix(s+1:s+s_FULL_TX,ch_range);
                                num_data_samples = size(next_DATA_samples,1);
                                sum_next_DATA_samples = sum(next_DATA_samples,2);
                                num_occupied_samples_in_tx = nnz(sum_next_DATA_samples);

                                next_tx_free = logical(num_occupied_samples_in_tx < COEFF_INT * num_data_samples);

                                state = STATE_TX;
                                
                            else
                                state = STATE_DIFS;
								c=0;
								b=0;
                            end
                        end
                        
                    else % sample busy
                        c = 0;
                        state = STATE_DIFS;
                    end
                    
                case STATE_TX
                    
                    num_txs = num_txs + 1;
                    num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                    
                    % If transmission successful
                    if next_tx_free
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;

                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];

                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)

                        %fprintf('TX successful!\n')

                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;

                    else % If TX not successful
                        num_preventions = num_preventions + 1;
                        if m_BO < m_BO_max
                            m_BO = m_BO + 1;
                        end
                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                        %fprintf('TX failed!\n')
                    end
                        
                    tx_bw = tx_bw + s_FULL_TX * bw;
                    s = s + s_FULL_TX;
                    
                    state = STATE_DIFS;
                    c=0;
                    b=0;
                    
                otherwise
                    error('State is not valid!')
            end
            
        end
        
        
        %% CB Non-Contiguous
    case POLICY_CBNONCONT
        num_channels = 1;
        s_DATA = 0;
        next_tx_free = true;
        while s < num_samples
            
            % Is the sample busy?
            sample_busy = occupancy_matrix(s,primary_ch);
            % fprintf('s = %d: state = %d, c = %d, busy = %d\n', s, state, c, sample_busy);
            
            switch state
                
                case STATE_DIFS
                    s = s + 1;

                    % Idle sample
                    if ~sample_busy
                        if c < s_DIFS
                            c = c + 1;
                            state = STATE_DIFS;
                        else
                            state = STATE_BO;
                        end
                    % Busy sample
                    else
                        c = 0;
                        state = STATE_DIFS;
                    end

                case STATE_BO

                    s = s + 1;
                    if ~sample_busy % Idle sample
                        if b < s_BO
                            b = b + 1;
                            state = STATE_BO;
                        else
                            
                            % Non-contiguous CB
                            ch_range = 1:NUM_RFs;
                            occupancy_at_access = occupancy_matrix(s-1,ch_range);
                            num_channels = sum(occupancy_at_access==0);
                            ch_range = find(occupancy_at_access==0);
                            
                            bw = num_channels * BW_SC;
                            [s_FULL_TX, s_DATA, n_agg] = find_max_pkts_aggregated(N_agg_max, bw, s_TXOP_FULL_TX, s_OVERHEAD);
                            
                            if(s+s_FULL_TX <= num_samples)
                               
                                % Check if all samples during transmission
                                % will be free in all channels
                                next_DATA_samples = occupancy_matrix(s+1:s+s_FULL_TX,ch_range);
                                num_data_samples = size(next_DATA_samples,1);
                                sum_next_DATA_samples = sum(next_DATA_samples,2);
                                num_occupied_samples_in_tx = nnz(sum_next_DATA_samples);

                                next_tx_free = logical(num_occupied_samples_in_tx < COEFF_INT * num_data_samples);
                                
                                
                                state = STATE_TX;
                                
                            else
                                state = STATE_DIFS;
								c=0;
								b=0;
                            end
                        end
                        
                    else % sample busy
                       state = STATE_DIFS;
                        c=0;
                        b=0;
                    end
                    
                case STATE_TX
                    
                    num_txs = num_txs + 1;
                    num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                    
                    % If transmission successful
                    if next_tx_free
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;

                        

                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];

                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)

                        %fprintf('TX successful!\n')

                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;

                    else % If TX not successful
                        num_preventions = num_preventions + 1;
                        if m_BO < m_BO_max
                            m_BO = m_BO + 1;
                        end
                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                        %fprintf('TX failed!\n')
                    end
                        
                    tx_bw = tx_bw + s_FULL_TX * bw;
                    s = s + s_FULL_TX;
                    
                    state = STATE_DIFS;
                    c=0;
                    b=0;
                    
                otherwise
                    error('State is not valid!')
            end
            
            
        end
        
        %% Single-channel
        case POLICY_SC
            num_channels = 1;
            s_DATA = 0;
            next_tx_free = true;
            
            while s < num_samples
                
                % Is the sample busy?
                sample_busy = occupancy_matrix(s,primary_ch);
                %fprintf('s = %d: state = %d, c = %d, busy = %d\n', s, state, c, sample_busy);
                
                switch state
                    
                    case STATE_DIFS
                        s = s + 1;

                        % Idle sample
                        if ~sample_busy
                            if c < s_DIFS
                                c = c + 1;
                                state = STATE_DIFS;
                            else
                                state = STATE_BO;
                            end
                        % Busy sample
                        else
                            c = 0;
                            state = STATE_DIFS;
                        end

                    case STATE_BO

                        s = s + 1;
                        if ~sample_busy % Idle sample
                            if b < s_BO
                                b = b + 1;
                                state = STATE_BO;
                            else
                                
                                % Check if next samples are also free
                                bw = BW_SC;
                                [s_FULL_TX, s_DATA, n_agg] = find_max_pkts_aggregated(N_agg_max, bw, s_TXOP_FULL_TX, s_OVERHEAD);
                                
                                if(s+s_FULL_TX <= num_samples)
                                    
                                    next_DATA_samples = occupancy_matrix(s+1:s+s_FULL_TX,primary_ch);
                                    num_data_samples = length(next_DATA_samples);
                                    num_occupied_samples_in_tx = sum(next_DATA_samples);
                                    
                                    next_tx_free = logical(num_occupied_samples_in_tx < COEFF_INT * num_data_samples);
                                    
%                                     fprintf('- num_data_samples = %d\n', num_data_samples)
%                                     fprintf('- num_occupied_samples_in_tx = %d\n', num_occupied_samples_in_tx)
%                                     fprintf('- COEFF_INT * num_data_samples = %d\n', COEFF_INT * num_data_samples)
%                                     fprintf('- next_tx_free = %d\n', next_tx_free)
                                                                        
                                    if next_tx_free
                                        state = STATE_TX;
                                    else
                                        % No matter occupancy, TX
                                        state = STATE_TX;
                                    end
                                else
                                    state = STATE_DIFS;
                                    c=0;
                                    b=0;
                                end
                                
                            end
                            
                        else % sample busy
                            c = 0;
                            state = STATE_DIFS;
                        end
                        
                    case STATE_TX
                        
                        num_txs = num_txs + 1;
                        num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                        %fprintf('s = %d - Transmitting frame #%d...\n',s,num_txs)
                        
                        % If transmission successful
                        if next_tx_free
                            num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                                                       
                            %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                            n_agg_array = [n_agg_array n_agg];
                            
                            num_pkt_sent = num_pkt_sent + n_agg;
                            %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                            
                            %fprintf('TX successful!\n')
                            
                            m_BO = 0;
                            s_BO = s_BO_ORIGINAL;
                            
                        else % If TX not successful
                            num_preventions = num_preventions + 1;
                            if m_BO < m_BO_max
                                m_BO = m_BO + 1;
                            end
                            s_BO = 2^m_BO * s_BO_ORIGINAL;
                            %fprintf('TX failed!\n')
                        end
                        
                        tx_bw = tx_bw + s_FULL_TX * bw;
                        s = s + s_FULL_TX;
                        
                        state = STATE_DIFS;
                        c=0;
                        b=0;
      
                    otherwise
                        error('State is not valid!')
                end
                
            end
            
            %% SCB
        case POLICY_SCB
            num_channels = 1;
            n_agg = 0;
            s_DATA = 0;
            next_tx_free = true;
            while s < num_samples
                
                % Is the sample busy?
                sample_busy = occupancy_matrix(s,primary_ch);
                % fprintf('s = %d: state = %d, c = %d, busy = %d\n', s, state, c, sample_busy);
                
                switch state
                    
                    case STATE_DIFS
                        s = s + 1;

                        % Idle sample
                        if ~sample_busy
                            if c < s_DIFS
                                c = c + 1;
                                state = STATE_DIFS;
                            else
                                state = STATE_BO;
                            end
                        % Busy sample
                        else
                            c = 0;
                            state = STATE_DIFS;
                        end

                    case STATE_BO

                        s = s + 1;
                        if ~sample_busy % Idle sample
                            if b < s_BO
                                b = b + 1;
                                state = STATE_BO;
                            else
                                
                                % Channel bonding                                
                                if primary_ch >= 1 && primary_ch <= 8
                                    
                                    % Check 160 MHz channels
                                    ch_range = 1:8;
                                    next_DATA_samples = occupancy_matrix(s-s_PIFS:s,ch_range);
                                    access_free_8ch = ~logical(sum(next_DATA_samples,'all')>0);
                                    
                                    % SCB
                                    % If transmission possible in full band
                                    if access_free_8ch
                                        num_channels = length(ch_range);
                                        
                                        % Check if transmission will be successful
                                        
                                        %fprintf('- PIFS process, num_channels = %d\n', num_channels)
                                        bw = num_channels * BW_SC;
                                        [s_FULL_TX, s_DATA, n_agg] = find_max_pkts_aggregated(N_agg_max, bw, s_TXOP_FULL_TX, s_OVERHEAD);
                                        
                                        if(s+s_FULL_TX <= num_samples)
                                            
                                            % Check if all samples during transmission
                                            % will be free in all channels 
                                            next_DATA_samples = occupancy_matrix(s+1:s+s_FULL_TX,ch_range);
                                            num_data_samples = size(next_DATA_samples,1);
                                            sum_next_DATA_samples = sum(next_DATA_samples,2);
                                            num_occupied_samples_in_tx = nnz(sum_next_DATA_samples);

                                            next_tx_free = logical(num_occupied_samples_in_tx < COEFF_INT * num_data_samples);
                                            
                                            if next_tx_free
                                                state = STATE_TX;
                                            else
                                                % We transmit anyhow but do not
                                                % count as valid throughput
                                                state = STATE_TX;
                                            end
                                        else
                                           state = STATE_DIFS;
                                            c=0;
                                            b=0;
                                        end
                                        
                                        % If transmission NOT possible in full band
                                    else
                                        % If access not allowed, increase CW
                                        % and start another BO
                                        if m_BO < m_BO_max
                                            m_BO = m_BO + 1;
                                        end
                                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                                        %fprintf('TX failed!\n')
                                        state = STATE_DIFS;
                                        c=0;
                                        b=0;
                                    end
                                    
                                end
                                
                                
                            end
                            
                        else % sample busy
                            c = 0;
                            state = STATE_DIFS;
                        end
                        
                    case STATE_TX
                        % compute transmission duration
                        %fprintf('*** TX ***\n')
                        
                        % Count throughput bits just if all transmission
                        % samples will be free
                        num_txs = num_txs + 1;
                        num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                        
                        if next_tx_free
                            num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                            
                            %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                            n_agg_array = [n_agg_array n_agg];
                            
                            num_pkt_sent = num_pkt_sent + n_agg;
                            %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                            
                            m_BO = 0;
                            s_BO = s_BO_ORIGINAL;
                            
                        else % If TX not successful
                            num_preventions = num_preventions + 1;
                            if m_BO < m_BO_max
                                m_BO = m_BO + 1;
                            end
                            s_BO = 2^m_BO * s_BO_ORIGINAL;
                            %fprintf('TX failed!\n')
                        end
                        
                        tx_bw = tx_bw + s_FULL_TX * bw;
                        s = s + s_FULL_TX;
                        state = STATE_DIFS;
                        c=0;
                        b=0;
                        
                    otherwise
                        error('State is not valid!')
                end
                
            end
            
            %% DCB
        case POLICY_DCB
            num_channels = 1;
            n_agg = 0;
            s_DATA = 0;
            next_tx_free = true;
            while s < num_samples
                
                % Is the sample busy?
                sample_busy = occupancy_matrix(s,primary_ch);
                % fprintf('s = %d: state = %d, c = %d, busy = %d\n', s, state, c, sample_busy);
                
                switch state
                    
                    case STATE_DIFS
                        s = s + 1;

                        % Idle sample
                        if ~sample_busy
                            if c < s_DIFS
                                c = c + 1;
                                state = STATE_DIFS;
                            else
                                state = STATE_BO;
                            end
                        % Busy sample
                        else
                            c = 0;
                            state = STATE_DIFS;
                        end

                    case STATE_BO

                        s = s + 1;
                        if ~sample_busy % Idle sample
                            if b < s_BO
                                b = b + 1;
                                state = STATE_BO;
                            else
                                
                                % Dynamic channel bonding                                
                                if primary_ch >= 1 && primary_ch <= 8
                                    
                                    % Check 160 MHz channels
                                    ch_range = 1:8;
                                    next_DATA_samples = occupancy_matrix(s-s_PIFS:s,ch_range);
                                    access_free_8ch = ~logical(sum(next_DATA_samples,'all')>0);
                                    
                                    if ~access_free_8ch
                                        
                                        % Check 80 MHz channels
                                        if primary_ch <= 4
                                            ch_range = 1:4;
                                        else
                                            ch_range = 5:8;
                                        end
                                        next_DATA_samples = occupancy_matrix(s-s_PIFS:s,ch_range);
                                        access_free_4ch = ~logical(sum(next_DATA_samples,'all')>0);
                                        
                                        if ~access_free_4ch
                                            
                                            % Check 40 MHz
                                            if primary_ch <= 2
                                                ch_range = 1:2;
                                            elseif primary_ch <= 4
                                                ch_range = 3:4;
                                            elseif primary_ch <= 6
                                                ch_range = 5:6;
                                            else
                                                ch_range = 7:8;
                                            end
                                            next_DATA_samples = occupancy_matrix(s-s_PIFS:s,ch_range);
                                            access_free_2ch = ~logical(sum(next_DATA_samples,'all')>0);
                                            
                                            if ~access_free_2ch
                                                % Use 20 MHz channel
                                                ch_range = primary_ch;
                                            end
                                            
                                        end
                                        
                                    end
                                    
                                end
                                
                                num_channels = length(ch_range);
                                
                                % Check if transmission will be successful
                                
                                %fprintf('- PIFS process, num_channels = %d\n', num_channels)
                                bw = num_channels * BW_SC;
                                [s_FULL_TX, s_DATA, n_agg] = find_max_pkts_aggregated(N_agg_max, bw, s_TXOP_FULL_TX, s_OVERHEAD);
                                
                                if(s+s_FULL_TX <= num_samples)
                                    
                                    % Check if all samples during transmission
                                    % will be free in all channels
                                    next_DATA_samples = occupancy_matrix(s+1:s+s_FULL_TX,ch_range);
                                    num_data_samples = size(next_DATA_samples,1);
                                    sum_next_DATA_samples = sum(next_DATA_samples,2);
                                    num_occupied_samples_in_tx = nnz(sum_next_DATA_samples);

                                    next_tx_free = logical(num_occupied_samples_in_tx < COEFF_INT * num_data_samples);
                                    
                                    if next_tx_free
                                        state = STATE_TX;
                                    else
                                        % We transmit anyhow but do not
                                        % count as valid throughput
                                        state = STATE_TX;
                                        
                                    end
                                else
                                    state = STATE_DIFS;
                                    c=0;
                                    b=0;
                                end
                            end
                            
                        else % sample busy
                            c = 0;
                            state = STATE_DIFS;
                        end
                        
                    case STATE_TX
                        % compute transmission duration
                        %fprintf('*** TX ***\n')
                        
                        % Count throughput bits just if all transmission
                        % samples will be free
                        
                        num_txs = num_txs + 1;
                        num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                         
                        if next_tx_free
                            num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                            
                            %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                            n_agg_array = [n_agg_array n_agg];
                            
                            num_pkt_sent = num_pkt_sent + n_agg;
                            %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                            
                            m_BO = 0;
                            s_BO = s_BO_ORIGINAL;
                            
                        else % If TX not successful
                            num_preventions = num_preventions + 1;
                            if m_BO < m_BO_max
                                m_BO = m_BO + 1;
                            end
                            s_BO = 2^m_BO * s_BO_ORIGINAL;
                            %fprintf('TX failed!\n')
                        end
                        
                        tx_bw = tx_bw + s_FULL_TX * bw;
                        s = s + s_FULL_TX;
                        state = STATE_DIFS;
                        c=0;
                        b=0;
                        
                    otherwise
                        error('State is not valid!')
                end
                
            end
            
        case POLICY_PP
            num_channels = 1;
            n_agg = 0;
            s_DATA = 0;
            next_tx_free = true;
            num_channels_punctured = 0;
            while s < num_samples
                
                
                % Is the sample busy?
                sample_busy = occupancy_matrix(s,primary_ch);
                % fprintf('s = %d: state = %d, c = %d, busy = %d\n', s, state, c, sample_busy);
                
                switch state
                    
                    case STATE_DIFS
                        s = s + 1;

                        % Idle sample
                        if ~sample_busy
                            if c < s_DIFS
                                c = c + 1;
                                state = STATE_DIFS;
                            else
                                state = STATE_BO;
                            end
                        % Busy sample
                        else
                            c = 0;
                            state = STATE_DIFS;
                        end

                    case STATE_BO

                        s = s + 1;
                        if ~sample_busy % Idle sample
                            if b < s_BO
                                b = b + 1;
                                state = STATE_BO;
                            else
                                
                                % Preamble puncturing
                                
                                %                                 fprintf('-----------------------\n')
                                %                                 primary_ch
                                if primary_ch >= 1 && primary_ch <= 8
                                    
                                    % --------- Check secondary 20 MHz ----
                                    if primary_ch == 1 || primary_ch == 2
                                        ch_range = 1:2;
                                    elseif primary_ch == 3 || primary_ch == 4
                                        ch_range = 3:4;
                                    elseif primary_ch == 5 || primary_ch == 6
                                        ch_range = 5:6;
                                    else
                                        ch_range = 7:8;
                                    end
                                    
                                    next_DATA_samples = occupancy_matrix(s-s_PIFS:s,ch_range);
                                    access_free_second20MHz = ~logical(sum(next_DATA_samples,'all')>0);
                                    
                                    if access_free_second20MHz
                                        
                                        % Do nothing. Primary 40 MHz ready
                                        
                                    else
                                        % Remove secondary 20 MHz
                                        ch_range = primary_ch;
                                    end
                                    %                                     fprintf('- Finished checking secondary 20 MHz \n')
                                    %                                     ch_range
                                    % --------- Finished checking secondary 20 MHz ----
                                    
                                    % --------- Check secondary 40 MHz ----
                                    % Check other secondary 40 MHz
                                    if primary_ch == 1 || primary_ch == 2
                                        ch_range_40MHz_secondary_low = 3;
                                        ch_range_40MHz_secondary_high = 4;
                                    elseif primary_ch == 3 || primary_ch == 4
                                        ch_range_40MHz_secondary_low = 1;
                                        ch_range_40MHz_secondary_high = 2;
                                    elseif primary_ch == 5 || primary_ch == 6
                                        ch_range_40MHz_secondary_low = 7;
                                        ch_range_40MHz_secondary_high = 8;
                                    else
                                        ch_range_40MHz_secondary_low = 5;
                                        ch_range_40MHz_secondary_high = 6;
                                    end
                                    
                                    % Check secondary 40 MHz high
                                    next_DATA_samples_40MHz_secondary_high = occupancy_matrix(s-s_PIFS:s,ch_range_40MHz_secondary_high);
                                    access_free_40MHz_secondary_high = ~logical(sum(next_DATA_samples_40MHz_secondary_high,'all')>0);
                                    
                                    if access_free_40MHz_secondary_high
                                        ch_range = [ch_range ch_range_40MHz_secondary_high];
                                    end
                                    
                                    % Check secondary 40 MHz low
                                    next_DATA_samples_40MHz_secondary_low = occupancy_matrix(s-s_PIFS:s,ch_range_40MHz_secondary_low);
                                    access_free_40MHz_secondary_low = ~logical(sum(next_DATA_samples_40MHz_secondary_low,'all')>0);
                                    
                                    if access_free_40MHz_secondary_low
                                        ch_range = [ch_range ch_range_40MHz_secondary_low];
                                    end
                                    %                                     fprintf('- Finished checking secondary 40 MHz \n')
                                    %                                     ch_range
                                    % --------- Finished checking secondary 40 MHz ----
                                    
                                    % --------- Check secondary 80 MHz ----
                                    % Only consider secondary 80 MHz if at
                                    % least 40 MHz already set
                                    if length(ch_range) > 1
                                        if primary_ch <= 4
                                            ch_range_80MHz_other = 5:8;
                                        else
                                            ch_range_80MHz_other = 1:4;
                                        end
                                        next_DATA_samples_80MHz_other = occupancy_matrix(s-s_PIFS:s,ch_range_80MHz_other);
                                        next_tx_free_80MHz_other = ~logical(sum(next_DATA_samples_80MHz_other,'all')>0);
                                        
                                        if next_tx_free_80MHz_other
                                            ch_range = [ch_range ch_range_80MHz_other];
                                        end
                                    end
                                    %                                     fprintf('- Finished checking secondary 80 MHz \n')
                                    %                                     ch_range
                                    % --------- Finished checking secondary 80 MHz ----
                                    
                                end
                                
                                % ---- PP: adapt num_channels to BW 80 or 160 MHz if puncturing
                                ch_range = unique(ch_range);
                                num_channels = length(ch_range);
%                                 if num_channels == 3
%                                     num_channels_punctured = 1;
%                                     num_channels = 4;
%                                 elseif num_channels == 6
%                                     num_channels_punctured = 2;
%                                     num_channels = 8;
%                                 elseif num_channels == 7
%                                     num_channels_punctured = 1;
%                                     num_channels = 8;
%                                 else
%                                     num_channels_punctured = 0;
%                                 end
                                
                                % Check if transmission will be successful
                                
                                %fprintf('- PIFS process, num_channels = %d\n', num_channels)
                                bw = num_channels * BW_SC;
                                [s_FULL_TX, s_DATA, n_agg] = find_max_pkts_aggregated(N_agg_max, bw, s_TXOP_FULL_TX, s_OVERHEAD);
                                
                                if(s+s_FULL_TX <= num_samples)
                                    
                                    % Check if all samples during transmission
                                    % will be free in all channels
                                    next_DATA_samples = occupancy_matrix(s+1:s+s_FULL_TX,ch_range);
                                    num_data_samples = size(next_DATA_samples,1);
                                    sum_next_DATA_samples = sum(next_DATA_samples,2);
                                    num_occupied_samples_in_tx = nnz(sum_next_DATA_samples);
                                    
                                    next_tx_free = logical(num_occupied_samples_in_tx < COEFF_INT * num_data_samples);
                                    
                                    if next_tx_free
                                        state = STATE_TX;
                                    else
                                        % We transmit anyhow but do not
                                        % count as valid throughput
                                        state = STATE_TX;
                                        
                                    end
                                else
                                    state = STATE_DIFS;
                                    c=0;
                                    b=0;
                                end
                            end
                            
                        else % sample busy
                            state = STATE_DIFS;
                            c=0;
                            b=0;
                        end
                        
                    case STATE_TX
                        % compute transmission duration
                        %fprintf('*** TX ***\n')
                        
                        % Count throughput bits just if all transmission
                        % samples will be free
                        
                        num_txs = num_txs + 1;
                        num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                        
                        if next_tx_free
                            num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                                                        
                            %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                            n_agg_array = [n_agg_array n_agg];
                            
                            num_pkt_sent = num_pkt_sent + n_agg;
                            %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                            
                            m_BO = 0;
                            s_BO = s_BO_ORIGINAL;
                            
                        else % If TX not successful
                            num_preventions = num_preventions + 1;
                            if m_BO < m_BO_max
                                m_BO = m_BO + 1;
                            end
                            s_BO = 2^m_BO * s_BO_ORIGINAL;
                            %fprintf('TX failed!\n')
                        end
                        
                        tx_bw = tx_bw + s_FULL_TX * bw;
                        s = s + s_FULL_TX;
                        state = STATE_DIFS;
                        c=0;
                        b=0;
                        
                    otherwise
                        error('State is not valid!')
                end
                
            end
            
    end
    
    throughput = num_data_bits_sent / (num_samples * T_SAMPLE);
    
    %% - Function: Compute data and ack transmission times
    function [t_data, t_ack] = get_data_tx_duration(n_agg, BW, MCS,L_D)
        [r,r_leg,T_OFDM,T_OFDM_leg,T_PHY_leg,T_PHY_HE_SU] = ieee11axPHYParams(BW,MCS,1);
        if n_agg == 1
            t_data = T_PHY_HE_SU + ceil( ( L_SF + L_MH + L_D + L_TB) / r) * T_OFDM;
            t_ack  = T_PHY_leg + ceil( (L_SF + L_ACK + L_TB) / r_leg ) * T_OFDM_leg;
        else
            t_data = T_PHY_HE_SU + ceil( ( L_SF + n_agg * (L_MD + L_MH + L_D) + L_TB) / r) * T_OFDM;
            t_ack  = T_PHY_leg + ceil( (L_SF + L_BACK + L_TB) / r_leg ) * T_OFDM_leg;
        end
    end
    
    function [s_full_tx, s_data, num_pkts_agg] = find_max_pkts_aggregated(max_num_pkts_agg, bw, s_TXOP, s_overhead)
        
        %printf('bw: ')
        %disp(bw)
        
        num_pkts_agg = max_num_pkts_agg;
        s_data = 0;
        s_full_tx = 0;
        
        while num_pkts_agg > 0
        
            % Compute data TX duration according to BW (11ax or not)
            if bw == 20 || bw == 40 || bw == 80 || bw == 160
                %printf('bw is 11ax')
                t_data = get_data_tx_duration(num_pkts_agg, bw, MCS, L_D);
            else
                %printf('bw is NOT 11ax')
                t_data_sc = get_data_tx_duration(num_pkts_agg, BW_SC, MCS, L_D);
                num_channels_aux = bw / BW_SC;
                t_data = t_data_sc / num_channels_aux;
            end
            
            s_data = round(t_data / T_SAMPLE);
            s_full_tx = s_data + s_overhead;
            %fprintf('s_full_tx (%d) [s_data (%d)] <? s_TXOP_11ax(%d)', s_full_tx, s_data, s_TXOP)
            
            if s_full_tx <= s_TXOP
                break;
            else
                num_pkts_agg = num_pkts_agg - 1;
            end
            
        end
    
    end
    
end

