function [occupancy] = generate_uniform_traffic(occupancy_in)
    %GENERATE_ONOFF_TRAFFIC Summary of this function goes here
    %   Input:
    %       - occupancy_in: binary occupancy matrix
    %   Output:
    %       - occupancy: synthetic binary occupancy. Matrix  NUM_TEMPORAL_SAMPLES x NUM_CHANNELS
    
    NUM_TEMPORAL_SAMPLES = size(occupancy_in,1);
    NUM_CHANNELS = size(occupancy_in,2);
    
    % Get mean occupancy in the band
    num_on_samples = sum(occupancy_in(:));
    prob_on = num_on_samples/(NUM_TEMPORAL_SAMPLES * NUM_CHANNELS);    % Array 1 x NUM_CHANNELS
    
    % Generate matrix
    occupancy = rand(NUM_TEMPORAL_SAMPLES, NUM_CHANNELS);
    occupancy(occupancy<=prob_on) = 1;
    occupancy(occupancy~=1) = 0;

end

