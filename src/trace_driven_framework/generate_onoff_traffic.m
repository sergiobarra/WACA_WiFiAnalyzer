function [occupancy, prob_on, t_on_avg, t_off_avg] = generate_onoff_traffic(occupancy_in)
    %GENERATE_ONOFF_TRAFFIC Summary of this function goes here
    %   Input:
    %       - occupancy_in: binary occupancy matrix
    %   Output:
    %       - occupancy: synthetic binary occupancy. Matrix  NUM_TEMPORAL_SAMPLES x NUM_CHANNELS
    %       - prob_on: probability the system is on (busy). Array 1 x NUM_CHANNELS
    %       - t_on_avg: mean duration when being at state ON. Array 1 x NUM_CHANNELS
    %       - t_off_avg: mean duration when being at state OFF. Array 1 x NUM_CHANNELS
    
%     % Test config
%     A = [0 0 0 1 1 1 1 0 1 1 0 0 0 0 0 0 1 1 1 1 1;
%         1 1 1 0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1];
%     A = [A';A';A'];
%     occupancy_in = A;
%     % End test config ----
    
    NUM_TEMPORAL_SAMPLES = size(occupancy_in,1);
    NUM_CHANNELS = size(occupancy_in,2);
    num_on_samples = sum(occupancy_in,1);           % Array 1 x NUM_CHANNELS
    prob_on = num_on_samples/NUM_TEMPORAL_SAMPLES;    % Array 1 x NUM_CHANNELS
    
    t_on_avg = zeros(1,NUM_CHANNELS);
    t_off_avg = zeros(1,NUM_CHANNELS);
    for ch_ix = 1:NUM_CHANNELS
        
        occupancy_ch = occupancy_in(:,ch_ix);
        idle_ch = ~occupancy_in(:,ch_ix);
        
        % ON duration
        out = double(diff([~occupancy_ch(1);occupancy_ch(:)]) == 1);
        v = accumarray(cumsum(out).*occupancy_ch(:)+1,1);
        out(out == 1) = v(2:end);
        t_on_avg(ch_ix) = mean(out(out~=0));
        
        % OFF duration
        out = double(diff([~idle_ch(1);idle_ch(:)]) == 1);
        v = accumarray(cumsum(out).*idle_ch(:)+1,1);
        out(out == 1) = v(2:end);
        t_off_avg(ch_ix) = mean(out(out~=0));
    end
    
    % Generate matrix
    occupancy = zeros(NUM_TEMPORAL_SAMPLES, NUM_CHANNELS);
    
    for ch_ix = 1:NUM_CHANNELS
        
%         fprintf('*** ch_ix = %d ***\n', ch_ix)
        occupancy_ch = zeros(NUM_TEMPORAL_SAMPLES, 1);
        t_off_mean = t_off_avg(ch_ix);
        t_on_mean = t_on_avg(ch_ix);
%         fprintf('- t_off_mean = %.2f\n', t_off_mean)
%         fprintf('- t_on_mean = %.2f\n', t_on_mean)
        
        keep_generation = true;
        current_state = 0;  % Initialize at OFF state
        count = 1;
        
        while keep_generation
%             fprintf('-----------------\n')
%             fprintf('- count = %d\n', count)
            
            if count < NUM_TEMPORAL_SAMPLES
                
                if current_state == 0
                    t_exp = round(exprnd(t_off_mean));
                    if t_exp > 0
                        occupancy_ch(count:count+t_exp) = 0;
                    end                   
                    current_state = 1;
                else
                    t_exp = round(exprnd(t_on_mean));
                    if t_exp > 0
                        occupancy_ch(count:count+t_exp) = 1;
                    end
                    current_state = 0;
                end
                
                count = count + t_exp;
                
            else
                keep_generation = false;
            end
        end
        
        occupancy(:,ch_ix) = occupancy_ch(1:NUM_TEMPORAL_SAMPLES)';
        
        
%         num_on_samples_out = sum(occupancy,1);           % Array 1 x NUM_CHANNELS
%         prob_on_out = num_on_samples_out/NUM_TEMPORAL_SAMPLES;    % Array 1 x NUM_CHANNELS
%         
%         prob_on
%         prob_on_out
    end
    
end

