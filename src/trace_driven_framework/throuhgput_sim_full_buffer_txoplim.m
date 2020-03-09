function [throughput, num_txs, num_txs_ch, n_agg_array, num_preventions, bw_enabled] = ...
        throuhgput_sim_full_buffer_txoplim(occupancy_matrix, primary_ch, policy, L_D, NUM_RFs, COEFF_INT)
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
    
    % T_success = T_RTS + T_SIFS + T_CTS + T_SIFS + T_DATA + T_SIFS + T_BACK + T_DIFS + Te
    s_OVERHEAD = s_RTS + 3 * s_SIFS + s_CTS + s_BACK + s_DIFS + s_EMPTY;
    
    bw_enabled = 0; % BW permitted to be used by other as a consequence of voluntarly deferring channel access
    
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
    
    % TXOP
    TXOP_ms = 5;    % TXOP [ms]
    TXOP_samples = round(TXOP_ms*1E-3 / T_SAMPLE);  % TXOP [samples] = 500
    MAX_Nagg = 256;
    
    Nagg_TXOP = txop_compute_num_agg_packets_per_bw();
    %fprintf('n_agg = %d - TXOP_samples = %d\n', n_agg, TXOP_samples)
    
    %% Apply DCB (or single-channel) model
    
    switch policy
        
        %% CB Contiguous
        case POLICY_CBCONT
            num_channels = 1;
            s_DATA = 0;
            next_TXOP_free = true;
            past_access_deferred = false;
            past_s_bo = 0;
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
                                
                                if past_access_deferred 
                                    
                                    if s < past_s_bo+s_txop
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : s, ch_range);
                                    else
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : past_s_bo + s_txop, ch_range);
                                    end
                                    
                                    num_active_samples_in_potential_tx = sum(sum(occupancy_partial_past_TXOP));
                                    bw_enabled = bw_enabled + num_active_samples_in_potential_tx * BW_SC; 
                                end
                                
                                % Contiguous CB
                                occupancy_at_access = occupancy_matrix(s-1,1:NUM_RFs);
                                [num_channels, ch_left, ch_right] = get_num_contiguous_channels(occupancy_at_access,primary_ch);
                                
                                % Get tx bandwidth
                                bw = num_channels * BW_SC;
                                ch_range = ch_left:ch_right;
                                
                                s_txop = TXOP_samples;
                                
                                % Check if bw free during whole TXOP
                                if(s+s_txop <= num_samples)
                                    
                                    % Check if all samples during transmission
                                    % will be free in all channels
                                    occupancy_TXOP = occupancy_matrix(s+1:s+s_txop,ch_range);
                                    num_TXOP_samples = size(occupancy_TXOP,1);
                                    sum_next_TXOP_samples = sum(occupancy_TXOP,2);
                                    num_occupied_samples_in_TXOP = nnz(sum_next_TXOP_samples);
                                    next_TXOP_free = logical(num_occupied_samples_in_TXOP < COEFF_INT * num_TXOP_samples);
                                                                        
                                    if next_TXOP_free
                                        state = STATE_TX;
                                        past_access_deferred = false;
                                    else
                                        % If TX not possible, increase CW
                                        % and start another BO
                                        state = STATE_DIFS;
                                        c=0;
                                        b=0;
                                        num_preventions = num_preventions + 1;
                                        if m_BO < m_BO_max
                                            m_BO = m_BO + 1;
                                        end
                                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                                        %fprintf('TX failed!\n')
                                        
                                        past_access_deferred = true;
                                        past_s_bo = s;
                                        
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
                        % In TXOP, TX is granted to besuccessful
                        % ---- if next_TXOP_free
                        bw_ix = bw/BW_SC;
                        n_agg = Nagg_TXOP(bw_ix);
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];
                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;
                        % ---- end
                        
                        tx_bw = tx_bw + s_txop * BW_SC;
                        s = s + s_txop;
                        
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
            next_TXOP_free = true;
            past_access_deferred = false;
            past_s_bo = 0;
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
                                
                                if past_access_deferred 
                                    
                                    if s < past_s_bo+s_txop
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : s, ch_range);
                                    else
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : past_s_bo + s_txop, ch_range);
                                    end
                                    
                                    num_active_samples_in_potential_tx = sum(sum(occupancy_partial_past_TXOP));
                                    bw_enabled = bw_enabled + num_active_samples_in_potential_tx * BW_SC; 
                                end
                                
                                % Non-contiguous CB
                                occupancy_at_access = occupancy_matrix(s-1,1:NUM_RFs);
                                num_channels = sum(occupancy_at_access==0);
                                
                                % Get tx bandwidth
                                bw = num_channels * BW_SC;
                                ch_range = occupancy_at_access==0;
                                
                                s_txop = TXOP_samples;
                                
                                % Check if bw free during whole TXOP
                                if(s+s_txop <= num_samples)
                                    
                                    % Check if all samples during transmission
                                    % will be free in all channels
                                    occupancy_TXOP = occupancy_matrix(s+1:s+s_txop,ch_range);
                                    num_TXOP_samples = size(occupancy_TXOP,1);
                                    sum_next_TXOP_samples = sum(occupancy_TXOP,2);
                                    num_occupied_samples_in_TXOP = nnz(sum_next_TXOP_samples);
                                    next_TXOP_free = logical(num_occupied_samples_in_TXOP < COEFF_INT * num_TXOP_samples);
                                    
                                    if next_TXOP_free
                                        state = STATE_TX;
                                        past_access_deferred = false;
                                    else
                                        % If TX not possible, increase CW
                                        % and start another BO
                                        state = STATE_DIFS;
                                        c=0;
                                        b=0;
                                        num_preventions = num_preventions + 1;
                                        if m_BO < m_BO_max
                                            m_BO = m_BO + 1;
                                        end
                                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                                        %fprintf('TX failed!\n')
                                        
                                        past_access_deferred = true;
                                        past_s_bo = s;
                                        
                                    end
                                    
                                else    % Limit of samples shortly exceeded
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
                        % In TXOP, TX is granted to besuccessful
                        % ---- if next_TXOP_free
                        bw_ix = bw/BW_SC;
                        n_agg = Nagg_TXOP(bw_ix);
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];
                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;
                        % ---- end
                        
                        tx_bw = tx_bw + s_txop * BW_SC;
                        s = s + s_txop;
                        
                        state = STATE_DIFS;
                        c=0;
                        b=0;
                        
                    otherwise
                        error('State is not valid!')
                end
                
            end
            
            %% Single-channel
        case POLICY_SC
            
            % fprintf('\n\n SC policy with primary %d \n\n', primary_ch)
            
            num_channels = 1;
            s_txop = 0;
            past_access_deferred = false;
            past_s_bo = 0;
            
            while s < num_samples
                                
                % Is the sample busy?
                sample_busy = occupancy_matrix(s,primary_ch);
                %fprintf('s = %d: state = %d, c = %d, busy = %d\n', s, state, c, sample_busy);
                
                % fprintf('(%d)%d (%d, %d, %d) - ', sample_busy, s, state, c, b)
                
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
                                
                                if past_access_deferred 
                                    
                                    % fprintf('\n-----------------------------\n')
                                    % fprintf('Past access deferred%d\n')
                                    
                                    if s < past_s_bo+s_txop
                                        % fprintf('- s (%d) < past_s_bo+s_txop (%d)\n', s, past_s_bo+s_txop)
                                        % fprintf('+++ past_s_bo (%d)\n', past_s_bo)
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : s, primary_ch);
                                    else
                                        % fprintf('- s (%d) > past_s_bo+s_txop (%d)\n', s, past_s_bo+s_txop)
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : past_s_bo + s_txop, primary_ch);
                                    end
                                                                       
                                    num_active_samples_in_potential_tx = sum(sum(occupancy_partial_past_TXOP));
                                    bw_enabled = bw_enabled + num_active_samples_in_potential_tx * BW_SC; 
                                    
                                    % fprintf('- num_active_samples_in_potential_tx = %d\n', num_active_samples_in_potential_tx)
                                    
                                end
                                
                                % Get tx bandwidth
                                bw = 20;
                                
                                % Check if bw free during whole TXOP
                                s_txop = TXOP_samples;
                                
                                if(s+s_txop <= num_samples)
                                    
                                    occupancy_TXOP = occupancy_matrix(s+1:s+s_txop,primary_ch);
                                    num_TXOP_samples = length(occupancy_TXOP);
                                    num_occupied_samples_in_TXOP = sum(occupancy_TXOP);
                                    next_TXOP_free = logical(num_occupied_samples_in_TXOP < COEFF_INT * num_TXOP_samples);
                                    
                                    if next_TXOP_free
                                        state = STATE_TX;
                                        % fprintf('\nTX allowed!\n')
                                        past_access_deferred = false;
                                    else
                                        % If TX not possible, increase CW
                                        % and start another BO
                                        state = STATE_DIFS;
                                        c=0;
                                        b=0;
                                        num_preventions = num_preventions + 1;
                                        if m_BO < m_BO_max
                                            m_BO = m_BO + 1;
                                        end
                                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                                        
                                        % fprintf('\nTX deferred! s_BO = %d\n', s_BO)
                                        
                                        past_access_deferred = true;
                                        past_s_bo = s;
                                        
                                    end
                                else
                                    c=0;
                                    b=0;
                                    state = STATE_DIFS;
                                end
                                
                            end
                            
                        else % Busy sample
                            c = 0;
                            state = STATE_DIFS;
                        end
                        
                    case STATE_TX
                        
                        num_txs = num_txs + 1;
                        num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                        %fprintf('s = %d - Transmitting frame #%d...\n',s,num_txs)
                        
                        % In TXOP, TX is granted to besuccessful
                        % ---- if next_TXOP_free
                        bw_ix = bw/BW_SC;
                        n_agg = Nagg_TXOP(bw_ix);
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];
                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;
                        % ---- end
                        
                        tx_bw = tx_bw + s_txop * bw;
                        s = s + s_txop;
                        
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
            next_TXOP_free = true;
            past_access_deferred = false;
            past_s_bo = 0;
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
                                
                                if past_access_deferred 
                                    
                                    if s < past_s_bo+s_txop
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : s, ch_range);
                                    else
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : past_s_bo + s_txop, ch_range);
                                    end
                                    
                                    num_active_samples_in_potential_tx = sum(sum(occupancy_partial_past_TXOP));
                                    bw_enabled = bw_enabled + num_active_samples_in_potential_tx * BW_SC; 
                                end
                                
                                % Static Channel bonding
                                if primary_ch >= 1 && primary_ch <= 8
                                    
                                    % Check 160 MHz channels
                                    ch_range = 1:8;
                                    occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range);
                                    acess_free_8ch = ~logical(sum(occupancy_at_access,'all')>0);
                                    
                                    % SCB
                                    % If transmission possible in full band
                                    if acess_free_8ch
                                        
                                        num_channels = length(ch_range);
                                        
                                        % Get tx bandwidth
                                        bw = num_channels * BW_SC;
                                        
                                        s_txop = TXOP_samples;
			
                                        % Check if bw free during whole TXOP
                                        if(s+s_txop <= num_samples)
                                            
                                            % Check if all samples during transmission
                                            % will be free in all channels
                                            occupancy_TXOP = occupancy_matrix(s+1:s+s_txop,ch_range);
                                            num_TXOP_samples = size(occupancy_TXOP,1);
                                            sum_next_TXOP_samples = sum(occupancy_TXOP,2);
                                            num_occupied_samples_in_TXOP = nnz(sum_next_TXOP_samples);
                                            next_TXOP_free = logical(num_occupied_samples_in_TXOP < COEFF_INT * num_TXOP_samples);
                                            
                                            if next_TXOP_free
                                                past_access_deferred = false;
                                                state = STATE_TX;
                                            else
                                                % If TX not possible, increase CW
                                                % and start another BO
                                                state = STATE_DIFS;
                                                c=0;
                                                b=0;
                                                num_preventions = num_preventions + 1;
                                                if m_BO < m_BO_max
                                                    m_BO = m_BO + 1;
                                                end
                                                s_BO = 2^m_BO * s_BO_ORIGINAL;
                                                %fprintf('TX failed!\n')
                                                
                                                past_access_deferred = true;
                                                past_s_bo = s;
                                        
                                            end
                                        else    % Number of samples shortly exceeded
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
                       
                       num_txs = num_txs + 1;
                        num_txs_ch(num_channels + 1) = num_txs_ch(num_channels + 1) + 1;
                        %fprintf('s = %d - Transmitting frame #%d...\n',s,num_txs)
                        % In TXOP, TX is granted to besuccessful
                        % ---- if next_TXOP_free
                        bw_ix = bw/BW_SC;
                        n_agg = Nagg_TXOP(bw_ix);
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];
                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;
                        % ---- end

                        tx_bw = tx_bw + s_txop * BW_SC;
                        s = s + s_txop;

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
            past_access_deferred = false;
            past_s_bo = 0;
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
                                
                                if past_access_deferred 
                                    
                                    if s < past_s_bo+s_txop
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : s, ch_range);
                                    else
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : past_s_bo + s_txop, ch_range);
                                    end
                                    
                                    num_active_samples_in_potential_tx = sum(sum(occupancy_partial_past_TXOP));
                                    bw_enabled = bw_enabled + num_active_samples_in_potential_tx * BW_SC; 
                                end
                                
                                % Dynamic channel bonding
                                if primary_ch >= 1 && primary_ch <= 8
                                    
                                    % Check 160 MHz channels
                                    ch_range = 1:8;
                                    occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range);
                                    acess_free_8ch = ~logical(sum(occupancy_at_access,'all')>0);
                                    
                                    if ~acess_free_8ch
                                        
                                        % Check 80 MHz channels
                                        if primary_ch <= 4
                                            ch_range = 1:4;
                                        else
                                            ch_range = 5:8;
                                        end
                                        occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range);
                                        access_free_4ch = ~logical(sum(occupancy_at_access,'all')>0);
                                        
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
                                            occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range);
                                            access_free_2ch = ~logical(sum(occupancy_at_access,'all')>0);
                                            
                                            if ~access_free_2ch
                                                % Use 20 MHz channel
                                                ch_range = primary_ch;
                                            end
                                            
                                        end
                                        
                                    end
                                    
                                end
                                
                                num_channels = length(ch_range);
                                
                                % Get tx bandwidth
                                bw = num_channels * BW_SC;
                                
                                s_txop = TXOP_samples;
			
                                % Check if bw free during whole TXOP
                                if(s+s_txop <= num_samples)
                                    
                                    % Check if all samples during transmission
                                    % will be free in all channels
                                    occupancy_TXOP = occupancy_matrix(s+1:s+s_txop,ch_range);
                                    num_TXOP_samples = size(occupancy_TXOP,1);
                                    sum_next_TXOP_samples = sum(occupancy_TXOP,2);
                                    num_occupied_samples_in_TXOP = nnz(sum_next_TXOP_samples);
                                    next_TXOP_free = logical(num_occupied_samples_in_TXOP < COEFF_INT * num_TXOP_samples);
                                    
                                    if next_TXOP_free
                                        state = STATE_TX;
                                        past_access_deferred = false;
                                    else
                                       % If TX not possible, increase CW
                                        % and start another BO
                                        state = STATE_DIFS;
                                        c=0;
                                        b=0; 
                                        num_preventions = num_preventions + 1;
                                        if m_BO < m_BO_max
                                            m_BO = m_BO + 1;
                                        end
                                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                                        %fprintf('TX failed!\n')
                                        
                                        past_access_deferred = true;
                                        past_s_bo = s;
                                    end
                                else    % Number of samples shortly exceeded
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
                        % In TXOP, TX is granted to besuccessful
                        % ---- if next_TXOP_free
                        bw_ix = bw/BW_SC;
                        n_agg = Nagg_TXOP(bw_ix);
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];
                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;
                        % ---- end

                        tx_bw = tx_bw + s_txop * BW_SC;
                        s = s + s_txop;

                        state = STATE_DIFS;
                        c=0;
                        b=0; 
                        
                    otherwise
                        error('State is not valid!')
                end
                
            end
            
        case POLICY_PP
            num_channels = 1;
            num_channels_punctured = 0;
            past_access_deferred = false;
            past_s_bo = 0;
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
                                
                                if past_access_deferred 
                                    
                                    if s < past_s_bo+s_txop
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : s, ch_range);
                                    else
                                        occupancy_partial_past_TXOP =...
                                            occupancy_matrix(past_s_bo + 1 : past_s_bo + s_txop, ch_range);
                                    end
                                    
                                    num_active_samples_in_potential_tx = sum(sum(occupancy_partial_past_TXOP));
                                    bw_enabled = bw_enabled + num_active_samples_in_potential_tx * BW_SC; 
                                end
                                
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
                                    
                                    occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range);
                                    access_free_second20MHz = ~logical(sum(occupancy_at_access,'all')>0);
                                    
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
                                    occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range_40MHz_secondary_high);
                                    access_free_40MHz_secondary_high = ~logical(sum(occupancy_at_access,'all')>0);
                                    
                                    if access_free_40MHz_secondary_high
                                        ch_range = [ch_range ch_range_40MHz_secondary_high];
                                    end
                                    
                                    % Check secondary 40 MHz low
                                    occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range_40MHz_secondary_low);
                                    access_free_40MHz_secondary_low = ~logical(sum(occupancy_at_access,'all')>0);
                                    
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
                                        occupancy_at_access = occupancy_matrix(s-s_PIFS:s,ch_range_80MHz_other);
                                        access_free_80MHz_other = ~logical(sum(occupancy_at_access,'all')>0);
                                        
                                        if access_free_80MHz_other
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
                                if num_channels == 3
                                    num_channels_punctured = 1;
                                    num_channels = 4;
                                elseif num_channels == 6
                                    num_channels_punctured = 2;
                                    num_channels = 8;
                                elseif num_channels == 7
                                    num_channels_punctured = 1;
                                    num_channels = 8;
                                else
                                    num_channels_punctured = 0;
                                end
                                
                                % Get tx bandwidth
                                bw = num_channels * BW_SC;
                                
                                s_txop = TXOP_samples;
                                % Check if bw free during whole TXOP                                
                                if(s+s_txop <= num_samples)
                                    
                                    % Check if all samples during transmission
                                    % will be free in all channels
                                    occupancy_TXOP = occupancy_matrix(s+1:s+s_txop,ch_range);
                                    num_TXOP_samples = size(occupancy_TXOP,1);
                                    sum_next_TXOP_samples = sum(occupancy_TXOP,2);
                                    num_occupied_samples_in_TXOP = nnz(sum_next_TXOP_samples);
                                    next_TXOP_free = logical(num_occupied_samples_in_TXOP < COEFF_INT * num_TXOP_samples);
                                    
                                    if next_TXOP_free
                                        state = STATE_TX;
                                        past_access_deferred = false;
                                    else
                                        % If TX not possible, increase CW
                                        % and start another BO
                                        state = STATE_DIFS;
                                        c=0;
                                        b=0; 
                                        num_preventions = num_preventions + 1;
                                        if m_BO < m_BO_max
                                            m_BO = m_BO + 1;
                                        end
                                        s_BO = 2^m_BO * s_BO_ORIGINAL;
                                        %fprintf('TX failed!\n')
                                        
                                        past_access_deferred = true;
                                        past_s_bo = s;
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
                        % In TXOP, TX is granted to besuccessful
                        % ---- if next_TXOP_free
                        bw_ix = bw/BW_SC;
                        n_agg = Nagg_TXOP(bw_ix);
                        num_data_bits_sent = num_data_bits_sent + n_agg * L_D;
                        %fprintf('  - num_data_bits_sent = %d\n', num_data_bits_sent);
                        n_agg_array = [n_agg_array n_agg];
                        num_pkt_sent = num_pkt_sent + n_agg;
                        %fprintf('- num_pkt_sent = %d\n', num_pkt_sent)
                        m_BO = 0;
                        s_BO = s_BO_ORIGINAL;
                        % ---- end

                        tx_bw = tx_bw + s_txop * BW_SC;
                        s = s + s_txop;

                        state = STATE_DIFS;
                        c=0;
                        b=0;
                        
                    otherwise
                        error('State is not valid!')
                end
                
            end
            
    end
    
    
    throughput = num_data_bits_sent / (num_samples * T_SAMPLE);
    
    %num_txs_ch = mean(num_txs_ch);
    
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
    
    function Nagg_TXOP = txop_compute_num_agg_packets_per_bw()
        
        Nagg_TXOP = zeros(1,8); % No. of packets aggergated in a fix TXOP for 8 different bandwidths (20, 40, 60, ..., 160 MHz)
        
        for nagg_ix = 1:MAX_Nagg
            
            for bw_ix_aux = 1:length(Nagg_TXOP)
                
                if Nagg_TXOP(bw_ix_aux) == 0
                    
                    bw_aux = BW_SC * bw_ix_aux;
                    
                    if bw_aux == 20 || bw_aux == 40 || bw_aux == 80 || bw_aux == 160
                        t_data = get_data_tx_duration(nagg_ix,bw_aux,MCS,L_D);
                        s_data = round(t_data / T_SAMPLE);
                        s_data = s_data + s_OVERHEAD;
                    else
                        %Apply direct relation
                        t_data_sc = get_data_tx_duration(nagg_ix,BW_SC,MCS,L_D);
                        num_ch_aux = bw_aux / BW_SC;
                        s_data = round(t_data_sc / (T_SAMPLE * num_ch_aux ));
                        s_data = s_data + s_OVERHEAD;
                    end
                    
                    if s_data > TXOP_samples
                        Nagg_TXOP(bw_ix_aux) = nagg_ix - 1;
                    end
                    
                end
                
            end % For bw_ix ends
            
        end % For nagg_ix ends
        
        Nagg_TXOP(Nagg_TXOP==0) = MAX_Nagg;
        
    end % Function txop_compute_num_agg_packets_per_bw() ends
    
end

