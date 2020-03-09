function [occupancy_matrix,num_peaks] = get_occupancy(rssi_matrix,peak_threshold,...
        num_total_rssi_samples_downsampled, num_iterations, num_rssi_samples, downsample_factor_rssi, NUM_RFs)
    %GET_OCCUPANCY Summary of this function goes here
    %   Detailed explanation goes here
    
    %% Identify occupancy
    % Get occupancy_matrix
    occupancy_matrix = zeros(num_total_rssi_samples_downsampled,NUM_RFs);   % Whole occupancy samples of each RF (boolean)
    num_peaks = zeros(NUM_RFs,1);
    for rf = 1:NUM_RFs
        occupancy_matrix(:,rf) = logical(rssi_matrix(:,rf)>peak_threshold);
        rssi = rssi_matrix(:,rf);
        peak_samples = rssi(rssi > peak_threshold);
        num_peaks(rf,1) = length(peak_samples);
    end

end

