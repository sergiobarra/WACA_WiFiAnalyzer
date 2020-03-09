%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_sim_output_synthetic_models.m
% 
% Plots the output of simulating the dataset (with synthetic occupancy models)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plots

clear
close  all
clc

%load('results_subiterations_hinder_23Jan19_Nagg64_txop5_period100ms')


% Merge original datasets (general and FCB)
filename_original_general = 'results_subiterations_hinder_23Jan19_Nagg64_txop5_period100ms.mat';
filename_original_fcb = 'results_subiterations_7Feb2020_FCB_Nagg64_txop5_period100ms.mat';
dataset_original_general = load(filename_original_general);
%dataset_original_fcb = load(filename_original_fcb);

% av_occupancy_subits_original = [dataset_original_general.av_occupancy_subits...
%     dataset_original_fcb.av_occupancy_subits];
% av_throughput_cb_cont_hinder_subits_original = [dataset_original_general.av_throughput_cb_cont_hinder_subits;...
%     dataset_original_fcb.av_throughput_cb_cont_hinder_subits];
% av_throughput_cb_noncont_hinder_subits_original = [dataset_original_general.av_throughput_cb_noncont_hinder_subits;...
%     dataset_original_fcb.av_throughput_cb_noncont_hinder_subits];
% av_throughput_sc_hinder_subits_original = [dataset_original_general.av_throughput_sc_hinder_subits;...
%     dataset_original_fcb.av_throughput_sc_hinder_subits];
% corr_matrices_original = [dataset_original_general.corr_matrices; dataset_original_fcb.corr_matrices];

av_occupancy_subits_original = [dataset_original_general.av_occupancy_subits];
av_throughput_cb_cont_hinder_subits_original = [dataset_original_general.av_throughput_cb_cont_hinder_subits];
av_throughput_cb_noncont_hinder_subits_original = [dataset_original_general.av_throughput_cb_noncont_hinder_subits];
av_throughput_sc_hinder_subits_original = [dataset_original_general.av_throughput_sc_hinder_subits];
corr_matrices_original = [dataset_original_general.corr_matrices];


% Merge synthetic (ON/OFF or uniform i.i.d) datasets (general and FCB)
% filename_synth_general = 'results_subiterations_28Jan2020_synthetic_onoff_Nagg64_txop5_period100ms.mat';
% filename_synth_fcb = 'results_subiterations_06Feb2020_synthetic_FCB_onoff_Nagg64_txop5_period100ms.mat';
filename_synth_general = 'results_subiterations_03Feb2020_synthetic_uniform_Nagg64_txop5_period100ms.mat';
filename_synth_fcb = 'results_subiterations_06Feb2020_synthetic_FCB_uniform_Nagg64_txop5_period100ms.mat';
dataset_synth_general = load(filename_synth_general);
dataset_synth_fcb = load(filename_synth_fcb);

% av_occupancy_subits_synth = [dataset_synth_general.av_occupancy_subits...
%     dataset_synth_fcb.av_occupancy_subits];
% av_throughput_cb_cont_hinder_subits_synth = [dataset_synth_general.av_throughput_cb_cont_hinder_subits;...
%     dataset_synth_fcb.av_throughput_cb_cont_hinder_subits];
% av_throughput_cb_noncont_hinder_subits_synth = [dataset_synth_general.av_throughput_cb_noncont_hinder_subits;...
%     dataset_synth_fcb.av_throughput_cb_noncont_hinder_subits];
% av_throughput_sc_hinder_subits_synth = [dataset_synth_general.av_throughput_sc_hinder_subits;...
%     dataset_synth_fcb.av_throughput_sc_hinder_subits];
% corr_matrices_synth = [dataset_synth_general.corr_matrices; dataset_synth_fcb.corr_matrices];

av_occupancy_subits_synth = [dataset_synth_general.av_occupancy_subits];
av_throughput_cb_cont_hinder_subits_synth = [dataset_synth_general.av_throughput_cb_cont_hinder_subits];
av_throughput_cb_noncont_hinder_subits_synth = [dataset_synth_general.av_throughput_cb_noncont_hinder_subits];
av_throughput_sc_hinder_subits_synth = [dataset_synth_general.av_throughput_sc_hinder_subits];
corr_matrices_synth = [dataset_synth_general.corr_matrices];

