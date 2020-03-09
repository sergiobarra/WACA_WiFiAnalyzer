%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trace_driven_data_process_aggregation.m
% 
% For processing WACA measurements through trace-driven simulations:
%   * x2 160-MHz bands separately considered:
%       - U-NII-1 & U-NII-2: channels 36 to 64 (1 to 8)
%       - Part of U-NII-2c: channels 100 to 128 (1 to 8)
%   * Variable number of data packets aggregated per frame
%	* This file generates mat files with filenames of the form:
%		- "results_subiterations_<DURATION_OBSERVATION_SAMPLES>ms.mat" for the locations NOT including FCB
%		- "results_subiterations_FCB_<DURATION_OBSERVATION_SAMPLES>ms.mat" for the FCB location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear
clc

%% Setup

% Experiment folder directories (DO NOT CHANGE)
experiment_folder_name_1_rva = 'final_dataset\1_RVA\02-15-19_23-15-00_ms1000_it9600';    % 1_RVA
experiment_folder_name_2_lab = 'final_dataset\2_RNG\02-19-19_08-03-09_ms1000_it9600';    % 2_LAB (8750 iterations)
experiment_folder_name_3_tfa ='final_dataset\3_TFA\02-20-19_11-58-01_ms1000_it9600';     % 3_TFA (8609 iterations)
experiment_folder_name_4_flo ='final_dataset\4_FLO\02-23-19_18-24-52_ms1000_it600';     % 4_FLO (412 iterations)
experiment_folder_name_5_vil = 'final_dataset\5_VIL\02-23-19_19-59-33_ms1000_it442';    % 5_VIL (125 iterations)
experiment_folder_name_6_fel = 'final_dataset\6_FEL\03-25-19_20-10-46_ms1000_it59500';    % 6_FEL
experiment_folder_name_7_wno = 'final_dataset\7_WNO\04-03-19_18-10-00_ms1000_it9600';    % 7_ALB
experiment_folder_name_8_22a = 'final_dataset\8_22A\07-02-19_16-56-16_ms1000_it9600';    % 8_22@ (9600 iterations)
experiment_folder_name_9_hot = 'final_dataset\9_GAL\07-10-19_16-38-58_ms1000_it12000';   % 9_HOT (9706)
experiment_folder_name_10_sag = 'final_dataset\10_SAG\07-11-19_18-03-07_ms1000_it40000';   % 10_SAG (38192 iterations)
experiment_folder_name_11_fcb = 'final_dataset\11_FCB\08-04-19_17-24-00_ms1000_it6000';   % 11_FCB (2001 iterations)

experiment_folders = {experiment_folder_name_1_rva; experiment_folder_name_2_lab; experiment_folder_name_3_tfa;...
    experiment_folder_name_4_flo; experiment_folder_name_5_vil; experiment_folder_name_6_fel;...
    experiment_folder_name_7_wno; experiment_folder_name_8_22a; experiment_folder_name_9_hot;...
    experiment_folder_name_10_sag; experiment_folder_name_11_fcb};

scenario_codes = {'1RVA', '2RNG', '3TFA', '4FLO', '5VIL', '6FEL', '7WNO', '822A', '9HOT', '10SAG', '11FCB'};

DURATION_OBSERVATION_SAMPLES_MS = 100 * 1E-3; % Observation duration [s]

scenarios_ix_to_simulate = [1 2 3 4 5 6 7 8 9 10];
%scenarios_ix_to_simulate = [11];

%Nagg_VALUES = 1:64;
Nagg_VALUES = 0:4:256;
Nagg_VALUES(1) = 1;
num_Nagg = length(Nagg_VALUES);

out_filename = ['results_subiterations_' num2str(DURATION_OBSERVATION_SAMPLES_MS * 1E3) 'ms_20Dec2019.mat'];
%out_filename = ['results_subiterations_' num2str(DURATION_OBSERVATION_SAMPLES_MS * 1E3) 'ms_FCB_Na.mat'];

