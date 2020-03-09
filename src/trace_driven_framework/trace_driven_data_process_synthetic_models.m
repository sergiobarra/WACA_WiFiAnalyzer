%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trace_driven_data_process_synthetic_models.m
% 
% For processing syntethic datasets coming from WACA measurements through trace-driven simulations:
%   * x2 160-MHz bands separately considered:
%       - U-NII-1 & U-NII-2: channels 36 to 64 (1 to 8)
%       - Part of U-NII-2c: channels 100 to 128 (1 to 8)
%   * 2 syntethic occupancy models considered:
%       - Uniform i.i.d.
%       - Markov ON/OFF
%	* This file generates mat files with filenames of the form:
%		- "results_subiterations_<DURATION_OBSERVATION_SAMPLES>ms.mat" for the locations NOT including FCB
%		- "results_subiterations_FCB_<DURATION_OBSERVATION_SAMPLES>ms.mat" for the FCB location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear
clc

% diary 'log.txt'

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

%scenarios_ix_to_simulate = [1 2 3 4 5 6 7 8 9 10];
scenarios_ix_to_simulate = [11];

N_agg_max = 64;
%N_agg_max = 256;
L_D = 12000;
        
DURATION_OBSERVATION_SAMPLES_MS = 100 * 1E-3; % Observation duration [s]

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

% *** Unsimulated ***
av_occupancy_subits = [];   % NUM_subits
av_sparsity_subits = [];    % NUM_subits
av_spectral_change_freq_subits = [];    % NUM_subits
av_spectral_variability_sum = [];
av_spectral_variability_max = [];
av_temporal_change_freq_subits = [];    % NUM_subits
av_per_ch_temporal_change_freq_subits = [];    % NUM_subits x NUM_RFs

av_tidle = [];              % NUM_subits x NUM_RFs
av_corr = [];               % NUM_subits x NUM_RFs
corr_matrices = [];         % NUM_subits x NUM_RFs x NUM_RFs

% *** Simulated ***

% +++ Trhoughput
% ------ Hinder
av_throughput_sc_hinder_subits = [];             % NUM_subits x NUM_RFs
av_throughput_cb_cont_hinder_subits = [];        % NUM_subits x NUM_RFs
av_throughput_cb_noncont_hinder_subits = [];     % NUM_subits x NUM_RFs
av_throughput_scb_hinder_subits = [];            % NUM_subits x NUM_RFs
av_throughput_dcb_hinder_subits = [];            % NUM_subits x NUM_RFs
av_throughput_pp_hinder_subits = [];             % NUM_subits x NUM_RFs
% ------ Hidden
av_throughput_sc_hidden_subits = [];             % NUM_subits x NUM_RFs
av_throughput_cb_cont_hidden_subits = [];        % NUM_subits x NUM_RFs
av_throughput_cb_noncont_hidden_subits = [];     % NUM_subits x NUM_RFs
av_throughput_scb_hidden_subits = [];            % NUM_subits x NUM_RFs
av_throughput_dcb_hidden_subits = [];            % NUM_subits x NUM_RFs
av_throughput_pp_hidden_subits = [];             % NUM_subits x NUM_RFs
% ------ TXOP
av_throughput_sc_TXOP_subits = [];                 % NUM_subits x NUM_RFs
av_throughput_cb_cont_TXOP_subits = [];            % NUM_subits x NUM_RFs
av_throughput_cb_noncont_TXOP_subits = [];         % NUM_subits x NUM_RFs
av_throughput_scb_TXOP_subits = [];                % NUM_subits x NUM_RFs
av_throughput_dcb_TXOP_subits = [];                % NUM_subits x NUM_RFs
av_throughput_pp_TXOP_subits = [];                 % NUM_subits x NUM_RFs

% +++ No. of TXs (channel accesses)
% ------ Hinder
num_txs_sc_hinder_subits = [];          % NUM_subits x NUM_RFs
num_txs_cb_cont_hinder_subits = [];     % NUM_subits x NUM_RFs
num_txs_cb_noncont_hinder_subits = [];  % NUM_subits x NUM_RFs
num_txs_scb_hinder_subits = [];         % NUM_subits x NUM_RFs
num_txs_dcb_hinder_subits = [];         % NUM_subits x NUM_RFs
num_txs_pp_hinder_subits = [];          % NUM_subits x NUM_RFs