% Merge synthetic (ON/OFF or uniform i.i.d) datasets (general and FCB) -
% TWO LOADED
filename_synth_general_2 = 'results_subiterations_28Jan2020_synthetic_onoff_Nagg64_txop5_period100ms.mat';
filename_synth_fcb_2 = 'results_subiterations_06Feb2020_synthetic_FCB_onoff_Nagg64_txop5_period100ms.mat';
% filename_synth_general_2 = 'results_subiterations_03Feb2020_synthetic_uniform_Nagg64_txop5_period100ms.mat';
% filename_synth_fcb_2 = 'results_subiterations_06Feb2020_synthetic_FCB_uniform_Nagg64_txop5_period100ms.mat';
dataset_synth_general_2 = load(filename_synth_general_2);
dataset_synth_fcb_2 = load(filename_synth_fcb_2);

% av_occupancy_subits_synth_2 = [dataset_synth_general_2.av_occupancy_subits...
%     dataset_synth_fcb_2.av_occupancy_subits];
% av_throughput_cb_cont_hinder_subits_synth_2 = [dataset_synth_general_2.av_throughput_cb_cont_hinder_subits;...
%     dataset_synth_fcb_2.av_throughput_cb_cont_hinder_subits];
% av_throughput_cb_noncont_hinder_subits_synth_2 = [dataset_synth_general_2.av_throughput_cb_noncont_hinder_subits;...
%     dataset_synth_fcb_2.av_throughput_cb_noncont_hinder_subits];
% corr_matrices_synth_2 = [dataset_synth_general_2.corr_matrices; dataset_synth_fcb_2.corr_matrices];

av_occupancy_subits_synth_2 = [dataset_synth_general_2.av_occupancy_subits];
av_throughput_cb_cont_hinder_subits_synth_2 = [dataset_synth_general_2.av_throughput_cb_cont_hinder_subits];
av_throughput_cb_noncont_hinder_subits_synth_2 = [dataset_synth_general_2.av_throughput_cb_noncont_hinder_subits];
corr_matrices_synth_2 = [dataset_synth_general_2.corr_matrices];

%%
T_SAMPLE = 10*1E-6;
T_PERIOD = 0.1;
marker_size = 4;
BW_SC = 20;
NUM_RFs = 8;

NUM_SAMPLES_PERIOD = 1E4;   % No. of RSSI samples per channel in a period of 100 ms
NUM_SUBITS = length(av_occupancy_subits_original);


%% HINDER ORIGINAL

THRESHOLD_OCC_LOW = 0.1;
THRESHOLD_OCC_MED = 0.2;
ix_occ_low_3 = find(av_occupancy_subits_original < THRESHOLD_OCC_LOW);
ix_occ_med_3 = find((av_occupancy_subits_original >= THRESHOLD_OCC_LOW & av_occupancy_subits_original < THRESHOLD_OCC_MED));
ix_occ_high_3 = find(av_occupancy_subits_original > THRESHOLD_OCC_MED);

THRESHOLD_OCC_LOW_MIN = 0.05;
THRESHOLD_OCC_LOW_MAX = 0.10;
THRESHOLD_OCC_MED_MIN = 0.15;
THRESHOLD_OCC_MED_MAX = 0.20;
THRESHOLD_OCC_HIGH_MIN = 0.25;
THRESHOLD_OCC_HIGH_MAX = 1;
ix_occ_low = find(av_occupancy_subits_original >= THRESHOLD_OCC_LOW_MIN & av_occupancy_subits_original < THRESHOLD_OCC_LOW_MAX);
ix_occ_btw_low_med = find(av_occupancy_subits_original >= THRESHOLD_OCC_LOW_MAX & av_occupancy_subits_original < THRESHOLD_OCC_MED_MIN);
ix_occ_med = find(av_occupancy_subits_original >= THRESHOLD_OCC_MED_MIN & av_occupancy_subits_original < THRESHOLD_OCC_MED_MAX);
ix_occ_btw_med_high = find(av_occupancy_subits_original >= THRESHOLD_OCC_MED_MAX & av_occupancy_subits_original < THRESHOLD_OCC_HIGH_MIN);
ix_occ_high = find(av_occupancy_subits_original >= THRESHOLD_OCC_HIGH_MIN & av_occupancy_subits_original < THRESHOLD_OCC_HIGH_MAX);

% - Mean throughput
mean_throughput_cb_cont_hinder_original = mean(av_throughput_cb_cont_hinder_subits_original,2) * 1E-6;
mean_throughput_cb_noncont_hinder_original = mean(av_throughput_cb_noncont_hinder_subits_original,2) * 1E-6;
mean_throughput_sc_hinder_original = mean(av_throughput_sc_hinder_subits_original,2) * 1E-6;