L_D = 12000;

peak_threshold = 150;       % Peak threshold in RSSI 1024-units
NUM_RFs = 8;               % No. of RFs in the system (do not change this)
NUM_RSSI_SAMPLES_ITERATION_DOWNSAMPLED = 1E5;   % 1E5 samples of 10 us in 1 second
duration_subit = DURATION_OBSERVATION_SAMPLES_MS;   % Duration of contiguous samples in a subiteration [s]
DURATION_ITERATION = 1; % Duration of an iteration [s]
num_subit_in_it = DURATION_ITERATION /  duration_subit;
num_rssi_samples_down_subit = NUM_RSSI_SAMPLES_ITERATION_DOWNSAMPLED / num_subit_in_it;

POLICY_CBCONT = 1;
POLICY_CBNONCONT = 2;
POLICY_SC = 3;
POLICY_SCB = 4;
POLICY_DCB = 5;
POLICY_PP = 6;

HIDDEN_COEFF_INT = 0.01;

%% Output parameters

% *** Simulated ***
throughput_per_ch_per_Nagg_cb_cont = []; % NUM_subits x NUM_RFs x NUM_Nagg
throughput_per_ch_per_Nagg_cb_noncont = []; % NUM_subits x NUM_RFs x NUM_Nagg
throughput_per_ch_per_Nagg_sc = []; % NUM_subits x NUM_RFs x NUM_Nagg
throughput_per_ch_per_Nagg_scb = []; % NUM_subits x NUM_RFs x NUM_Nagg
throughput_per_ch_per_Nagg_dcb = []; % NUM_subits x NUM_RFs x NUM_Nagg
throughput_per_ch_per_Nagg_pp = []; % NUM_subits x NUM_RFs x NUM_Nagg


%% PROCESS & SIMULATION

subit_ix_offset = 0;
duration_observation_ix = 1;