% +++ No. of TX channels (when accessing the channel)
% ------ Hinder
av_numtxch_sc_hinder_subits = [];             % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_cb_cont_hinder_subits = [];        % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_cb_noncont_hinder_subits = [];     % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_scb_hinder_subits = [];            % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_dcb_hinder_subits = [];            % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_pp_hinder_subits = [];             % NUM_subits x NUM_RFs x (NUM_RFs + 1)
% ------ Hidden
av_numtxch_sc_hidden_subits = [];             % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_cb_cont_hidden_subits = [];        % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_cb_noncont_hidden_subits = [];     % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_scb_hidden_subits = [];            % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_dcb_hidden_subits = [];            % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_pp_hidden_subits = [];             % NUM_subits x NUM_RFs x (NUM_RFs + 1)
% ------ TXOP
av_numtxch_sc_TXOP_subits = [];                 % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_cb_cont_TXOP_subits = [];            % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_cb_noncont_TXOP_subits = [];         % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_scb_TXOP_subits = [];                % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_dcb_TXOP_subits = [];                % NUM_subits x NUM_RFs x (NUM_RFs + 1)
av_numtxch_pp_TXOP_subits = [];                 % NUM_subits x NUM_RFs x (NUM_RFs + 1)

% +++ BW efficiency
% ------ Hinder
av_bweff_sc_hinder_subits = [];             % NUM_subits x NUM_RFs
av_bweff_cb_cont_hinder_subits = [];        % NUM_subits x NUM_RFs
av_bweff_cb_noncont_hinder_subits = [];     % NUM_subits x NUM_RFs
av_bweff_scb_hinder_subits = [];            % NUM_subits x NUM_RFs
av_bweff_dcb_hinder_subits = [];            % NUM_subits x NUM_RFs
av_bweff_pp_hinder_subits = [];             % NUM_subits x NUM_RFs
% ------ Hidden
av_bweff_sc_hidden_subits = [];             % NUM_subits x NUM_RFs
av_bweff_cb_cont_hidden_subits = [];        % NUM_subits x NUM_RFs
av_bweff_cb_noncont_hidden_subits = [];     % NUM_subits x NUM_RFs
av_bweff_scb_hidden_subits = [];            % NUM_subits x NUM_RFs
av_bweff_dcb_hidden_subits = [];            % NUM_subits x NUM_RFs
av_bweff_pp_hidden_subits = [];             % NUM_subits x NUM_RFs
% ------ TXOP
av_bweff_sc_TXOP_subits = [];                 % NUM_subits x NUM_RFs
av_bweff_cb_cont_TXOP_subits = [];            % NUM_subits x NUM_RFs
av_bweff_cb_noncont_TXOP_subits = [];         % NUM_subits x NUM_RFs
av_bweff_scb_TXOP_subits = [];                % NUM_subits x NUM_RFs
av_bweff_dcb_TXOP_subits = [];                % NUM_subits x NUM_RFs
av_bweff_pp_TXOP_subits = [];                 % NUM_subits x NUM_RFs

% +++ BW prevention
% ------ Hinder (that prevents)
av_bwprev_sc_hinder_subits = [];             % NUM_subits x NUM_RFs x NUM_RFs
av_bwprev_cb_cont_hinder_subits = [];        % NUM_subits x NUM_RFs x NUM_RFs
av_bwprev_cb_noncont_hinder_subits = [];     % NUM_subits x NUM_RFs x NUM_RFs
av_bwprev_scb_hinder_subits = [];            % NUM_subits x NUM_RFs x NUM_RFs
av_bwprev_dcb_hinder_subits = [];            % NUM_subits x NUM_RFs x NUM_RFs
av_bwprev_pp_hinder_subits = [];             % NUM_subits x NUM_RFs x NUM_RFs
% ------ TXOP (attemps to access prevented)
num_preventions_sc_TXOP_subits = [];             % NUM_subits x NUM_RFs
num_preventions_cb_cont_TXOP_subits = [];            % NUM_subits x NUM_RFs
num_preventions_cb_noncont_TXOP_subits = [];            % NUM_subits x NUM_RFs
num_preventions_scb_TXOP_subits = [];            % NUM_subits x NUM_RFs
num_preventions_dcb_TXOP_subits = [];            % NUM_subits x NUM_RFs
num_preventions_pp_TXOP_subits = [];             % NUM_subits x NUM_RFs