% - Max throughput
[max_throughput_cb_cont_hinder_subits_original, max_ix_cb_cont_hinder_original] = max(av_throughput_cb_cont_hinder_subits_original * 1E-6,[],2);
[max_throughput_cb_noncont_hinder_subits_original, max_ix_cb_noncont_hinder_original] = max(av_throughput_cb_noncont_hinder_subits_original * 1E-6,[],2);
[max_throughput_sc_hinder_subits_original, max_ix_sc_hinder_original] = max(av_throughput_sc_hinder_subits_original * 1E-6,[],2);

% - Correlation of the thr maximizing primary with the rest of channels
max_primary_corr_cb_cont_hinder_original = zeros(NUM_SUBITS,NUM_RFs);
max_primary_corr_cb_noncont_hinder_original = zeros(NUM_SUBITS,NUM_RFs);
mean_max_primary_corr_cb_cont_hinder_original = zeros(NUM_SUBITS,1);
mean_max_primary_corr_cb_noncont_hinder_original = zeros(NUM_SUBITS,1);

for subit = 1:NUM_SUBITS
    
    corr_vector = reshape(corr_matrices_original(subit,max_ix_cb_cont_hinder_original(subit),:),NUM_RFs,1);
    max_primary_corr_cb_cont_hinder_original(subit,:) = corr_vector;
    mean_max_primary_corr_cb_cont_hinder_original(subit) = mean(corr_vector(corr_vector<1));
    
    corr_vector = reshape(corr_matrices_original(subit,max_ix_cb_noncont_hinder_original(subit),:),NUM_RFs,1);
    max_primary_corr_cb_noncont_hinder_original(subit,:) = corr_vector;
    mean_max_primary_corr_cb_noncont_hinder_original(subit) = mean(corr_vector(corr_vector<1));
end

%% HINDER SYNTHETIC

% - Mean throughput
mean_throughput_cb_cont_hinder_synth = mean(av_throughput_cb_cont_hinder_subits_synth,2) * 1E-6;
mean_throughput_cb_noncont_hinder_synth = mean(av_throughput_cb_noncont_hinder_subits_synth,2) * 1E-6;
mean_throughput_sc_hinder_synth = mean(av_throughput_sc_hinder_subits_synth,2) * 1E-6;

% - Max throughput
[max_throughput_cb_cont_hinder_subits_synth, max_ix_cb_cont_hinder_synth] = max(av_throughput_cb_cont_hinder_subits_synth * 1E-6,[],2);
[max_throughput_cb_noncont_hinder_subits_synth, max_ix_cb_noncont_hinder_synth] = max(av_throughput_cb_noncont_hinder_subits_synth * 1E-6,[],2);
[max_throughput_sc_hinder_subits_synth, max_ix_sc_hinder_synth] = max(av_throughput_sc_hinder_subits_synth * 1E-6,[],2);

% - Correlation of the thr maximizing primary with the rest of channels
max_primary_corr_cb_cont_hinder_synth = zeros(NUM_SUBITS,NUM_RFs);
max_primary_corr_cb_noncont_hinder_synth = zeros(NUM_SUBITS,NUM_RFs);
mean_max_primary_corr_cb_cont_hinder_synth = zeros(NUM_SUBITS,1);
mean_max_primary_corr_cb_noncont_hinder_synth = zeros(NUM_SUBITS,1);

for subit = 1:NUM_SUBITS
    
    corr_vector = reshape(corr_matrices_synth(subit,max_ix_cb_cont_hinder_synth(subit),:),NUM_RFs,1);
    max_primary_corr_cb_cont_hinder_synth(subit,:) = corr_vector;
    mean_max_primary_corr_cb_cont_hinder_synth(subit) = mean(corr_vector(corr_vector<1));
    
    corr_vector = reshape(corr_matrices_synth(subit,max_ix_cb_noncont_hinder_synth(subit),:),NUM_RFs,1);
    max_primary_corr_cb_noncont_hinder_synth(subit,:) = corr_vector;
    mean_max_primary_corr_cb_noncont_hinder_synth(subit) = mean(corr_vector(corr_vector<1));
end

%% HINDER SYNTHETIC 2

% - Mean throughput
mean_throughput_cb_cont_hinder_synth_2 = mean(av_throughput_cb_cont_hinder_subits_synth_2,2) * 1E-6;
mean_throughput_cb_noncont_hinder_synth_2 = mean(av_throughput_cb_noncont_hinder_subits_synth_2,2) * 1E-6;