for scenario_ix = 1:length(scenarios_ix_to_simulate)
    
    scenario = scenarios_ix_to_simulate(scenario_ix);
    scenario_code = scenario_codes{scenario};
    
    filename = ['subiterations_occupancy_5percent_'...
        num2str(DURATION_OBSERVATION_SAMPLES_MS*1E3)...
        'ms_' scenario_code '.mat'];
    
    fprintf('Loading scenario %s: %s\n', scenario_code, filename)
    
    % Load index of target samples
    occupied_subit_unii12_ix = cell2mat(struct2cell(load(filename, 'occupied_subit_unii12_ix')));
    occupied_subit_unii2ext_ix = cell2mat(struct2cell(load(filename, 'occupied_subit_unii2ext_ix')));
    
    num_subits_unii12 = length(occupied_subit_unii12_ix);
    num_subits_unii2ext = length(occupied_subit_unii2ext_ix);
    
    fprintf(' - num_subits_unii12: %d - num_subits_unii2ext = %d\n', num_subits_unii12, num_subits_unii2ext)
    
    experiment_folder_name = experiment_folders{scenario};
    
    data_path = ['experiments/sniff/' experiment_folder_name];
    data_path_general = [data_path '/experiment_general.mat'];
    load(data_path_general)
    
    % Process subiterations
    for subit_ix = 1:num_subits_unii12 + num_subits_unii2ext
        
        
        general_subit_ix = subit_ix + subit_ix_offset;
        
        if subit_ix <= num_subits_unii12
            
            fprintf('    + Location %d (UNII-1&2): %d/%d, general_subit_ix: %d - subit_ix_offset = %d\n',...
                scenario, subit_ix, num_subits_unii12,  general_subit_ix,subit_ix_offset)
            % Detect target subiteration
            subit = occupied_subit_unii12_ix(subit_ix);
            
        else
            fprintf('    + Location %d (UNII-2ext): %d/%d, general_subit_ix: %d - subit_ix_offset = %d\n',...
                scenario, subit_ix - num_subits_unii12, num_subits_unii2ext , general_subit_ix,subit_ix_offset)
            % Detect target subiteration
            subit = occupied_subit_unii2ext_ix(subit_ix - num_subits_unii12);
            
        end
        
        it = ceil(subit/num_subit_in_it);
        subit_in_it = mod(subit, num_subit_in_it);
        if subit_in_it == 0
            subit_in_it = num_subit_in_it;
        end
        
        %fprintf('       - subit = %d, it = %d, subit_in_it = %d \n', subit, it, subit_in_it)
        
        if subit_ix <= num_subits_unii12
            % Get RSSI of full it
            [rssi_matrix,RF_XTICK_LABELS,num_total_rssi_samples_downsampled, num_rssi_samples, num_iterations, downsample_factor_rssi] = ...
                load_data_samples(data_path,it,it, NUM_RFs);
            
        else
            % Get RSSI of full it
            [rssi_matrix,RF_XTICK_LABELS,num_total_rssi_samples_downsampled, num_rssi_samples, num_iterations, downsample_factor_rssi] = ...
                load_data_samples_unii2ext(data_path,it,it, NUM_RFs);
        end
        
        [occupancy_matrix,~] = get_occupancy(rssi_matrix,peak_threshold,...
            num_total_rssi_samples_downsampled, num_iterations, num_rssi_samples, downsample_factor_rssi, NUM_RFs);
        
        ix_first = (subit_in_it - 1) * num_rssi_samples_down_subit + 1;
        ix_last = ix_first + num_rssi_samples_down_subit - 1;
        
        %fprintf('ix_first = %d - ix_last = %d - it = %d - subit_in_it = %d\n', ix_first, ix_last);
        
        %% Unsimulated parameters
        % - Occcupancy
        occupancy_subit = occupancy_matrix(ix_first:ix_last, :);
        
        
        %% Simulation
        for N_agg_ix = 1:num_Nagg
            
            N_agg = Nagg_VALUES(N_agg_ix);
            
            %fprintf('*** N_agg: %d\n',N_agg)
            %% Throughput simulation
            
            for rf = 1:NUM_RFs
                
            % CB-cont hidden
            throughput_per_ch_per_Nagg_cb_cont(general_subit_ix,rf,N_agg_ix) =...
                throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_CBCONT,N_agg,L_D, NUM_RFs, HIDDEN_COEFF_INT);
            
            % CB-noncont hidden
            throughput_per_ch_per_Nagg_cb_noncont(general_subit_ix,rf,N_agg_ix) =...
                throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_CBNONCONT,N_agg,L_D, NUM_RFs, HIDDEN_COEFF_INT);
            
            % SC
            throughput_per_ch_per_Nagg_sc(general_subit_ix,rf,N_agg_ix) =...
                throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_SC,N_agg,L_D, NUM_RFs, HIDDEN_COEFF_INT);
            
            % SCB-hidden
             throughput_per_ch_per_Nagg_scb(general_subit_ix,rf,N_agg_ix) =...
                throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_SCB,N_agg,L_D, NUM_RFs, HIDDEN_COEFF_INT);
            
            % DCB-hidden
             throughput_per_ch_per_Nagg_dcb(general_subit_ix,rf,N_agg_ix) =...
                throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_DCB,N_agg,L_D, NUM_RFs, HIDDEN_COEFF_INT);

            % PP-hidden
            throughput_per_ch_per_Nagg_pp(general_subit_ix,rf,N_agg_ix) =...
                throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_PP,N_agg,L_D, NUM_RFs, HIDDEN_COEFF_INT);
            
            end
            
            %         fprintf('Throughputs [Mbps]: SC = %.2f, SCB = %.2f, DCB = %.2f, PP = %.2f\n',...
            %             av_throughput_sc, av_throughput_scb, av_throughput_dcb, av_throughput_pp)
            
        end
    end
    subit_ix_offset = subit_ix_offset + num_subits_unii12 + num_subits_unii2ext;
end
save(out_filename);


