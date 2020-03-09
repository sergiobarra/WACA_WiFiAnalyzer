function [rssi_matrix,RF_XTICK_LABELS,num_total_rssi_samples_downsampled, num_rssi_samples, num_iterations, downsample_factor_rssi] = ...
        load_data_samples_unii2ext(data_path,first_iteration,last_iteration, NUM_RFs)
    %LOAD_DATA_SAMPLES Summary of this function goes here
    %   Detailed explanation goes here
    
    %% Load RSSI samples
    
    %     fprintf('Opening experiments folder %s...\n', data_path);
    % Metadata of the experiment (e.g., num_iterations or downsample_factor_rssi)
    data_path_general = [data_path '/experiment_general.mat'];
    load(data_path_general)
    [msg, id] = lastwarn;
    warning('off', id)
    %     fprintf('- Loading experiments meta data %s...\n', data_path);
    
    RF_XTICK_LABELS = [RX_CHANNEL_AC_A_a RX_CHANNEL_AC_B_a RX_CHANNEL_AC_C_a RX_CHANNEL_AC_D_a...
        RX_CHANNEL_AC_A_b RX_CHANNEL_AC_B_b RX_CHANNEL_AC_C_b RX_CHANNEL_AC_D_b...
        RX_CHANNEL_AC_A_c RX_CHANNEL_AC_B_c RX_CHANNEL_AC_C_c RX_CHANNEL_AC_D_c...
        RX_CHANNEL_AC_A_d RX_CHANNEL_AC_B_d RX_CHANNEL_AC_C_d RX_CHANNEL_AC_D_d...
        RX_CHANNEL_AC_A_e RX_CHANNEL_AC_B_e RX_CHANNEL_AC_C_e RX_CHANNEL_AC_D_e...
        RX_CHANNEL_AC_A_f RX_CHANNEL_AC_B_f RX_CHANNEL_AC_C_f RX_CHANNEL_AC_D_f];
    
    if last_iteration > 0 && last_iteration <= num_iterations
        num_iterations = last_iteration - first_iteration + 1;
    end
    
    % Print experiment details
    %     fprintf('EXPERIMENT METADATA:\n');
    %     fprintf('- Containing folder: %s\n', data_path);
    %     fprintf('- No. of considered iterations: %d\n', num_iterations);
    %     fprintf('- Sniff duration: %.2f ms\n', num_ms_sniff);
    
    % downsample_factor_rssi = 1;
    % num_iterations = 2;
    num_total_rssi_samples_downsampled = num_rssi_samples*num_iterations/downsample_factor_rssi;
    num_iteration_rssi_samples = num_rssi_samples/downsample_factor_rssi;
    x_axis_values = ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations)';
    
    rssi_matrix = zeros(num_total_rssi_samples_downsampled,NUM_RFs);        % Whole RSSI samples of each RF (RSSI value)
    
    for it = first_iteration:last_iteration
        %         fprintf('- Loading iteration %d...\n', it);
        dir_it = dir(fullfile(data_path,'*.mat'));
        filenames_it = {dir_it.name};
        % found_it = ~cellfun('isempty',strfind(filenames_it,['it' num2str(it, '%04d')]));
        if it<=9999
            found_it = ~cellfun('isempty',strfind(filenames_it,['it' num2str(it, '%04d') '_']));
        else
            found_it = ~cellfun('isempty',strfind(filenames_it,['it' num2str(it, '%05d') '_']));
        end
        
        
        iteration_path = [data_path '/' filenames_it{found_it}];
        
        % a
        aux = load(iteration_path,'rssi_temporal_A_a');
        aux = aux.('rssi_temporal_A_a');
        rssi_temporal_A_a = [rssi_temporal_A_a; aux];
        
        aux = load(iteration_path,'rssi_temporal_B_a');
        aux = aux.('rssi_temporal_B_a');
        rssi_temporal_B_a = [rssi_temporal_B_a; aux];
        
        aux = load(iteration_path,'rssi_temporal_C_a');
        aux = aux.('rssi_temporal_C_a');
        rssi_temporal_C_a = [rssi_temporal_C_a; aux];
        
        aux = load(iteration_path,'rssi_temporal_D_a');
        aux = aux.('rssi_temporal_D_a');
        rssi_temporal_D_a = [rssi_temporal_D_a; aux];
        
        % b
        aux = load(iteration_path,'rssi_temporal_A_b');
        aux = aux.('rssi_temporal_A_b');
        rssi_temporal_A_b = [rssi_temporal_A_b; aux];
        
        aux = load(iteration_path,'rssi_temporal_B_b');
        aux = aux.('rssi_temporal_B_b');
        rssi_temporal_B_b = [rssi_temporal_B_b; aux];
        
        aux = load(iteration_path,'rssi_temporal_C_b');
        aux = aux.('rssi_temporal_C_b');
        rssi_temporal_C_b = [rssi_temporal_C_b; aux];
        
        aux = load(iteration_path,'rssi_temporal_D_b');
        aux = aux.('rssi_temporal_D_b');
        rssi_temporal_D_b = [rssi_temporal_D_b; aux];
        
        % c
        aux = load(iteration_path,'rssi_temporal_A_c');
        aux = aux.('rssi_temporal_A_c');
        rssi_temporal_A_c = [rssi_temporal_A_c; aux];
        
        aux = load(iteration_path,'rssi_temporal_B_c');
        aux = aux.('rssi_temporal_B_c');
        rssi_temporal_B_c = [rssi_temporal_B_c; aux];
        
        aux = load(iteration_path,'rssi_temporal_C_c');
        aux = aux.('rssi_temporal_C_c');
        rssi_temporal_C_c = [rssi_temporal_C_c; aux];
        
        aux = load(iteration_path,'rssi_temporal_D_c');
        aux = aux.('rssi_temporal_D_c');
        rssi_temporal_D_c = [rssi_temporal_D_c; aux];
        
        % d
        aux = load(iteration_path,'rssi_temporal_A_d');
        aux = aux.('rssi_temporal_A_d');
        rssi_temporal_A_d = [rssi_temporal_A_d; aux];
        
        aux = load(iteration_path,'rssi_temporal_B_d');
        aux = aux.('rssi_temporal_B_d');
        rssi_temporal_B_d = [rssi_temporal_B_d; aux];
        
        aux = load(iteration_path,'rssi_temporal_C_d');
        aux = aux.('rssi_temporal_C_d');
        rssi_temporal_C_d = [rssi_temporal_C_d; aux];
        
        aux = load(iteration_path,'rssi_temporal_D_d');
        aux = aux.('rssi_temporal_D_d');
        rssi_temporal_D_d = [rssi_temporal_D_d; aux];
        
        % e
        aux = load(iteration_path,'rssi_temporal_A_e');
        aux = aux.('rssi_temporal_A_e');
        rssi_temporal_A_e = [rssi_temporal_A_e; aux];
        
        aux = load(iteration_path,'rssi_temporal_B_e');
        aux = aux.('rssi_temporal_B_e');
        rssi_temporal_B_e = [rssi_temporal_B_e; aux];
        
        aux = load(iteration_path,'rssi_temporal_C_e');
        aux = aux.('rssi_temporal_C_e');
        rssi_temporal_C_e = [rssi_temporal_C_e; aux];
        
        aux = load(iteration_path,'rssi_temporal_D_e');
        aux = aux.('rssi_temporal_D_e');
        rssi_temporal_D_e = [rssi_temporal_D_e; aux];
        
        % f
        aux = load(iteration_path,'rssi_temporal_A_f');
        aux = aux.('rssi_temporal_A_f');
        rssi_temporal_A_f = [rssi_temporal_A_f; aux];
        
        aux = load(iteration_path,'rssi_temporal_B_f');
        aux = aux.('rssi_temporal_B_f');
        rssi_temporal_B_f = [rssi_temporal_B_f; aux];
        
        aux = load(iteration_path,'rssi_temporal_C_f');
        aux = aux.('rssi_temporal_C_f');
        rssi_temporal_C_f = [rssi_temporal_C_f; aux];
        
        aux = load(iteration_path,'rssi_temporal_D_f');
        aux = aux.('rssi_temporal_D_f');
        rssi_temporal_D_f = [rssi_temporal_D_f; aux];
    end
    
    % Generate RSSI matrix
    % - SERGIO: MODIFIED ON 2 JULY 2019
    % - Pick RFs assigned to UNII2-ext 100 to 128
    if NUM_RFs == 8
        rssi_matrix(:,1) = rssi_temporal_A_c;
        rssi_matrix(:,2) = rssi_temporal_B_c;
        rssi_matrix(:,3) = rssi_temporal_C_c;
        rssi_matrix(:,4) = rssi_temporal_D_c;
        rssi_matrix(:,5) = rssi_temporal_A_d;
        rssi_matrix(:,6) = rssi_temporal_B_d;
        rssi_matrix(:,7) = rssi_temporal_C_d;
        rssi_matrix(:,8) = rssi_temporal_D_d;
    else
        rssi_matrix(:,1) = rssi_temporal_A_a;
        rssi_matrix(:,2) = rssi_temporal_B_a;
        rssi_matrix(:,3) = rssi_temporal_C_a;
        rssi_matrix(:,4) = rssi_temporal_D_a;
        rssi_matrix(:,5) = rssi_temporal_A_b;
        rssi_matrix(:,6) = rssi_temporal_B_b;
        rssi_matrix(:,7) = rssi_temporal_C_b;
        rssi_matrix(:,8) = rssi_temporal_D_b;
        rssi_matrix(:,9) = rssi_temporal_A_c;
        rssi_matrix(:,10) = rssi_temporal_B_c;
        rssi_matrix(:,11) = rssi_temporal_C_c;
        rssi_matrix(:,12) = rssi_temporal_D_c;
        rssi_matrix(:,13) = rssi_temporal_A_d;
        rssi_matrix(:,14) = rssi_temporal_B_d;
        rssi_matrix(:,15) = rssi_temporal_C_d;
        rssi_matrix(:,16) = rssi_temporal_D_d;
        rssi_matrix(:,17) = rssi_temporal_A_e;
        rssi_matrix(:,18) = rssi_temporal_B_e;
        rssi_matrix(:,19) = rssi_temporal_C_e;
        rssi_matrix(:,20) = rssi_temporal_D_e;
        rssi_matrix(:,21) = rssi_temporal_A_f;
        rssi_matrix(:,22) = rssi_temporal_B_f;
        rssi_matrix(:,23) = rssi_temporal_C_f;
        rssi_matrix(:,24) = rssi_temporal_D_f;
    end
    
end