% - Max throughput
[max_throughput_cb_cont_hinder_subits_synth_2, max_ix_cb_cont_hinder_synth_2] = max(av_throughput_cb_cont_hinder_subits_synth_2 * 1E-6,[],2);
[max_throughput_cb_noncont_hinder_subits_synth_2, max_ix_cb_noncont_hinder_synth_2] = max(av_throughput_cb_noncont_hinder_subits_synth_2 * 1E-6,[],2);

% - Correlation of the thr maximizing primary with the rest of channels
max_primary_corr_cb_cont_hinder_synth_2 = zeros(NUM_SUBITS,NUM_RFs);
max_primary_corr_cb_noncont_hinder_synth_2 = zeros(NUM_SUBITS,NUM_RFs);
mean_max_primary_corr_cb_cont_hinder_synth_2 = zeros(NUM_SUBITS,1);
mean_max_primary_corr_cb_noncont_hinder_synth_2 = zeros(NUM_SUBITS,1);

for subit = 1:NUM_SUBITS
    
    corr_vector = reshape(corr_matrices_synth_2(subit,max_ix_cb_cont_hinder_synth(subit),:),NUM_RFs,1);
    max_primary_corr_cb_cont_hinder_synth_2(subit,:) = corr_vector;
    mean_max_primary_corr_cb_cont_hinder_synth_2(subit) = mean(corr_vector(corr_vector<1));
    
    corr_vector = reshape(corr_matrices_synth_2(subit,max_ix_cb_noncont_hinder_synth(subit),:),NUM_RFs,1);
    max_primary_corr_cb_noncont_hinder_synth_2(subit,:) = corr_vector;
    mean_max_primary_corr_cb_noncont_hinder_synth_2(subit) = mean(corr_vector(corr_vector<1));
end


%% PLOTS

OCC_LIM_LOW = 0;
OCC_LIM_UP = 0.5;

%% Raw throughput vs. occupancy -- Average and max
figure
subplot(2,2,1)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_original,'x','markeredgecolor','c')
ylabel(['Mean throughput [Mbps]'])
xlabel('Mean occupancy')
title('CB-cont original')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([0 600])

subplot(2,2,2)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_synth,marker_size,'x','markeredgecolor','c')
xlabel('Mean occupancy')
title('CB-cont synth')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([0 600])

subplot(2,2,3)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_noncont_hinder_original,marker_size,'x','markeredgecolor','c')
xlabel('Mean occupancy')
title('CB-non-cont original')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylabel(['Mean throughput [Mbps]'])
ylim([0 600])

subplot(2,2,4)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_noncont_hinder_synth,marker_size,'x','markeredgecolor','c')
xlabel('Mean occupancy')
title('CB-non-cont synth')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([0 600])

%% Raw throughput vs. occupancy -- Average  *** 2 synth ***
figure

subplot(2,3,1)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_synth,marker_size,'x','markeredgecolor','c')
ylabel(['Mean throughput [Mbps]'])
%xlabel('Mean occupancy')
title('CB-cont synth-uni')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(2,3,2)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_synth_2,marker_size,'x','markeredgecolor','c')
%xlabel('Mean occupancy')
title('CB-cont synth-on/off')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(2,3,3)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_original,'x','markeredgecolor','c')
%xlabel('Mean occupancy')
title('CB-cont original')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(2,3,4)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_noncont_hinder_synth,marker_size,'x','markeredgecolor','c')
ylabel(['Mean throughput [Mbps]'])
xlabel('Mean occupancy')
title({'CB-non-cont','synth-uni'})
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(2,3,5)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_noncont_hinder_synth_2,marker_size,'x','markeredgecolor','c')
xlabel('Mean occupancy')
title({'CB-non-cont','synth-on/off'})
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(2,3,6)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_noncont_hinder_original,'x','markeredgecolor','c')
xlabel('Mean occupancy')
title({'CB-non-cont','original'})

grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

%% Raw throughput vs. occupancy -- Average  *** 2 synth *** Without CB-non-cont
figure