% +++ BW enabled to others
% ------ TXOP (BW that has not been hindered due to voluntarly deferring channel accesses)
bw_enabled_sc_TXOP_subits = [];             % NUM_subits x NUM_RFs
bw_enabled_cb_cont_TXOP_subits = [];            % NUM_subits x NUM_RFs
bw_enabled_cb_noncont_TXOP_subits = [];            % NUM_subits x NUM_RFs
bw_enabled_scb_TXOP_subits = [];            % NUM_subits x NUM_RFs
bw_enabled_dcb_TXOP_subits = [];            % NUM_subits x NUM_RFs
bw_enabled_pp_TXOP_subits = [];             % NUM_subits x NUM_RFs

% +++ Prob. hidden
% ------ Hidden
prob_hidden_sc_hinder_subits = [];             % NUM_subits x NUM_RFs x NUM_RFs
prob_hidden_cb_cont_hinder_subits = [];        % NUM_subits x NUM_RFs x NUM_RFs
prob_hidden_cb_noncont_hinder_subits = [];     % NUM_subits x NUM_RFs x NUM_RFs
prob_hidden_scb_hinder_subits = [];            % NUM_subits x NUM_RFs x NUM_RFs
prob_hidden_dcb_hinder_subits = [];            % NUM_subits x NUM_RFs x NUM_RFs
prob_hidden_pp_hinder_subits = [];             % NUM_subits x NUM_RFs x NUM_RFs


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
%         num_peaks_subit = zeros(NUM_RFs,1);
%         for rf = 1:NUM_RFs
%             peak_samples_ix = find(occupancy_subit(:,rf) == 1);
%             num_peaks_subit(rf) = length(peak_samples_ix);
%         end        
%         av_occupancy = num_peaks_subit/num_rssi_samples_down_subit;
%         av_occupancy_subits(general_subit_ix) = mean(av_occupancy(1:8));
%         
%         disp(av_occupancy')
%         disp(mean(av_occupancy(1:8)))
        
        % Generate new occupancy matrix following i.i.d uniformly
        % distributed channels
        [occupancy_subit] = generate_uniform_traffic(occupancy_subit);
        num_peaks_subit = zeros(NUM_RFs,1);
        for rf = 1:NUM_RFs
            peak_samples_ix = find(occupancy_subit(:,rf) == 1);
            num_peaks_subit(rf) = length(peak_samples_ix);
        end  
        av_occupancy = num_peaks_subit/num_rssi_samples_down_subit;
        av_occupancy_subits(general_subit_ix) = mean(av_occupancy(1:8));
        
%         disp(av_occupancy')
%         disp(mean(av_occupancy(1:8)))
        
%         % Generate new occupancy matrix following Markov ON/OFF traffic
%         [occupancy_subit, prob_on, t_on_avg, t_off_avg] = generate_onoff_traffic(occupancy_subit);
%         num_peaks_subit = zeros(NUM_RFs,1);
%         for rf = 1:NUM_RFs
%             peak_samples_ix = find(occupancy_subit(:,rf) == 1);
%             num_peaks_subit(rf) = length(peak_samples_ix);
%         end  
%         av_occupancy = num_peaks_subit/num_rssi_samples_down_subit;
%         av_occupancy_subits(general_subit_ix) = mean(av_occupancy(1:8));
        
%         disp(av_occupancy')
        
        % - Sparsity
        sparsity = zeros(num_rssi_samples_down_subit,1);
        for s_ix = 1:num_rssi_samples_down_subit
            sample = occupancy_subit(s_ix,:);
            [r,s] = runlength(sample,numel(sample));
            result = r(logical(s));
            sparsity(s_ix) = length(result);
        end
        av_sparsity_subits(general_subit_ix) = mean(sparsity)/4;    % Max. of 4 isolated "1"s in full band
       
        % Spectral change frequency
        spectral_change = zeros(num_rssi_samples_down_subit,1);
        spectral_sum = zeros(num_rssi_samples_down_subit,1);
        spectral_max = zeros(num_rssi_samples_down_subit,1);
        for s_ix = 1:num_rssi_samples_down_subit
            sample = occupancy_subit(s_ix,:);
            a = diff(sample(:));
            out = nnz(unique(cumsum([true;diff(a)~=0]).*(a~=0)));
            spectral_change(s_ix) = out;
            
            [spectral_sum_aux, spectral_max_aux] =...
            get_spectral_variability_metrics(sample);
            
            spectral_sum(s_ix) = spectral_sum_aux;
            spectral_max(s_ix) = spectral_max_aux;
            
        end
        av_spectral_change_freq_subits(general_subit_ix) = mean(spectral_change)/(NUM_RFs - 1);    % Max. of NUM_RF - 1 (23) changes
        av_spectral_variability_sum(general_subit_ix) = mean(spectral_sum);
        av_spectral_variability_max(general_subit_ix) = mean(spectral_max);
        
        % Temporal change frequency
        temporal_change = zeros(NUM_RFs,1);
        for c_ix = 1:NUM_RFs
            temporal_samples_ch = occupancy_subit(:,c_ix);
            a = diff(temporal_samples_ch(:));
            out = nnz(unique(cumsum([true;diff(a)~=0]).*(a~=0)));
            temporal_change(c_ix) = out;
        end
        av_temporal_change_freq_subits(general_subit_ix) = mean(temporal_change)/(num_rssi_samples_down_subit - 1);
        av_per_ch_temporal_change_freq_subits(general_subit_ix,:) = temporal_change/(num_rssi_samples_down_subit - 1);
        
        %Idle time
        t_idle_array = [];
        for ch_ix = 1:8
            primary_ch = ch_ix;
            t_idle_array = [t_idle_array get_time_idle(primary_ch, occupancy_subit)];
            av_tidle(general_subit_ix, ch_ix) = mean(t_idle_array);
        end
        
        % Correlation
        corr_matrix = corrcoef(occupancy_subit);
        corr_matrix(isnan(corr_matrix))=0;
        for ch_ix = 1:8
            av_corr(general_subit_ix, ch_ix) = mean(corr_matrix(ch_ix,:));
        end
        
        corr_matrices(general_subit_ix, :, :) = corr_matrix;
                
        %% Simulation
            
        for rf = 1:NUM_RFs
            
            % --- HINDER ---
            
            % CB-cont hinder
            [av_throughput_cb_cont_hinder_subits(general_subit_ix,rf),...
                num_txs_cb_cont_hinder_subits(general_subit_ix,rf),...
                av_numtxch_cb_cont_hinder_subits(general_subit_ix,rf,:),...
                n_agg_array_cb_cont_hinder,...
                ~,...
                av_bwprev_cb_cont_hinder_subits(general_subit_ix,rf),...
                av_bweff_cb_cont_hinder_subits(general_subit_ix,rf)] =...
                throuhgput_sim_full_buffer_hinder(occupancy_subit,rf,POLICY_CBCONT,N_agg_max,L_D, NUM_RFs);
            
            % CB-noncont hinder
            [av_throughput_cb_noncont_hinder_subits(general_subit_ix,rf),...
                num_txs_cb_noncont_hinder_subits(general_subit_ix,rf),...
                av_numtxch_cb_noncont_hinder_subits(general_subit_ix,rf,:),~, ~,...
                av_bwprev_cb_noncont_hinder_subits(general_subit_ix,rf),...
                av_bweff_cb_noncont_hinder_subits(general_subit_ix,rf)] =...
                throuhgput_sim_full_buffer_hinder(occupancy_subit,rf,POLICY_CBNONCONT,N_agg_max,L_D, NUM_RFs);
            
            % SC hinder
            [av_throughput_sc_hinder_subits(general_subit_ix,rf),...
                num_txs_sc_hinder_subits(general_subit_ix,rf),...
                av_numtxch_sc_hinder_subits(general_subit_ix,rf,:),...
                n_agg_array_sc_hinder,...
                ~,...
                av_bwprev_sc_hinder_subits(general_subit_ix,rf),...
                av_bweff_sc_hinder_subits(general_subit_ix,rf)] =...
                throuhgput_sim_full_buffer_hinder(occupancy_subit,rf,POLICY_SC,N_agg_max,L_D, NUM_RFs);
            
            % SCB-hinder
            [av_throughput_scb_hinder_subits(general_subit_ix,rf),...
                num_txs_scb_hinder_subits(general_subit_ix,rf),...
                av_numtxch_scb_hinder_subits(general_subit_ix,rf,:),~, ~,...
                av_bwprev_scb_hinder_subits(general_subit_ix,rf),...
                av_bweff_scb_hinder_subits(general_subit_ix,rf)] =...
                throuhgput_sim_full_buffer_hinder(occupancy_subit,rf,POLICY_SCB,N_agg_max,L_D, NUM_RFs);
            
            % DCB-hinder
            [av_throughput_dcb_hinder_subits(general_subit_ix,rf),...
                num_txs_dcb_hinder_subits(general_subit_ix,rf),...
                av_numtxch_dcb_hinder_subits(general_subit_ix,rf,:),~, ~,...
                av_bwprev_dcb_hinder_subits(general_subit_ix,rf),...
                av_bweff_dcb_hinder_subits(general_subit_ix,rf)] =...
                throuhgput_sim_full_buffer_hinder(occupancy_subit,rf,POLICY_DCB,N_agg_max,L_D, NUM_RFs);
            
            % PP-hinder
            [av_throughput_pp_hinder_subits(general_subit_ix,rf),...
                num_txs_pp_hinder_subits(general_subit_ix,rf),...
                av_numtxch_pp_subits(general_subit_ix,rf,:),...
                n_agg_array_pp_hinder,...
                ~,...
                av_bwprev_pp_hinder_subits(general_subit_ix,rf),...
                av_bweff_pp_hinder_subits(general_subit_ix,rf)] =...
                throuhgput_sim_full_buffer_hinder(occupancy_subit,rf,POLICY_PP,N_agg_max,L_D, NUM_RFs);
            
%             % --- HIDDEN ---
%             
%             % CB-cont hidden
%             [av_throughput_cb_cont_hidden_subits(general_subit_ix,rf),~,...
%                 av_numtxch_cb_cont_hidden_subits(general_subit_ix,rf,:),~,...
%                 prob_hidden_cb_cont_hidden_subits(general_subit_ix,rf),...
%                 av_bweff_cb_cont_hidden_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_CBCONT,N_agg_max,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % CB-noncont hidden
%             [av_throughput_cb_noncont_hidden_subits(general_subit_ix,rf),~,...
%                 av_numtxch_cb_noncont_hidden_subits(general_subit_ix,rf,:),~,...
%                 prob_hidden_cb_noncont_hidden_subits(general_subit_ix,rf),...
%                 av_bweff_cb_noncont_hidden_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_CBNONCONT,N_agg_max,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % SC hidden
%             [av_throughput_sc_hidden_subits(general_subit_ix,rf),~,...
%                 av_numtxch_sc_hidden_subits(general_subit_ix,rf,:),~,...
%                 prob_hidden_sc_hidden_subits(general_subit_ix,rf),...
%                 av_bweff_sc_hidden_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_SC,N_agg_max,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % SCB-hidden
%             [av_throughput_scb_hidden_subits(general_subit_ix,rf),~,...
%                 av_numtxch_scb_hidden_subits(general_subit_ix,rf,:),~,...
%                 prob_hidden_scb_hidden_subits(general_subit_ix,rf),...
%                 av_bweff_scb_hidden_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_SCB,N_agg_max,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % DCB-hidden
%             [av_throughput_dcb_hidden_subits(general_subit_ix,rf),~,...
%                 av_numtxch_dcb_hidden_subits(general_subit_ix,rf,:),~,...
%                 prob_hidden_dcb_hidden_subits(general_subit_ix,rf),...
%                 av_bweff_dcb_hidden_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_DCB,N_agg_max,L_D, NUM_RFs, HIDDEN_COEFF_INT);
% 
%             % PP-hidden
%             [av_throughput_pp_hidden_subits(general_subit_ix,rf),~,...
%                 av_numtxch_pp_hidden_subits(general_subit_ix,rf,:),~,...
%                 prob_hidden_pp_hidden_subits(general_subit_ix,rf),...
%                 av_bweff_pp_hidden_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_hidden(occupancy_subit,rf,POLICY_PP,N_agg_max,L_D, NUM_RFs, HIDDEN_COEFF_INT);
% 
%             % --- TXOP ---
%             
%             % CB-cont TXOP
%             [av_throughput_cb_cont_TXOP_subits(general_subit_ix,rf),...
%                 num_txs_cb_cont_TXOP_subits(general_subit_ix,rf),...
%                 av_numtxch_cb_cont_TXOP_subits(general_subit_ix,rf,:),...
%                 ~,...
%                 num_preventions_cb_cont_TXOP_subits(general_subit_ix,rf),...
%                 bw_enabled_cb_cont_TXOP_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_txoplim(occupancy_subit,rf,POLICY_CBCONT,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % CB-noncont TXOP
%             [av_throughput_cb_noncont_TXOP_subits(general_subit_ix,rf),...
%                 num_txs_cb_noncont_TXOP_subits(general_subit_ix,rf),...
%                 av_numtxch_cb_noncont_TXOP_subits(general_subit_ix,rf,:),...
%                 ~,...
%                 num_preventions_cb_noncont_TXOP_subits(general_subit_ix,rf),...
%                 bw_enabled_cb_noncont_TXOP_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_txoplim(occupancy_subit,rf,POLICY_CBNONCONT,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % SC TXOP
%             [av_throughput_sc_TXOP_subits(general_subit_ix,rf),...
%                 num_txs_sc_TXOP_subits(general_subit_ix,rf),...
%                 av_numtxch_sc_TXOP_subits(general_subit_ix,rf,:),...
%                 ~,...
%                 num_preventions_sc_TXOP_subits(general_subit_ix,rf),...
%                 bw_enabled_sc_TXOP_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_txoplim(occupancy_subit,rf,POLICY_SC,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % SCB TXOP
%             [av_throughput_scb_TXOP_subits(general_subit_ix,rf),...
%                 num_txs_scb_TXOP_subits(general_subit_ix,rf),...
%                 av_numtxch_scb_TXOP_subits(general_subit_ix,rf,:),...
%                 ~,...
%                 num_preventions_scb_cont_TXOP_subits(general_subit_ix,rf),...
%                 bw_enabled_scb_TXOP_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_txoplim(occupancy_subit,rf,POLICY_SCB,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % DCB TXOP
%             [av_throughput_dcb_TXOP_subits(general_subit_ix,rf),...
%                 num_txs_dcb_TXOP_subits(general_subit_ix,rf),...
%                 av_numtxch_dcb_TXOP_subits(general_subit_ix,rf,:),...
%                 ~,...
%                 num_preventions_dcb_cont_TXOP_subits(general_subit_ix,rf),...
%                 bw_enabled_dcb_TXOP_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_txoplim(occupancy_subit,rf,POLICY_DCB,L_D, NUM_RFs, HIDDEN_COEFF_INT);
%             
%             % PP TXOP
%             [av_throughput_pp_TXOP_subits(general_subit_ix,rf),...
%                 num_txs_pp_TXOP_subits(general_subit_ix,rf),...
%                 av_numtxch_pp_TXOP_subits(general_subit_ix,rf,:),...
%                 ~,...
%                 num_preventions_pp_cont_TXOP_subits(general_subit_ix,rf),...
%                 bw_enabled_pp_TXOP_subits(general_subit_ix,rf)] =...
%                 throuhgput_sim_full_buffer_txoplim(occupancy_subit,rf,POLICY_PP,L_D, NUM_RFs, HIDDEN_COEFF_INT);
  
        end
                
    end
    subit_ix_offset = subit_ix_offset + num_subits_unii12 + num_subits_unii2ext;
end

out_filename = 'results_subiterations_06Feb2020_synthetic_FCB_uniform_Nagg64_txop5_period100ms';

save(out_filename);
fprintf('Results saved in %s\n', out_filename)

%%
% a = [1 1 0 1 0 0 0 0];
% out = double(diff([~a(1);a(:)]) == 1);
% v = accumarray(cumsum(out).*a(:)+1,1);
% out(out == 1) = v(2:end);
% consecutive_free_channels = out(out>1)';
% 
% spec_vblity_av_cont_ch = sum(consecutive_free_channels) / 8;
% spec_vbility_widest_ch = max(consecutive_free_channels);
% disp(consecutive_free_channels)
% disp(spec_vblity_av_cont_ch)
% disp(consecutive_free_channels)


%%