subplot(1,3,1)
hold on
scatter(av_occupancy_subits_original(ix_occ_low_3), mean_throughput_cb_cont_hinder_synth(ix_occ_low_3),marker_size,'x','markeredgecolor','c')
scatter(av_occupancy_subits_original(ix_occ_med_3), mean_throughput_cb_cont_hinder_synth(ix_occ_med_3),marker_size,'x','markeredgecolor','y')
scatter(av_occupancy_subits_original(ix_occ_high_3), mean_throughput_cb_cont_hinder_synth(ix_occ_high_3),marker_size,'x','markeredgecolor','r')
ylabel(['Mean throughput [Mbps]'])
title('i.i.d')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(1,3,2)
hold on
scatter(av_occupancy_subits_original(ix_occ_low_3), mean_throughput_cb_cont_hinder_synth_2(ix_occ_low_3),marker_size,'x','markeredgecolor','c')
scatter(av_occupancy_subits_original(ix_occ_med_3), mean_throughput_cb_cont_hinder_synth_2(ix_occ_med_3),marker_size,'x','markeredgecolor','y')
scatter(av_occupancy_subits_original(ix_occ_high_3), mean_throughput_cb_cont_hinder_synth_2(ix_occ_high_3),marker_size,'x','markeredgecolor','r')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
title('on/off')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(1,3,3)
hold on
scatter(av_occupancy_subits_original(ix_occ_low_3), mean_throughput_cb_cont_hinder_original(ix_occ_low_3),marker_size,'x','markeredgecolor','c')
scatter(av_occupancy_subits_original((ix_occ_med_3)), mean_throughput_cb_cont_hinder_original(ix_occ_med_3),marker_size,'x','markeredgecolor','y')
scatter(av_occupancy_subits_original(ix_occ_high_3), mean_throughput_cb_cont_hinder_original(ix_occ_high_3),marker_size,'x','markeredgecolor','r')
legend('Low','Med','High')
title('original')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])


figure
subplot(1,3,1)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_synth,marker_size,'x','markeredgecolor','c')
ylabel('mean thr. $\Gamma$ [Mbps]', 'interpreter', 'latex')

title('i.i.d')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

subplot(1,3,2)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_synth_2,marker_size,'x','markeredgecolor','c')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
title('Markov')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])


subplot(1,3,3)
hold on
scatter(av_occupancy_subits_original, mean_throughput_cb_cont_hinder_original,marker_size,'x','markeredgecolor','c')
title('original')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
ylim([100 600])

%% Ratio synth vs. original

ratio_original_vs_synth_cb_cont = mean_throughput_cb_cont_hinder_original./mean_throughput_cb_cont_hinder_synth;
ratio_original_vs_synth_cb_noncont = mean_throughput_cb_noncont_hinder_original./mean_throughput_cb_noncont_hinder_synth;
gain_original_vs_synth_cb_cont = mean_throughput_cb_cont_hinder_original - mean_throughput_cb_cont_hinder_synth;
gain_original_vs_synth_cb_noncont = mean_throughput_cb_noncont_hinder_original - mean_throughput_cb_noncont_hinder_synth;
norm_gain_original_vs_synth_cb_cont = gain_original_vs_synth_cb_cont ./ mean_throughput_cb_cont_hinder_synth;
norm_gain_original_vs_synth_cb_noncont = gain_original_vs_synth_cb_noncont ./ mean_throughput_cb_noncont_hinder_synth;

ratio_original_vs_synth_cb_cont_2 = mean_throughput_cb_cont_hinder_original./mean_throughput_cb_cont_hinder_synth_2;
ratio_original_vs_synth_cb_noncont_2 = mean_throughput_cb_noncont_hinder_original./mean_throughput_cb_noncont_hinder_synth_2;
gain_original_vs_synth_cb_cont_2 = mean_throughput_cb_cont_hinder_original - mean_throughput_cb_cont_hinder_synth_2;
gain_original_vs_synth_cb_noncont_2 = mean_throughput_cb_noncont_hinder_original - mean_throughput_cb_noncont_hinder_synth_2;
norm_gain_original_vs_synth_cb_cont_2 = gain_original_vs_synth_cb_cont_2 ./ mean_throughput_cb_cont_hinder_synth_2;
norm_gain_original_vs_synth_cb_noncont_2 = gain_original_vs_synth_cb_noncont_2 ./ mean_throughput_cb_noncont_hinder_synth_2;

fprintf('Mean normalized gain CB-cont (in occupancy ranges):\n')
fprintf('- Low: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_cont(ix_occ_low)) * 100)
fprintf('- Low-Mid: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_low_med)) * 100)
fprintf('- Medium: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_cont(ix_occ_med)) * 100)
fprintf('- Med-High: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_med_high)) * 100)
fprintf('- High: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_cont(ix_occ_high)) * 100)

fprintf('Mean normalized gain CB-non-cont (in occupancy ranges):\n')
fprintf('- Low: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_low)) * 100)
fprintf('- Low-Mid: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_low_med)) * 100)
fprintf('- Medium: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_med)) * 100)
fprintf('- Med-High: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_med_high)) * 100)
fprintf('- High: %.2f %%\n', mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_high)) * 100)

GAIN_LIM_LOW = -1;
GAIN_LIM_HIGH = 3;


figure
subplot(2,5,1)
histogram(norm_gain_original_vs_synth_cb_cont(ix_occ_low))
grid on
title('Low occ.')
ylabel('Count CB-cont')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,2)
histogram(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_low_med))
grid on
title('Low-Med.')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,3)
histogram(norm_gain_original_vs_synth_cb_cont(ix_occ_med))
grid on
title('Med')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
xlabel('Norm. gain original vs. synth')
subplot(2,5,4)
histogram(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_med_high))
grid on
title('Med-High')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,5)
histogram(norm_gain_original_vs_synth_cb_cont(ix_occ_high))
grid on
title('High')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,6)
histogram(norm_gain_original_vs_synth_cb_noncont(ix_occ_low))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
ylabel('Count CB-non-cont')
subplot(2,5,7)
histogram(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_low_med))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
subplot(2,5,8)
histogram(norm_gain_original_vs_synth_cb_noncont(ix_occ_med))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
xlabel('Norm. gain original vs. synth')
subplot(2,5,9)
histogram(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_med_high))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
subplot(2,5,10)
histogram(norm_gain_original_vs_synth_cb_noncont(ix_occ_high))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on



%% Ratio synth vs. original - ECDF

GAIN_LIM_LOW = -1;
GAIN_LIM_HIGH = 3;

figure
subplot(2,5,1)
ecdf(norm_gain_original_vs_synth_cb_cont(ix_occ_low))
grid on
title('Low occ.')
ylabel('ECDF norm. gain original/synth')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,2)
ecdf(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_low_med))
grid on
title('Low-Med.')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,3)
ecdf(norm_gain_original_vs_synth_cb_cont(ix_occ_med))
grid on
title('Med')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
xlabel('Norm. gain original vs. synth')
subplot(2,5,4)
ecdf(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_med_high))
grid on
title('Med-High')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,5)
ecdf(norm_gain_original_vs_synth_cb_cont(ix_occ_high))
grid on
title('High')
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
subplot(2,5,6)
ecdf(norm_gain_original_vs_synth_cb_noncont(ix_occ_low))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
ylabel('ECDF norm. gain original/synth')
subplot(2,5,7)
ecdf(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_low_med))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
subplot(2,5,8)
ecdf(norm_gain_original_vs_synth_cb_noncont(ix_occ_med))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
xlabel('Norm. gain original vs. synth')
subplot(2,5,9)
ecdf(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_med_high))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on
subplot(2,5,10)
ecdf(norm_gain_original_vs_synth_cb_noncont(ix_occ_high))
xlim([GAIN_LIM_LOW, GAIN_LIM_HIGH])
grid on

%%
figure
subplot(1,2,1)
hold on
scatter(av_occupancy_subits_original, ratio_original_vs_synth_cb_cont,marker_size,'o','markeredgecolor','c')
ylabel(['Original/Synth'])
xlabel('Mean occupancy')
title('CB-cont comparison')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
set(gca,'yscale','log')

subplot(1,2,2)
hold on
scatter(av_occupancy_subits_original, ratio_original_vs_synth_cb_noncont,marker_size,'o','markeredgecolor','c')
ylabel(['Original/Synth'])
xlabel('Mean occupancy')
title('CB-non-cont comparison')
grid on
xlim([OCC_LIM_LOW OCC_LIM_UP])
set(gca,'yscale','log')


%% Bar chart normalized gains

% Low, Low-Mid, ... High
gain_cb_cont_synth = [mean(norm_gain_original_vs_synth_cb_cont(ix_occ_low))...
    mean(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_low_med))...
    mean(norm_gain_original_vs_synth_cb_cont(ix_occ_med))...
    mean(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_med_high))...
    mean(norm_gain_original_vs_synth_cb_cont(ix_occ_high))];

gain_cb_noncont_synth = [mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_low))...
    mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_low_med))...
    mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_med))...
    mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_med_high))...
    mean(norm_gain_original_vs_synth_cb_noncont(ix_occ_high))];

gain_cb_cont_synth_2 = [mean(norm_gain_original_vs_synth_cb_cont_2(ix_occ_low))...
    mean(norm_gain_original_vs_synth_cb_cont_2(ix_occ_btw_low_med))...
    mean(norm_gain_original_vs_synth_cb_cont_2(ix_occ_med))...
    mean(norm_gain_original_vs_synth_cb_cont_2(ix_occ_btw_med_high))...
    mean(norm_gain_original_vs_synth_cb_cont_2(ix_occ_high))];

gain_cb_noncont_synth_2 = [mean(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_low))...
    mean(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_btw_low_med))...
    mean(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_med))...
    mean(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_btw_med_high))...
    mean(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_high))];


figure
subplot(1,2,1)
y = [gain_cb_cont_synth; gain_cb_cont_synth_2];
bar(y)
ylabel('Gain original/synth')
set(gca,'XTickLabel',{'synth-uni', 'synth-on/ff'});
title('CB-cont')
grid on
ylim([-0.1 0.7])

subplot(1,2,2)
y = [gain_cb_noncont_synth; gain_cb_noncont_synth_2];
bar(y)
ylabel('Gain original/synth')
set(gca,'XTickLabel',{'synth-uni', 'synth-on/ff'});
grid on
ylim([-0.1 0.7])
title('CB-non-cont')
legend('Low','Low-Med','Med','Med-High','High')


figure
y = [gain_cb_cont_synth; gain_cb_cont_synth_2];
bar(y)
ylabel('Gain original/synth')
set(gca,'XTickLabel',{'synth-uni', 'synth-on/ff'});
title('CB-cont')
grid on
ylim([-0.1 0.7])

%% Bar chart normalized error

% Low, Low-Mid, ... High
gain_cb_cont_synth = [mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_low)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_low_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_btw_med_high)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_high)))];

gain_cb_noncont_synth = [mean(abs(norm_gain_original_vs_synth_cb_noncont(ix_occ_low)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_low_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont(ix_occ_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont(ix_occ_btw_med_high)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont(ix_occ_high)))];

gain_cb_cont_synth_2 = [mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_low)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_btw_low_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_btw_med_high)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_high)))];

gain_cb_noncont_synth_2 = [mean(abs(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_low)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_btw_low_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_med)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_btw_med_high)))...
    mean(abs(norm_gain_original_vs_synth_cb_noncont_2(ix_occ_high)))];


figure
subplot(1,2,1)
y = [gain_cb_cont_synth; gain_cb_cont_synth_2];
bar(y)
ylabel('Norm. thr. error')
set(gca,'XTickLabel',{'synth-uni', 'synth-on/ff'});
title('CB-cont')
grid on
ylim([0.0 0.7])

subplot(1,2,2)
y = [gain_cb_noncont_synth; gain_cb_noncont_synth_2];
bar(y)
ylabel('Norm. thr. error')
set(gca,'XTickLabel',{'synth-uni', 'synth-on/ff'});
grid on
ylim([0.0 0.7])
title('CB-non-cont')
legend('Low','Low-Med','Med','Med-High','High')




%% Histogram relative error

figure
subplot(1,3,1)
histogram(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_low_3)),18,'Normalization','probability')
xlim([0, 1.3])
ylim([0, 0.2])
subplot(1,3,2)
histogram(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_med_3)),'Normalization','probability')
xlim([0, 1.3])
ylim([0, 0.2])
subplot(1,3,3)
histogram(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_high_3)),30,'Normalization','probability')
xlim([0, 1.3])
ylim([0, 0.2])



%% Correlation
% Scatter plot x-axis: correlation, y-axis: occupancy
figure
subplot(2,2,1)
hold on
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
ylabel('Mean occupancy')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title('CB-cont original')
xlim([-0.1 0.6])

subplot(2,2,2)
hold on
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title('CB-cont synth')
xlim([-0.1 0.6])

subplot(2,2,3)
hold on
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
ylabel('Mean occupancy')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title('CB-non-cont original')
xlim([-0.1 0.6])

subplot(2,2,4)
hold on
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
ylabel('Mean occupancy')
legend('Low','Low-Med','Med','Med-High','High')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title('CB-non-cont synth')
xlim([-0.1 0.6])


%% Correlation *** 2 ***
% Scatter plot x-axis: correlation, y-axis: occupancy
figure

subplot(2,3,1)
hold on
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title('CB-cont synth-uni')
xlim([-0.1 0.6])
ylabel('Mean occupancy')

subplot(2,3,2)
hold on
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title('CB-cont synth-on/off')
xlim([-0.1 0.6])


subplot(2,3,3)
hold on
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_original(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title('CB-cont original')
xlim([-0.1 0.6])


subplot(2,3,4)
hold on
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_synth(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
ylabel('Mean occupancy')
legend('Low','Low-Med','Med','Med-High','High')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title({'CB-non-cont','synth-uni'})

xlim([-0.1 0.6])

subplot(2,3,5)
hold on
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder_synth_2(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title({'CB-non-cont','synth-on/ff'})
xlim([-0.1 0.6])

subplot(2,3,6)
hold on
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_low),av_occupancy_subits_original(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_btw_low_med),av_occupancy_subits_original(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_med),av_occupancy_subits_original(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_btw_med_high),av_occupancy_subits_original(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder_original(ix_occ_high),av_occupancy_subits_original(ix_occ_high),...
    marker_size,'o')
grid on
ylim([OCC_LIM_LOW OCC_LIM_UP])
title({'CB-non-cont','original'})
xlim([-0.1 0.6])




%% Bar chart relative error in 3 occupancy categories

% Low, Low-Mid, ... High
gain_cb_cont_synth = [mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_low_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_med_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_occ_high_3)))];

gain_cb_cont_synth_2 = [mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_low_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_med_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_occ_high_3)))];

figure
y = [gain_cb_cont_synth; gain_cb_cont_synth_2];
bar(y)
hold on

ylabel('Relative thr. error')
set(gca,'XTickLabel',{'i.i.d', 'on/ff'});
grid on
ylim([0.0 0.7])
legend('low $\bar{o}_B$','med $\bar{o}_B$','high $\bar{o}_B$')


THRESHOLD_CORRELATION_LOW_MIN = -0.1;
THRESHOLD_CORRELATION_LOW_MAX = 0.1;
THRESHOLD_CORRELATION_MED_MIN = 0.2;
THRESHOLD_CORRELATION_MED_MAX = 0.4;
THRESHOLD_CORRELATION_HIGH_MIN = 0.5;
THRESHOLD_CORRELATION_HIGH_MAX = 0.65;

ix_corr_low_3 =  find((mean_max_primary_corr_cb_cont_hinder_original >= THRESHOLD_CORRELATION_LOW_MIN &...
    mean_max_primary_corr_cb_cont_hinder_original < THRESHOLD_CORRELATION_LOW_MAX));

ix_corr_med_3 =  find((mean_max_primary_corr_cb_cont_hinder_original >= THRESHOLD_CORRELATION_MED_MIN &...
    mean_max_primary_corr_cb_cont_hinder_original < THRESHOLD_CORRELATION_MED_MAX));

ix_corr_high_3 = find((mean_max_primary_corr_cb_cont_hinder_original >= THRESHOLD_CORRELATION_HIGH_MIN &...
    mean_max_primary_corr_cb_cont_hinder_original < THRESHOLD_CORRELATION_HIGH_MAX));

% Low, Low-Mid, ... High
gain_cb_cont_synth = [mean(abs(norm_gain_original_vs_synth_cb_cont(ix_corr_low_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_corr_med_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont(ix_corr_high_3)))];

gain_cb_cont_synth_2 = [mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_corr_low_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_corr_med_3)))...
    mean(abs(norm_gain_original_vs_synth_cb_cont_2(ix_corr_high_3)))];

figure
y = [gain_cb_cont_synth; gain_cb_cont_synth_2];
bar(y)
hold on

ylabel('Relative thr. error')
set(gca,'XTickLabel',{'i.i.d', 'on/ff'});
grid on
ylim([0.0 0.7])
legend('low $\xi$','med $\xi$','high $\xi$')

rectangle('Position', [-0.1 -0.02 0.2 0.54], 'FaceColor', [0 1 0 0.1])
set(gca,'children',flipud(get(gca,'children')))
rectangle('Position', [0.2 -0.02 0.2 0.54], 'FaceColor', [1 1 0 0.12])
set(gca,'children',flipud(get(gca,'children')))
rectangle('Position', [0.5 -0.02 0.15 0.54], 'FaceColor', [1 0 0 0.07])
set(gca,'children',flipud(get(gca,'children')))


function [CI] = get_95_percent_confidence_interval(x)
    
    SEM = std(x)/sqrt(length(x));               % Standard Error
    ts = tinv([0.025  0.975],length(x)-1);      % T-Score
    CI = mean(x) + ts*SEM;                      % Confidence Intervals
    
end
