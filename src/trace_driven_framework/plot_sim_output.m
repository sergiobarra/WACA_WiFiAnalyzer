%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_sim_output.m
% 
% Plots the output of simulating the dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close  all
clc

%% Plots

% load .mat file (output of trace-driven simulation) to plot/analyze
filename = 'results_subiterations_8Jan19_Nagg64_txop5_period100ms';
%filename = 'results_subiterations_7Feb2020_FCB_Nagg64_txop5_period100ms';

load(filename)

marker_size = 6;
BW_SC = 20;

NUM_SAMPLES_PERIOD = 1E4;   % No. of RSSI samples per channel in a period of 100 ms
NUM_SUBITS = length(av_occupancy_subits);

mean_tidle = mean(av_tidle,2);
mean_corr = mean(av_corr,2);

% - Boxplot parameters
THRESHOLD_OCC_LOW = 0.1;
THRESHOLD_OCC_MED = 0.2;
ix_occ_low = find(av_occupancy_subits < THRESHOLD_OCC_LOW);
ix_occ_med = find((av_occupancy_subits >= THRESHOLD_OCC_LOW & av_occupancy_subits < THRESHOLD_OCC_MED));
ix_occ_high = find(av_occupancy_subits > THRESHOLD_OCC_MED);

THRESHOLD_OCC_LOW_MIN = 0.05;
THRESHOLD_OCC_LOW_MAX = 0.10;
THRESHOLD_OCC_MED_MIN = 0.15;
THRESHOLD_OCC_MED_MAX = 0.20;
THRESHOLD_OCC_HIGH_MIN = 0.25;
THRESHOLD_OCC_HIGH_MAX = 1;
ix_occ_low = find(av_occupancy_subits >= THRESHOLD_OCC_LOW_MIN & av_occupancy_subits < THRESHOLD_OCC_LOW_MAX);
ix_occ_btw_low_med = find(av_occupancy_subits >= THRESHOLD_OCC_LOW_MAX & av_occupancy_subits < THRESHOLD_OCC_MED_MIN);
ix_occ_med = find(av_occupancy_subits >= THRESHOLD_OCC_MED_MIN & av_occupancy_subits < THRESHOLD_OCC_MED_MAX);
ix_occ_btw_med_high = find(av_occupancy_subits >= THRESHOLD_OCC_MED_MAX & av_occupancy_subits < THRESHOLD_OCC_HIGH_MIN);
ix_occ_high = find(av_occupancy_subits >= THRESHOLD_OCC_HIGH_MIN & av_occupancy_subits < THRESHOLD_OCC_HIGH_MAX);


THRESHOLD_SPARSITY_LOW = 0.075;
THRESHOLD_SPARSITY_MED = 0.15;
ix_sparsity_low = find(av_sparsity_subits < THRESHOLD_SPARSITY_LOW);
ix_sparsity_med = find((av_sparsity_subits >= THRESHOLD_SPARSITY_LOW & av_occupancy_subits < THRESHOLD_SPARSITY_MED));
ix_sparsity_high = find(av_sparsity_subits > THRESHOLD_SPARSITY_MED);

THRESHOLD_SPECT_FREQ_LOW = 0.1;
THRESHOLD_SPECT_FREQ_MED = 0.20;
ix_spectral_low = find(av_spectral_change_freq_subits < THRESHOLD_SPECT_FREQ_LOW);
ix_spectral_med = find((av_spectral_change_freq_subits >= THRESHOLD_SPECT_FREQ_LOW & av_spectral_change_freq_subits < THRESHOLD_SPECT_FREQ_MED));
ix_spectral_high = find(av_spectral_change_freq_subits > THRESHOLD_SPECT_FREQ_MED);

THRESHOLD_TEMP_FREQ_LOW = 0.075;
THRESHOLD_TEMP_FREQ_MED = 0.075;
ix_temp_low = find(av_temporal_change_freq_subits < THRESHOLD_TEMP_FREQ_LOW);
ix_temp_med = find((av_temporal_change_freq_subits >= THRESHOLD_TEMP_FREQ_LOW & av_spectral_change_freq_subits < THRESHOLD_TEMP_FREQ_MED));
ix_temp_high = find(av_temporal_change_freq_subits > THRESHOLD_TEMP_FREQ_MED);

% - Max throughput
%[max_primary_temporal_sparsity_subits, max_primary_ix_temporal_sparsity] = max(av_per_ch_temporal_change_freq_subits,[],2);

% --- HINDER ---
% - Mean throughput
mean_throughput_cb_cont_hinder = mean(av_throughput_cb_cont_hinder_subits,2) * 1E-6;
mean_throughput_cb_noncont_hinder = mean(av_throughput_cb_noncont_hinder_subits,2) * 1E-6;
mean_throughput_sc_hinder = mean(av_throughput_sc_hinder_subits,2) * 1E-6;
mean_throughput_scb_hinder = mean(av_throughput_scb_hinder_subits,2) * 1E-6;
mean_throughput_dcb_hinder = mean(av_throughput_dcb_hinder_subits,2) * 1E-6;
mean_throughput_pp_hinder = mean(av_throughput_pp_hinder_subits,2) * 1E-6;

% - Max throughput
[max_throughput_cb_cont_hinder_subits, max_ix_cb_cont_hinder] = max(av_throughput_cb_cont_hinder_subits * 1E-6,[],2);
[max_throughput_cb_noncont_hinder_subits, max_ix_cb_noncont_hinder] = max(av_throughput_cb_noncont_hinder_subits * 1E-6,[],2);
[max_throughput_sc_hinder_subits, max_ix_sc_hinder] = max(av_throughput_sc_hinder_subits * 1E-6,[],2);
[max_throughput_scb_hinder_subits, max_ix_scb_hinder] = max(av_throughput_scb_hinder_subits * 1E-6,[],2);
[max_throughput_dcb_hinder_subits, max_ix_dcb_hinder] = max(av_throughput_dcb_hinder_subits * 1E-6,[],2);
[max_throughput_pp_hinder_subits, max_ix_pp_hinder] = max(av_throughput_pp_hinder_subits * 1E-6,[],2);

[max_throughput_cb_cont_TXOP_subits, max_ix_cb_cont_TXOP] = max(av_throughput_cb_cont_TXOP_subits * 1E-6,[],2);
[max_throughput_cb_noncont_TXOP_subits, max_ix_cb_noncont_TXOP] = max(av_throughput_cb_noncont_TXOP_subits * 1E-6,[],2);
[max_throughput_sc_TXOP_subits, max_ix_sc_TXOP] = max(av_throughput_sc_TXOP_subits * 1E-6,[],2);

% - Min throughput
[min_throughput_cb_cont_hinder_subits, min_ix_cb_cont_hinder] = min(av_throughput_cb_cont_hinder_subits * 1E-6,[],2);
[min_throughput_cb_noncont_hinder_subits, min_ix_cb_noncont_hinder] = min(av_throughput_cb_noncont_hinder_subits * 1E-6,[],2);

% - Mean without best throughput
% --- Exclude best
throughput_wo_bet_cb_cont_hinder_subits = get_mean_without_max(av_throughput_cb_cont_hinder_subits * 1E-6);
throughput_wo_bet_cb_noncont_hinder_subits = get_mean_without_max(av_throughput_cb_noncont_hinder_subits * 1E-6);

T_SAMPLE = 10*1E-6;
T_PERIOD = 0.1;

max_bwprev_sc_hinder_subits = max(av_bwprev_sc_hinder_subits,[],2) * T_SAMPLE / T_PERIOD;   % samples * MHz
max_bwprev_cb_cont_hinder_subits = max(av_bwprev_cb_cont_hinder_subits,[],2)* T_SAMPLE / T_PERIOD;
max_bwprev_cb_noncont_hinder_subits = max(av_bwprev_cb_noncont_hinder_subits,[],2)* T_SAMPLE / T_PERIOD;
max_bwprev_scb_hinder_subits = max(av_bwprev_scb_hinder_subits,[],2)* T_SAMPLE / T_PERIOD;
max_bwprev_dcb_hinder_subits = max(av_bwprev_dcb_hinder_subits,[],2)* T_SAMPLE / T_PERIOD;
max_bwprev_pp_hinder_subits = max(av_bwprev_pp_hinder_subits,[],2)* T_SAMPLE / T_PERIOD;

% - Correlation of the thr maximizing primary with the rest of channels
max_primary_corr_sc_hinder = zeros(NUM_SUBITS,NUM_RFs);
max_primary_corr_cb_cont_hinder = zeros(NUM_SUBITS,NUM_RFs);
max_primary_corr_cb_noncont_hinder = zeros(NUM_SUBITS,NUM_RFs);
mean_max_primary_corr_sc_hinder = zeros(NUM_SUBITS,1);
mean_max_primary_corr_cb_cont_hinder = zeros(NUM_SUBITS,1);
mean_max_primary_corr_cb_noncont_hinder = zeros(NUM_SUBITS,1);

for subit = 1:NUM_SUBITS
    
    corr_vector = reshape(corr_matrices(subit,max_ix_sc_hinder(subit),:),NUM_RFs,1);
    max_primary_corr_sc_hinder(subit,:) = corr_vector;
    mean_max_primary_corr_sc_hinder(subit) = mean(corr_vector(corr_vector<1));
    
    corr_vector = reshape(corr_matrices(subit,max_ix_cb_cont_hinder(subit),:),NUM_RFs,1);
    max_primary_corr_cb_cont_hinder(subit,:) = corr_vector;
    mean_max_primary_corr_cb_cont_hinder(subit) = mean(corr_vector(corr_vector<1));
    
    corr_vector = reshape(corr_matrices(subit,max_ix_cb_noncont_hinder(subit),:),NUM_RFs,1);
    max_primary_corr_cb_noncont_hinder(subit,:) = corr_vector;
    mean_max_primary_corr_cb_noncont_hinder(subit) = mean(corr_vector(corr_vector<1));
end

% - Min throughput
min_throughput_cb_cont_hinder = min(av_throughput_cb_cont_hinder_subits,[],2) * 1E-6;
min_throughput_cb_noncont_hinder = min(av_throughput_cb_noncont_hinder_subits,[],2) * 1E-6;
min_throughput_sc_hinder = min(av_throughput_sc_hinder_subits,[],2) * 1E-6;
min_throughput_scb_hinder = min(av_throughput_scb_hinder_subits,[],2) * 1E-6;
min_throughput_dcb_hinder = min(av_throughput_dcb_hinder_subits,[],2) * 1E-6;
min_throughput_pp_hinder = min(av_throughput_pp_hinder_subits,[],2) * 1E-6;

% Random primary
[m,n] = size(av_throughput_cb_cont_hinder_subits);
rand_throughput_cb_cont_hinder = av_throughput_cb_cont_hinder_subits(m*(randi(n,m,1)-1)+(1:m)') * 1E-6;
rand_throughput_cb_noncont_hinder = av_throughput_cb_noncont_hinder_subits(m*(randi(n,m,1)-1)+(1:m)') * 1E-6;
rand_throughput_sc_hinder = av_throughput_sc_hinder_subits(m*(randi(n,m,1)-1)+(1:m)') * 1E-6;
rand_throughput_scb_hinder = av_throughput_scb_hinder_subits(m*(randi(n,m,1)-1)+(1:m)') * 1E-6;
rand_throughput_dcb_hinder = av_throughput_dcb_hinder_subits(m*(randi(n,m,1)-1)+(1:m)') * 1E-6;
rand_throughput_pp_hinder = av_throughput_pp_hinder_subits(m*(randi(n,m,1)-1)+(1:m)') * 1E-6;

%% HIDDEN
[max_throughput_cb_cont_hidden_subits, max_ix_cb_cont_hidden] = max(av_throughput_cb_cont_hidden_subits * 1E-6,[],2);
[max_throughput_cb_noncont_hidden_subits, max_ix_cb_noncont_hidden] = max(av_throughput_cb_noncont_hidden_subits * 1E-6,[],2);
[max_throughput_sc_hidden_subits, max_ix_sc_hidden] = max(av_throughput_sc_hidden_subits * 1E-6,[],2);
[max_throughput_scb_hidden_subits, max_ix_scb_hidden] = max(av_throughput_scb_hidden_subits * 1E-6,[],2);
[max_throughput_dcb_hidden_subits, max_ix_dcb_hidden] = max(av_throughput_dcb_hidden_subits * 1E-6,[],2);
[max_throughput_pp_hidden_subits, max_ix_pp_hidden] = max(av_throughput_pp_hidden_subits * 1E-6,[],2);

%% FOREKWNOWING
[max_throughput_cb_cont_foreknowing_subits, max_ix_cb_cont_hidden] = max(av_throughput_cb_cont_TXOP_subits * 1E-6,[],2);
[max_throughput_cb_noncont_foreknowing_subits, max_ix_cb_noncont_hidden] = max(av_throughput_cb_noncont_TXOP_subits * 1E-6,[],2);
[max_throughput_sc_foreknowing_subits, max_ix_sc_hidden] = max(av_throughput_sc_TXOP_subits * 1E-6,[],2);
[max_throughput_scb_foreknowing_subits, max_ix_scb_hidden] = max(av_throughput_scb_TXOP_subits * 1E-6,[],2);
[max_throughput_dcb_foreknowing_subits, max_ix_dcb_hidden] = max(av_throughput_dcb_TXOP_subits * 1E-6,[],2);
[max_throughput_pp_foreknowing_subits, max_ix_pp_hidden] = max(av_throughput_pp_TXOP_subits * 1E-6,[],2);

mean_throughput_cb_cont_foreknowing = mean(av_throughput_cb_cont_TXOP_subits,2) * 1E-6;
mean_throughput_cb_noncont_foreknowing = mean(av_throughput_cb_noncont_TXOP_subits,2) * 1E-6;

%% PLOTS


%% Scatter ratio CB-cont vs. CB-noncont
best_ratio_cont_noncont  =  max_throughput_cb_cont_hinder_subits ./ max_throughput_cb_noncont_hinder_subits;
figure
hold on
scatter(av_occupancy_subits(best_ratio_cont_noncont>1), best_ratio_cont_noncont(best_ratio_cont_noncont>1),marker_size,'x','markeredgecolor','r')
scatter(av_occupancy_subits(best_ratio_cont_noncont<=1), best_ratio_cont_noncont(best_ratio_cont_noncont<=1),marker_size,'o','markeredgecolor','c')
ylabel({'best-trhoughput ratio';'CO vs. NC'}, 'interpreter', 'latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter', 'latex')
grid on
xlim([0 0.5])
ylim([0.6 1.1])
legend('CO ','NC wins')

mean_ratio_cont_noncont  =  mean_throughput_cb_cont_hinder ./ mean_throughput_cb_noncont_hinder;
figure
hold on
scatter(av_occupancy_subits(mean_ratio_cont_noncont>1), mean_ratio_cont_noncont(mean_ratio_cont_noncont>1),marker_size,'x','markeredgecolor','r')
scatter(av_occupancy_subits(mean_ratio_cont_noncont<=1), mean_ratio_cont_noncont(mean_ratio_cont_noncont<=1),marker_size,'o','markeredgecolor','c')
ylabel({'trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter', 'latex')
grid on
xlim([0 0.5])
ylim([0.6 1.1])
legend('Cont wins','Non-cont wins')


all_ratio_cont_noncont  =  av_throughput_cb_cont_hinder_subits(:) ./ av_throughput_cb_noncont_hinder_subits(:);
figure
hold on
all_occupancy_subits = repelem(av_occupancy_subits,8);
scatter(all_occupancy_subits(all_ratio_cont_noncont>1), all_ratio_cont_noncont(all_ratio_cont_noncont>1),marker_size,'x','markeredgecolor','r')
scatter(all_occupancy_subits(all_ratio_cont_noncont<=1), all_ratio_cont_noncont(all_ratio_cont_noncont<=1),marker_size,'o','markeredgecolor','c')
ylabel({'trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter', 'latex')
grid on
xlim([0 0.5])
ylim([0.0 1.2])
legend('Cont wins','Non-cont wins')

av_throughput_cb_cont_hinder_subits_aux = av_throughput_cb_cont_hinder_subits';
av_throughput_cb_noncont_hinder_subits_aux = av_throughput_cb_noncont_hinder_subits';
all_ratio_cont_noncont  =  av_throughput_cb_cont_hinder_subits_aux(:) ./ av_throughput_cb_noncont_hinder_subits_aux(:);
figure
hold on
all_occupancy_subits = repelem(av_occupancy_subits,8);
scatter(all_occupancy_subits(all_ratio_cont_noncont>1), all_ratio_cont_noncont(all_ratio_cont_noncont>1),marker_size,'x','markeredgecolor','r')
scatter(all_occupancy_subits(all_ratio_cont_noncont<=1), all_ratio_cont_noncont(all_ratio_cont_noncont<=1),marker_size,'o','markeredgecolor','c')
ylabel({'trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter', 'latex')
grid on
xlim([0 0.5])
ylim([0.0 1.2])
legend('Cont wins','Non-cont wins')


%% Bar chart ratio CB-cont vs. CB-noncont

THRESHOLD_OCC_LOW = 0.1;
THRESHOLD_OCC_MED = 0.2;
ix_occ_low = find(av_occupancy_subits < THRESHOLD_OCC_LOW);
ix_occ_med = find((av_occupancy_subits >= THRESHOLD_OCC_LOW & av_occupancy_subits < THRESHOLD_OCC_MED));
ix_occ_high = find(av_occupancy_subits > THRESHOLD_OCC_MED);

best_ratio_cont_vs_noncont = [mean(best_ratio_cont_noncont(ix_occ_low))...
    mean(mean(best_ratio_cont_noncont(ix_occ_med)))...
    mean(mean(best_ratio_cont_noncont(ix_occ_high)))];

prob_co_wins = length(best_ratio_cont_vs_noncont(best_ratio_cont_vs_noncont>1)) / length(best_ratio_cont_vs_noncont);
prob_nc_wins = length(best_ratio_cont_vs_noncont(best_ratio_cont_vs_noncont<1)) / length(best_ratio_cont_vs_noncont);
max_diff_co_wins = max(best_ratio_cont_vs_noncont);
mean_diff_co_wins = mean(best_ratio_cont_vs_noncont(best_ratio_cont_vs_noncont>1));

fprintf('Best primaries. Probability winning CO vs NC: P(CO wins) = %.4f - P(NC wins) = %.4f - Max gain CO = %.4f - Mean gain CO = %.4f\n',...
    prob_co_wins, prob_nc_wins, max_diff_co_wins, mean_diff_co_wins)


figure
hold on
bar(1, best_ratio_cont_vs_noncont(1), 'g')
bar(2, best_ratio_cont_vs_noncont(2), 'y')
bar(3, best_ratio_cont_vs_noncont(3), 'r')

ylabel({'mean best-trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
title('CB-cont')
grid on


mean_ratio_cont_vs_noncont = [mean(mean_ratio_cont_noncont(ix_occ_low))...
    mean(mean_ratio_cont_noncont(ix_occ_med))...
    mean(mean_ratio_cont_noncont(ix_occ_high))];

figure
hold on
bar(1, mean_ratio_cont_vs_noncont(1), 'g')
bar(2, mean_ratio_cont_vs_noncont(2), 'y')
bar(3, mean_ratio_cont_vs_noncont(3), 'r')
ylabel({'mean trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
title('CB-cont')
grid on

mean_ratio_cont_noncont  =  mean_throughput_cb_cont_hinder ./ mean_throughput_cb_noncont_hinder;
figure
hold on
scatter(av_occupancy_subits(mean_ratio_cont_noncont>1), mean_ratio_cont_noncont(mean_ratio_cont_noncont>1),marker_size,'x','markeredgecolor','r')
scatter(av_occupancy_subits(mean_ratio_cont_noncont<=1), mean_ratio_cont_noncont(mean_ratio_cont_noncont<=1),marker_size,'o','markeredgecolor','c')
ylabel({'trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter', 'latex')
grid on
xlim([0 0.5])
ylim([0.6 1.1])
legend('Cont wins','Non-cont wins')

axes('Position',[.7 .7 .2 .2])
box on
hold on
bar(1, mean_ratio_cont_vs_noncont(1), 'g')
bar(2, mean_ratio_cont_vs_noncont(2), 'y')
bar(3, mean_ratio_cont_vs_noncont(3), 'r')
ylabel({'mean trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
title('CB-cont')
grid on

prob_co_wins = length(mean_ratio_cont_noncont(mean_ratio_cont_noncont>1)) / length(mean_ratio_cont_noncont);
prob_nc_wins = length(mean_ratio_cont_noncont(mean_ratio_cont_noncont<1)) / length(mean_ratio_cont_noncont);
max_diff_co_wins = max(mean_ratio_cont_noncont);
mean_diff_co_wins = mean(mean_ratio_cont_noncont(mean_ratio_cont_noncont>1));

fprintf('Probability winning CO vs NC: P(CO wins) = %.4f - P(NC wins) = %.4f - Max gain CO = %.4f - Mean gain CO = %.4f\n',...
    prob_co_wins, prob_nc_wins, max_diff_co_wins, mean_diff_co_wins)



av_throughput_cb_cont_hinder_subits_aux = av_throughput_cb_cont_hinder_subits';
av_throughput_cb_noncont_hinder_subits_aux = av_throughput_cb_noncont_hinder_subits';
all_ratio_cont_noncont  =  av_throughput_cb_cont_hinder_subits_aux(:) ./ av_throughput_cb_noncont_hinder_subits_aux(:);
figure
hold on
all_occupancy_subits = repelem(av_occupancy_subits,8);
scatter(all_occupancy_subits(all_ratio_cont_noncont>1), all_ratio_cont_noncont(all_ratio_cont_noncont>1),marker_size,'x','markeredgecolor','r')
scatter(all_occupancy_subits(all_ratio_cont_noncont<=1), all_ratio_cont_noncont(all_ratio_cont_noncont<=1),marker_size,'o','markeredgecolor','c')
ylabel({'trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter', 'latex')
grid on
xlim([0 0.5])
ylim([0 1.2])
legend('Cont wins','Non-cont wins')

prob_co_wins = length(all_ratio_cont_noncont(all_ratio_cont_noncont>1)) / length(all_ratio_cont_noncont);
prob_nc_wins = length(all_ratio_cont_noncont(all_ratio_cont_noncont<1)) / length(all_ratio_cont_noncont);
max_diff_co_wins = max(all_ratio_cont_noncont);
mean_diff_co_wins = mean(all_ratio_cont_noncont(all_ratio_cont_noncont>1));

fprintf('All primaries. Probability winning CO vs NC: P(CO wins) = %.4f - P(NC wins) = %.4f - Max gain CO = %.4f - Mean gain CO = %.4f\n',...
    prob_co_wins, prob_nc_wins, max_diff_co_wins, mean_diff_co_wins)


all_ratio_cont_vs_noncont = [mean(all_ratio_cont_noncont(repelem(ix_occ_low,8)))...
    mean(all_ratio_cont_noncont(repelem(ix_occ_med,8)))...
    mean(all_ratio_cont_noncont(repelem(ix_occ_high,8)))];

axes('Position',[.7 .7 .2 .2])
box on
hold on
bar(1, mean_ratio_cont_vs_noncont(1), 'g')
bar(2, mean_ratio_cont_vs_noncont(2), 'y')
bar(3, mean_ratio_cont_vs_noncont(3), 'r')
ylabel({'mean trhoughput ratio';'Cont vs. Non-cont'}, 'interpreter', 'latex')
title('CB-cont')
ylim([0.9 1])
grid on

rectangle('Position', [0.0 0.0 0.10 1.2], 'FaceColor', [0 1 0 0.1])
set(gca,'children',flipud(get(gca,'children')))
rectangle('Position', [0.1 0.0 0.10 1.2], 'FaceColor', [1 1 0 0.12])
set(gca,'children',flipud(get(gca,'children')))
rectangle('Position', [0.2 0.0 0.25 1.2], 'FaceColor', [1 0 0 0.07])
set(gca,'children',flipud(get(gca,'children')))

%% Normalized throughput vs. occupancy -- Average and max
figure
sgtitle('Hinder')
subplot(1,2,1)
hold on
scatter(av_occupancy_subits, mean_throughput_cb_cont_hinder./mean_throughput_sc_hinder,marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits, max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,marker_size,'x','markeredgecolor','k')
ylabel('norm. throughput','interpreter','latex')
xlabel('mean band occupancy $\bar{o}_B$','interpreter','latex')
title('CO')
grid on
xlim([0 0.5])
ylim([3 7])
subplot(1,2,2)
hold on
scatter(av_occupancy_subits, mean_throughput_cb_noncont_hinder./mean_throughput_sc_hinder,marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits, max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,marker_size,'x','markeredgecolor','k')
xlabel('mean band occupancy $\bar{o}_B$','interpreter','latex')
title('NC')
grid on
xlim([0 0.5])
ylim([3 7])
legend('Mean: $\bar{\Gamma}$','Best: $\bar{\Gamma}^*$')

% Max penalty (without plots)

norm_mean_thr_cb_cont_hinder = mean_throughput_cb_cont_hinder./mean_throughput_sc_hinder;
norm_max_thr_cb_cont_hinder = max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits;
max_mean_ratio = norm_max_thr_cb_cont_hinder ./ norm_mean_thr_cb_cont_hinder;

norm_mean_thr_cb_noncont_hinder = mean_throughput_cb_noncont_hinder./mean_throughput_sc_hinder;
norm_max_thr_cb_noncont_hinder = max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits;



%% Penalty of not deprivating others
figure
subplot(1,2,1)
hold on
scatter(av_occupancy_subits,...
    (max_throughput_cb_cont_hinder_subits - max_throughput_cb_cont_foreknowing_subits)./max_throughput_cb_cont_hinder_subits,...
    'x','markeredgecolor','b')
ylabel(['Foreknowing penalty \mu'])
xlabel('Mean occupancy')
title('CB-cont')
grid on
xlim([0 0.5])

subplot(1,2,2)
hold on
scatter(av_occupancy_subits,...
    (max_throughput_cb_noncont_hinder_subits - max_throughput_cb_noncont_foreknowing_subits)./max_throughput_cb_noncont_hinder_subits,...
    'x','markeredgecolor','b')
xlabel('Mean occupancy')
title('CB-non-cont')
grid on
xlim([0 0.5])


%%

% Thr. difference best vs. mean w/o best
ix_occ_5to10 = find(av_occupancy_subits < 0.10);
ix_occ_10to15 = find(av_occupancy_subits >= 0.10 & av_occupancy_subits < 0.15);
ix_occ_15to20 = find(av_occupancy_subits >= 0.15 & av_occupancy_subits < 0.20);
ix_occ_20to25 = find(av_occupancy_subits >= 0.20 & av_occupancy_subits < 0.25);
ix_occ_25to30 = find(av_occupancy_subits >= 0.25 & av_occupancy_subits < 0.30);
ix_occ_30to35 = find(av_occupancy_subits >= 0.30 & av_occupancy_subits < 0.35);
ix_occ_35to40 = find(av_occupancy_subits >= 0.35 & av_occupancy_subits < 0.40);
ix_occ_40to45 = find(av_occupancy_subits >= 0.40 & av_occupancy_subits < 0.45);
ix_occ_45to50 = find(av_occupancy_subits >= 0.45 & av_occupancy_subits < 0.50);

mean_penalty_cb_cont = [mean((max_throughput_cb_cont_hinder_subits(ix_occ_5to10) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_5to10))./max_throughput_cb_cont_hinder_subits(ix_occ_5to10)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_10to15) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_10to15))./max_throughput_cb_cont_hinder_subits(ix_occ_10to15)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_15to20) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_15to20))./max_throughput_cb_cont_hinder_subits(ix_occ_15to20)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_20to25) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_20to25))./max_throughput_cb_cont_hinder_subits(ix_occ_20to25)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_25to30) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_25to30))./max_throughput_cb_cont_hinder_subits(ix_occ_25to30)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_30to35) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_30to35))./max_throughput_cb_cont_hinder_subits(ix_occ_30to35)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_35to40) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_35to40))./max_throughput_cb_cont_hinder_subits(ix_occ_35to40)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_40to45) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_40to45))./max_throughput_cb_cont_hinder_subits(ix_occ_40to45)),...
    mean((max_throughput_cb_cont_hinder_subits(ix_occ_45to50) - throughput_wo_bet_cb_cont_hinder_subits(ix_occ_45to50))./max_throughput_cb_cont_hinder_subits(ix_occ_45to50))];

mean_penalty_cb_noncont = [mean((max_throughput_cb_noncont_hinder_subits(ix_occ_5to10) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_5to10))./max_throughput_cb_noncont_hinder_subits(ix_occ_5to10)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_10to15) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_10to15))./max_throughput_cb_noncont_hinder_subits(ix_occ_10to15)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_15to20) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_15to20))./max_throughput_cb_noncont_hinder_subits(ix_occ_15to20)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_20to25) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_20to25))./max_throughput_cb_noncont_hinder_subits(ix_occ_20to25)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_25to30) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_25to30))./max_throughput_cb_noncont_hinder_subits(ix_occ_25to30)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_30to35) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_30to35))./max_throughput_cb_noncont_hinder_subits(ix_occ_30to35)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_35to40) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_35to40))./max_throughput_cb_noncont_hinder_subits(ix_occ_35to40)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_40to45) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_40to45))./max_throughput_cb_noncont_hinder_subits(ix_occ_40to45)),...
    mean((max_throughput_cb_noncont_hinder_subits(ix_occ_45to50) - throughput_wo_bet_cb_noncont_hinder_subits(ix_occ_45to50))./max_throughput_cb_noncont_hinder_subits(ix_occ_45to50))];


max_penalty_cb_cont = max(1 - (throughput_wo_bet_cb_cont_hinder_subits ./ max_throughput_cb_cont_hinder_subits));
max_gain_cb_cont = max((max_throughput_cb_cont_hinder_subits ./ throughput_wo_bet_cb_cont_hinder_subits) - 1);
max_penalty_cb_noncont = max(1 - (throughput_wo_bet_cb_noncont_hinder_subits ./ max_throughput_cb_noncont_hinder_subits));
max_gain_cb_noncont = max((max_throughput_cb_noncont_hinder_subits ./ throughput_wo_bet_cb_noncont_hinder_subits) - 1);

fprintf('Max. gain and penalty for not selecting the best primary: CO = %.2f, %.2f - NC = %.2f, %.2f\n',...
    max_penalty_cb_cont, max_gain_cb_cont, max_penalty_cb_noncont, max_gain_cb_noncont)

figure
subplot(1,2,1)
hold on
scatter(av_occupancy_subits,...
    (max_throughput_cb_cont_hinder_subits - throughput_wo_bet_cb_cont_hinder_subits)./max_throughput_cb_cont_hinder_subits,...
    'x','markeredgecolor','b')

plot(0.075:0.05:0.475, mean_penalty_cb_cont)

ylabel(['Norm. throughput'])
xlabel('Mean occupancy')
title('CB-cont')
grid on
xlim([0 0.5])
subplot(1,2,2)
hold on
scatter(av_occupancy_subits,...
    (max_throughput_cb_noncont_hinder_subits - throughput_wo_bet_cb_noncont_hinder_subits)./max_throughput_cb_noncont_hinder_subits,...
    'x','markeredgecolor','b')
plot(0.075:0.05:0.475, mean_penalty_cb_noncont)
xlabel('Mean occupancy')
title('CB-non-cont')
grid on
xlim([0 0.5])
legend('\rho', 'mean')

% Max throughput vs. occupancy. Colored by spectral change freq.

figure
sgtitle('Hinder')
subplot(1,2,1)
hold on
scatter(av_occupancy_subits, max_throughput_cb_cont_hinder_subits,marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits(ix_spectral_high), max_throughput_cb_cont_hinder_subits(ix_spectral_high),marker_size,'x','markeredgecolor','r')
xlabel('Mean occupancy')
title('CB-cont')
grid on
ylim([0 700])

subplot(1,2,2)
hold on
scatter(av_occupancy_subits, max_throughput_cb_noncont_hinder_subits,marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits(ix_spectral_high), max_throughput_cb_noncont_hinder_subits(ix_spectral_high),marker_size,'x','markeredgecolor','r')
xlabel('Mean occupancy')
title('CB-non-cont')
grid on
ylim([0 700])

%% 
% Subplot spectral variance
thresholds_high_spect_variance = [0.10 0.15 0.20];
figure
subplot_ix = 0;
PERCENTILE_MIN = 1;
PERCENTILE_MAX = 99;
for th_ix = 1:length(thresholds_high_spect_variance)
    
    ix_spectral_high = find(av_spectral_change_freq_subits > thresholds_high_spect_variance(th_ix));
    subplot_ix = subplot_ix + 1;
    subplot(length(thresholds_high_spect_variance),2,subplot_ix)
    hold on
    scatter(av_occupancy_subits, max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,marker_size,'o','markeredgecolor','c')
    
    norm_thr = max_throughput_cb_cont_hinder_subits(ix_spectral_high)./max_throughput_sc_hinder_subits(ix_spectral_high);
    
    scatter(av_occupancy_subits(ix_spectral_high),...
        norm_thr,...
        marker_size,'x','markeredgecolor','r')
    xlabel('Mean occupancy')
    title('CB-cont')
    grid on
    ylim([3 6.5])
    
    fprintf('- Norm. CB-cont thr. (holes #%d): mean = %.2f - %d%% percentile = %.2f - %d%% percentile = %.2f - \n', ...
        th_ix,mean(norm_thr),...
        PERCENTILE_MIN,prctile(norm_thr,PERCENTILE_MIN), PERCENTILE_MAX, prctile(norm_thr,PERCENTILE_MAX))
    

    subplot_ix = subplot_ix + 1;
    subplot(length(thresholds_high_spect_variance),2,subplot_ix)
    hold on
    scatter(av_occupancy_subits, max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,marker_size,'o','markeredgecolor','c')
    
    norm_thr = max_throughput_cb_noncont_hinder_subits(ix_spectral_high)./max_throughput_sc_hinder_subits(ix_spectral_high);
    
    scatter(av_occupancy_subits(ix_spectral_high),...
        norm_thr,...
        marker_size,'x','markeredgecolor','r')
    xlabel('Mean occupancy')
    title('CB-non-cont')
    grid on
    ylim([3 6.5])
    
    fprintf('- Norm. CB-cont thr. (holes #%d): mean = %.2f - %d%% percentile = %.2f - %d%% percentile = %.2f - \n', ...
        th_ix,mean(norm_thr),...
        PERCENTILE_MIN,prctile(norm_thr,PERCENTILE_MIN), PERCENTILE_MAX, prctile(norm_thr,PERCENTILE_MAX))
    
%     fprintf('- Norm. CB-cont thr. (occupancy #%d): %.2f\n', th_ix,...
%         mean( max_throughput_cb_noncont_hinder_subits(ix_spectral_high)./max_throughput_sc_hinder_subits(ix_spectral_high)))

end

%%
% Boxplot spectral variability vs. occupancy category
figure
x1 = av_spectral_change_freq_subits(ix_occ_low)';
x2 = av_spectral_change_freq_subits(ix_occ_med)';
x3 = av_spectral_change_freq_subits(ix_occ_high)';
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Spectral variability $\varphi$ [Mbps]', 'Interpreter','latex')
xlabel('Mean occupancy at 160 MHz')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

%% Penalty of not depriving
% Penalty of not depriving
figure
subplot(1,2,1)

x1 = (max_throughput_cb_cont_hinder_subits(ix_occ_low) - max_throughput_cb_cont_foreknowing_subits(ix_occ_low))...
    ./max_throughput_cb_cont_hinder_subits(ix_occ_low);
x2 = (max_throughput_cb_cont_hinder_subits(ix_occ_med) - max_throughput_cb_cont_foreknowing_subits(ix_occ_med))...
    ./max_throughput_cb_cont_hinder_subits(ix_occ_med);
x3 = (max_throughput_cb_cont_hinder_subits(ix_occ_high) - max_throughput_cb_cont_foreknowing_subits(ix_occ_high))...
    ./max_throughput_cb_cont_hinder_subits(ix_occ_high);

x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Penalty $\mu$', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-cont')
rectangle('Position', [-1 -0.25 7 0.25], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

subplot(1,2,2)

x1 = (max_throughput_cb_noncont_hinder_subits(ix_occ_low) - max_throughput_cb_noncont_foreknowing_subits(ix_occ_low))...
    ./max_throughput_cb_noncont_hinder_subits(ix_occ_low);
x2 = (max_throughput_cb_noncont_hinder_subits(ix_occ_med) - max_throughput_cb_noncont_foreknowing_subits(ix_occ_med))...
    ./max_throughput_cb_noncont_hinder_subits(ix_occ_med);
x3 = (max_throughput_cb_noncont_hinder_subits(ix_occ_high) - max_throughput_cb_noncont_foreknowing_subits(ix_occ_high))...
    ./max_throughput_cb_noncont_hinder_subits(ix_occ_high);

x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Penalty $\gamma$', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-non-cont')
rectangle('Position', [-1 -0.25 7 0.25], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

prob_foreknowing_better_hinder_cb_cont = ...
    sum(max_throughput_cb_cont_hinder_subits - max_throughput_cb_cont_foreknowing_subits < 0) /...
    length(max_throughput_cb_cont_hinder_subits);

prob_foreknowing_better_hinder_cb_noncont = ...
    sum(max_throughput_cb_noncont_hinder_subits - max_throughput_cb_noncont_foreknowing_subits < 0) /...
    length(max_throughput_cb_cont_hinder_subits);

%%
% Scatter plot x-axis: spectral variability, y-axis: occupancy
figure
hold on
scatter(av_spectral_change_freq_subits(ix_occ_low),av_occupancy_subits(ix_occ_low),...
    marker_size,'o')
scatter(av_spectral_change_freq_subits(ix_occ_btw_low_med),av_occupancy_subits(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(av_spectral_change_freq_subits(ix_occ_med),av_occupancy_subits(ix_occ_med),...
    marker_size,'o')
scatter(av_spectral_change_freq_subits(ix_occ_btw_med_high),av_occupancy_subits(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(av_spectral_change_freq_subits(ix_occ_high),av_occupancy_subits(ix_occ_high),...
    marker_size,'o')

xline(0.10)
xline(0.15)
xline(0.20)

xlabel('Spectral variability $\varphi$', 'Interpreter','latex')
ylabel('Mean occupancy')
legend('Low','Low-Med','Med','Med-High','High')
grid on
ylim([0 0.5])
xlim([0 0.3])




%% Correlation analysis
THRESHOLD_CORR_LOW = 0.005;
ix_corr_sc_low = find(mean_max_primary_corr_sc_hinder < THRESHOLD_CORR_LOW);
ix_corr_cb_cont_low = find(mean_max_primary_corr_cb_cont_hinder < THRESHOLD_CORR_LOW);
ix_corr_cb_noncont_low = find(mean_max_primary_corr_cb_noncont_hinder < THRESHOLD_CORR_LOW);

THRESHOLD_CORR_HIGH = 0.05;
ix_corr_sc_high = find(mean_max_primary_corr_sc_hinder > THRESHOLD_CORR_HIGH);
ix_corr_cb_cont_high = find(mean_max_primary_corr_cb_cont_hinder > THRESHOLD_CORR_HIGH);
ix_corr_cb_noncont_high = find(mean_max_primary_corr_cb_noncont_hinder > THRESHOLD_CORR_HIGH);

figure
sgtitle('Hinder')
subplot(1,2,1)
hold on
scatter(av_occupancy_subits, max_throughput_cb_cont_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits(ix_corr_cb_cont_high), max_throughput_cb_cont_hinder_subits(ix_corr_cb_cont_high),marker_size,'*','markeredgecolor','r')
xlabel('Mean occupancy')
title('CB-cont')
grid on
ylim([300 700])

subplot(1,2,2)
hold on
scatter(av_occupancy_subits, max_throughput_cb_noncont_hinder_subits,marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits(ix_corr_cb_noncont_high), max_throughput_cb_noncont_hinder_subits(ix_corr_cb_noncont_high),marker_size,'*','markeredgecolor','r')
xlabel('Mean occupancy')
title('CB-non-cont')
grid on
ylim([300 700])

% Correlation and normalizaed throughput
figure
sgtitle('Hinder')
subplot(1,2,1)
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits(ix_corr_cb_cont_high),...
    max_throughput_cb_cont_hinder_subits(ix_corr_cb_cont_high)./max_throughput_sc_hinder_subits(ix_corr_cb_cont_high),...
    marker_size,'*','markeredgecolor','r')
xlabel('Mean occupancy')
title('CB-cont')
grid on
ylim([3 6.5])

subplot(1,2,2)
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
scatter(av_occupancy_subits(ix_corr_cb_noncont_high),...
    max_throughput_cb_noncont_hinder_subits(ix_corr_cb_noncont_high)./max_throughput_sc_hinder_subits(ix_corr_cb_noncont_high),...
    marker_size,'*','markeredgecolor','r')
xlabel('Mean occupancy')
title('CB-non-cont')
grid on
ylim([3 6.5])

%%
% Subplot correlation
THRESHOLD_CORRELATION = [0.05 0.2 0.5];
figure
subplot_ix = 0;

PERCENTILE_MIN = 1;
PERCENTILE_MAX = 99;

for th_ix = 1:length(THRESHOLD_CORRELATION)
    
    ix_corr_cb_cont_high = find(mean_max_primary_corr_cb_cont_hinder > THRESHOLD_CORRELATION(th_ix));
    subplot_ix = subplot_ix + 1;
    subplot(length(THRESHOLD_CORRELATION),2,subplot_ix)
    hold on
    scatter(av_occupancy_subits,...
        max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,...
        marker_size,'o','markeredgecolor','c')
    
    norm_thr = max_throughput_cb_cont_hinder_subits(ix_corr_cb_cont_high)./max_throughput_sc_hinder_subits(ix_corr_cb_cont_high);
    scatter(av_occupancy_subits(ix_corr_cb_cont_high),...
        norm_thr,...
        marker_size,'*','markeredgecolor','r')
    title('CB-cont')
    grid on
    ylim([3 6.5])
    
    fprintf('- Norm. CB-cont thr. (corr #%d): mean = %.2f - %d%% percentile = %.2f - %d%% percentile = %.2f - \n', ...
        th_ix,mean(norm_thr),...
        PERCENTILE_MIN,prctile(norm_thr,PERCENTILE_MIN), PERCENTILE_MAX, prctile(norm_thr,PERCENTILE_MAX))
    

    ix_corr_cb_noncont_high = find(mean_max_primary_corr_cb_noncont_hinder > THRESHOLD_CORRELATION(th_ix));
    subplot_ix = subplot_ix + 1;
    subplot(length(thresholds_high_spect_variance),2,subplot_ix)
    hold on
    scatter(av_occupancy_subits,...
        max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,...
        marker_size,'o','markeredgecolor','c')
    
    norm_thr = max_throughput_cb_noncont_hinder_subits(ix_corr_cb_noncont_high)./max_throughput_sc_hinder_subits(ix_corr_cb_noncont_high);
    
    scatter(av_occupancy_subits(ix_corr_cb_noncont_high),...
        norm_thr,...
        marker_size,'*','markeredgecolor','r')
        title('CB-non-cont')
    grid on
    ylim([3 6.5])
    
    fprintf('- Norm. CB-non-cont thr. (corr #%d): mean = %.2f - %d%% percentile = %.2f - %d%% percentile = %.2f - \n', ...
        th_ix,mean(norm_thr),...
        PERCENTILE_MIN,prctile(norm_thr,PERCENTILE_MIN), PERCENTILE_MAX, prctile(norm_thr,PERCENTILE_MAX))

end
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

%%
% Subplot correlation Knightly: just one threshold defining low and high
% correlation

THRESHOLD_CORRELATION_LOW = 0.1;
THRESHOLD_CORRELATION_HIGH = 0.4;

PERCENTILE_MIN = 1;
PERCENTILE_MAX = 99;

figure
subplot(1,2,1)
ix_low_corr_cb_cont = find(mean_max_primary_corr_cb_cont_hinder < THRESHOLD_CORRELATION_LOW);
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')

norm_thr = max_throughput_cb_cont_hinder_subits(ix_low_corr_cb_cont)./max_throughput_sc_hinder_subits(ix_low_corr_cb_cont);
scatter(av_occupancy_subits(ix_low_corr_cb_cont),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
title('CO')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

subplot(1,2,2)
ix_low_corr_cb_noncont_high = find(mean_max_primary_corr_cb_noncont_hinder < THRESHOLD_CORRELATION_LOW);
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
norm_thr = max_throughput_cb_noncont_hinder_subits(ix_low_corr_cb_noncont_high)./max_throughput_sc_hinder_subits(ix_low_corr_cb_noncont_high);
scatter(av_occupancy_subits(ix_low_corr_cb_noncont_high),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
    title('NC')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

% High correlation
figure
subplot(1,2,1)
ix_low_corr_cb_cont = find(mean_max_primary_corr_cb_cont_hinder > THRESHOLD_CORRELATION_HIGH);
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')

norm_thr = max_throughput_cb_cont_hinder_subits(ix_low_corr_cb_cont)./max_throughput_sc_hinder_subits(ix_low_corr_cb_cont);
scatter(av_occupancy_subits(ix_low_corr_cb_cont),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
title('CO')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

subplot(1,2,2)
ix_low_corr_cb_noncont_high = find(mean_max_primary_corr_cb_noncont_hinder > THRESHOLD_CORRELATION_HIGH);
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
norm_thr = max_throughput_cb_noncont_hinder_subits(ix_low_corr_cb_noncont_high)./max_throughput_sc_hinder_subits(ix_low_corr_cb_noncont_high);
scatter(av_occupancy_subits(ix_low_corr_cb_noncont_high),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
    title('NC')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

%%
% Subplot correlation Knightly: three correlation categories
% correlation

THRESHOLD_CORRELATION_LOW_MIN = -0.1;
THRESHOLD_CORRELATION_LOW_MAX = 0.1;
THRESHOLD_CORRELATION_MED_MIN = 0.2;
THRESHOLD_CORRELATION_MED_MAX = 0.4;
THRESHOLD_CORRELATION_HIGH_MIN = 0.5;
THRESHOLD_CORRELATION_HIGH_MAX = 0.65;

% Low correlation
figure
subplot(1,2,1)
ix_low_corr_cb_cont = find((mean_max_primary_corr_cb_cont_hinder >= THRESHOLD_CORRELATION_LOW_MIN &...
    mean_max_primary_corr_cb_cont_hinder < THRESHOLD_CORRELATION_LOW_MAX));

hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')

norm_thr = max_throughput_cb_cont_hinder_subits(ix_low_corr_cb_cont)./max_throughput_sc_hinder_subits(ix_low_corr_cb_cont);
scatter(av_occupancy_subits(ix_low_corr_cb_cont),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
title('CO')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

subplot(1,2,2)
ix_low_corr_cb_noncont_high = find((mean_max_primary_corr_cb_noncont_hinder >= THRESHOLD_CORRELATION_LOW_MIN &...
    mean_max_primary_corr_cb_noncont_hinder < THRESHOLD_CORRELATION_LOW_MAX));
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
norm_thr = max_throughput_cb_noncont_hinder_subits(ix_low_corr_cb_noncont_high)./max_throughput_sc_hinder_subits(ix_low_corr_cb_noncont_high);
scatter(av_occupancy_subits(ix_low_corr_cb_noncont_high),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
    title('NC')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
legend('all',['$' num2str(THRESHOLD_CORRELATION_LOW_MIN) '\leq \xi < ' num2str(THRESHOLD_CORRELATION_LOW_MAX) '$'])

% Medium correlation
figure
subplot(1,2,1)
ix_low_corr_cb_cont = find((mean_max_primary_corr_cb_cont_hinder >= THRESHOLD_CORRELATION_MED_MIN &...
    mean_max_primary_corr_cb_cont_hinder < THRESHOLD_CORRELATION_MED_MAX));

hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')

norm_thr = max_throughput_cb_cont_hinder_subits(ix_low_corr_cb_cont)./max_throughput_sc_hinder_subits(ix_low_corr_cb_cont);
scatter(av_occupancy_subits(ix_low_corr_cb_cont),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
title('CO')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

subplot(1,2,2)
ix_low_corr_cb_noncont_high = find((mean_max_primary_corr_cb_noncont_hinder >= THRESHOLD_CORRELATION_MED_MIN &...
    mean_max_primary_corr_cb_noncont_hinder < THRESHOLD_CORRELATION_MED_MAX));
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
norm_thr = max_throughput_cb_noncont_hinder_subits(ix_low_corr_cb_noncont_high)./max_throughput_sc_hinder_subits(ix_low_corr_cb_noncont_high);
scatter(av_occupancy_subits(ix_low_corr_cb_noncont_high),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
    title('NC')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
legend('all',['$' num2str(THRESHOLD_CORRELATION_MED_MIN) '\leq \xi < ' num2str(THRESHOLD_CORRELATION_MED_MAX) '$'])

% High correlation
figure
subplot(1,2,1)
ix_low_corr_cb_cont = find((mean_max_primary_corr_cb_cont_hinder >= THRESHOLD_CORRELATION_HIGH_MIN &...
    mean_max_primary_corr_cb_cont_hinder < THRESHOLD_CORRELATION_HIGH_MAX));
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_cont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')

norm_thr = max_throughput_cb_cont_hinder_subits(ix_low_corr_cb_cont)./max_throughput_sc_hinder_subits(ix_low_corr_cb_cont);
scatter(av_occupancy_subits(ix_low_corr_cb_cont),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
title('CO')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')

subplot(1,2,2)
ix_low_corr_cb_noncont_high = find((mean_max_primary_corr_cb_noncont_hinder >= THRESHOLD_CORRELATION_HIGH_MIN &...
    mean_max_primary_corr_cb_noncont_hinder < THRESHOLD_CORRELATION_HIGH_MAX));
hold on
scatter(av_occupancy_subits,...
    max_throughput_cb_noncont_hinder_subits./max_throughput_sc_hinder_subits,...
    marker_size,'o','markeredgecolor','c')
norm_thr = max_throughput_cb_noncont_hinder_subits(ix_low_corr_cb_noncont_high)./max_throughput_sc_hinder_subits(ix_low_corr_cb_noncont_high);
scatter(av_occupancy_subits(ix_low_corr_cb_noncont_high),...
    norm_thr,...
    marker_size,'*','markeredgecolor','r')
    title('NC')
grid on
ylim([3 6.5])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
legend('all',['$' num2str(THRESHOLD_CORRELATION_HIGH_MIN) '\leq \xi < ' num2str(THRESHOLD_CORRELATION_HIGH_MAX) '$'])

%%
% Scatter plot x-axis: correlation, y-axis: occupancy

figure
subplot(2,1,1)
hold on
scatter(mean_max_primary_corr_cb_cont_hinder(ix_occ_low),av_occupancy_subits(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder(ix_occ_btw_low_med),av_occupancy_subits(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder(ix_occ_med),av_occupancy_subits(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder(ix_occ_btw_med_high),av_occupancy_subits(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_cont_hinder(ix_occ_high),av_occupancy_subits(ix_occ_high),...
    marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
ylabel('Mean occupancy')
legend('Low','Low-Med','Med','Med-High','High')
grid on
ylim([0 0.5])

subplot(2,1,2)
hold on
scatter(mean_max_primary_corr_cb_noncont_hinder(ix_occ_low),av_occupancy_subits(ix_occ_low),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder(ix_occ_btw_low_med),av_occupancy_subits(ix_occ_btw_low_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder(ix_occ_med),av_occupancy_subits(ix_occ_med),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder(ix_occ_btw_med_high),av_occupancy_subits(ix_occ_btw_med_high),...
    marker_size,'o')
scatter(mean_max_primary_corr_cb_noncont_hinder(ix_occ_high),av_occupancy_subits(ix_occ_high),...
    marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
ylabel('Mean occupancy')
legend('Low','Low-Med','Med','Med-High','High')
grid on
ylim([0 0.5])

xline(0.05)
xline(0.20)
xline(0.50)

%% Spectral correlation - just CO

THRESHOLD_CORRELATION_LOW_MIN = -0.1;
THRESHOLD_CORRELATION_LOW_MAX = 0.1;
THRESHOLD_CORRELATION_MED_MIN = 0.2;
THRESHOLD_CORRELATION_MED_MAX = 0.4;
THRESHOLD_CORRELATION_HIGH_MIN = 0.5;
THRESHOLD_CORRELATION_HIGH_MAX = 0.65;


figure
hold on
scatter(mean_max_primary_corr_cb_cont_hinder,av_occupancy_subits, marker_size,'o')
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
ylabel('mean occupancy $\bar{o}_B$','Interpreter','latex')
grid on
ylim([0 0.5])
xlim([-0.15 0.65])
xline(THRESHOLD_CORRELATION_LOW_MIN)
xline(THRESHOLD_CORRELATION_LOW_MAX)
xline(THRESHOLD_CORRELATION_MED_MIN)
xline(THRESHOLD_CORRELATION_MED_MAX)
xline(THRESHOLD_CORRELATION_HIGH_MIN)
xline(THRESHOLD_CORRELATION_HIGH_MAX)


rectangle('Position', [-0.1 -0.2 0.2 0.8], 'FaceColor', [0 1 0 0.1])
set(gca,'children',flipud(get(gca,'children')))

rectangle('Position', [0.2 -0.2 0.2 0.8], 'FaceColor', [1 1 0 0.12])
set(gca,'children',flipud(get(gca,'children')))

rectangle('Position', [0.5 -0.2 0.15 0.8], 'FaceColor', [1 0 0 0.07])
set(gca,'children',flipud(get(gca,'children')))

% empirical CDF correlation
[f,x] = ecdf(mean_max_primary_corr_cb_cont_hinder);

yyaxis right
plot(x,f)

figure
plot(x,f)
xlabel('Best-primary correlation $\xi^*$', 'Interpreter','latex')
ylabel('Empirical CDF','Interpreter','latex')
grid on


prob_correl_low = length(mean_max_primary_corr_cb_cont_hinder(find(mean_max_primary_corr_cb_cont_hinder<THRESHOLD_CORRELATION_LOW_MAX))) / ...
    length(mean_max_primary_corr_cb_cont_hinder);

prob_correl_med = length(mean_max_primary_corr_cb_cont_hinder(find(mean_max_primary_corr_cb_cont_hinder>THRESHOLD_CORRELATION_MED_MIN))) / ...
    length(mean_max_primary_corr_cb_cont_hinder);

prob_correl_high = length(mean_max_primary_corr_cb_cont_hinder(find(mean_max_primary_corr_cb_cont_hinder>THRESHOLD_CORRELATION_HIGH_MIN))) / ...
    length(mean_max_primary_corr_cb_cont_hinder);

%%

% Fix occupancy and temporal change freq.
ix_occ_low_temporal_low =  find(av_temporal_change_freq_subits(ix_occ_low) < THRESHOLD_TEMP_FREQ_LOW);
ix_occ_low_temporal_med =  ...
    find((av_temporal_change_freq_subits(ix_occ_low) >= THRESHOLD_TEMP_FREQ_LOW &...
    av_temporal_change_freq_subits(ix_occ_low) < THRESHOLD_TEMP_FREQ_MED));
ix_occ_low_temporal_high =  find(av_temporal_change_freq_subits(ix_occ_low) > THRESHOLD_TEMP_FREQ_MED);

ix_occ_med_temporal_low =  find(av_temporal_change_freq_subits(ix_occ_med) < THRESHOLD_TEMP_FREQ_LOW);
ix_occ_med_temporal_med =  ...
    find((av_temporal_change_freq_subits(ix_occ_med) >= THRESHOLD_TEMP_FREQ_LOW &...
    av_temporal_change_freq_subits(ix_occ_med) < THRESHOLD_TEMP_FREQ_MED));
ix_occ_med_temporal_high =  find(av_temporal_change_freq_subits(ix_occ_med) > THRESHOLD_TEMP_FREQ_MED);

ix_occ_high_temporal_low =  find(av_temporal_change_freq_subits(ix_occ_high) < THRESHOLD_TEMP_FREQ_LOW);
ix_occ_high_temporal_med =  ...
    find((av_temporal_change_freq_subits(ix_occ_high) >= THRESHOLD_TEMP_FREQ_LOW &...
    av_temporal_change_freq_subits(ix_occ_high) < THRESHOLD_TEMP_FREQ_MED));
ix_occ_high_temporal_high =  find(av_temporal_change_freq_subits(ix_occ_high) > THRESHOLD_TEMP_FREQ_MED);


%% Averaging per X-ranges in spectral change freq
max_spectral_change_freq = 0.3;
num_intervals_spectral_change_freq = 6;
delta_intervals_spectral_change_freq = max_spectral_change_freq / num_intervals_spectral_change_freq;

% - OCC low
% -- TEMP low
x_array = av_spectral_change_freq_subits(ix_occ_low(ix_occ_low_temporal_low));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_low(ix_occ_low_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_low_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_low(ix_occ_low_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_low(ix_occ_low_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
% -- TEMP med
x_array = av_spectral_change_freq_subits(ix_occ_low(ix_occ_low_temporal_med));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_low(ix_occ_low_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_low_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_low(ix_occ_low_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_low(ix_occ_low_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
% -- TEMP high
x_array = av_spectral_change_freq_subits(ix_occ_low(ix_occ_low_temporal_high));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_low(ix_occ_low_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_low_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_low(ix_occ_low_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_low(ix_occ_low_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);

% - OCC med
% -- TEMP low
x_array = av_spectral_change_freq_subits(ix_occ_med(ix_occ_med_temporal_low));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_med(ix_occ_med_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_med_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_med(ix_occ_med_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_med(ix_occ_med_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);

% -- TEMP med
x_array = av_spectral_change_freq_subits(ix_occ_med(ix_occ_med_temporal_med));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_med(ix_occ_med_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_med_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_med(ix_occ_med_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_med(ix_occ_med_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
% -- TEMP high
x_array = av_spectral_change_freq_subits(ix_occ_med(ix_occ_med_temporal_high));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_med(ix_occ_med_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_med_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_med(ix_occ_med_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_med(ix_occ_med_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);

% - OCC high
% -- TEMP low
x_array = av_spectral_change_freq_subits(ix_occ_high(ix_occ_high_temporal_low));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_high(ix_occ_high_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_high_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_high(ix_occ_high_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_high(ix_occ_high_temporal_low));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_low = ...
    get_average_per_x_ranges(y_array, ix_per_interval);

% -- TEMP med
x_array = av_spectral_change_freq_subits(ix_occ_high(ix_occ_high_temporal_med));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_high(ix_occ_high_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_high_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_high(ix_occ_high_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_high(ix_occ_high_temporal_med));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_med = ...
    get_average_per_x_ranges(y_array, ix_per_interval);

% -- TEMP high
x_array = av_spectral_change_freq_subits(ix_occ_high(ix_occ_high_temporal_high));
[ix_per_interval,~,sort_ixs] = ...
    sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
y_array = max_throughput_sc_hinder_subits(ix_occ_high(ix_occ_high_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_sc_hinder_sorted_occ_high_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_cont_hinder_subits(ix_occ_high(ix_occ_high_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);
y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_high(ix_occ_high_temporal_high));
y_array = y_array(sort_ixs);
ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_high = ...
    get_average_per_x_ranges(y_array, ix_per_interval);

% figure
% subplot(1,3,1)
% hold on
% plot(ranged_max_thr_sc_hinder_sorted_occ_low_temp_low, '-o','markeredgecolor','k')
% plot(ranged_max_thr_sc_hinder_sorted_occ_low_temp_med, '-o','markeredgecolor','k')
% plot(ranged_max_thr_sc_hinder_sorted_occ_low_temp_high, '-o','markeredgecolor','k')
% plot(ranged_max_thr_sc_hinder_sorted_occ_med_temp_low, '-x','markeredgecolor','k')
% plot(ranged_max_thr_sc_hinder_sorted_occ_med_temp_med, '-x','markeredgecolor','c')
% plot(ranged_max_thr_sc_hinder_sorted_occ_med_temp_high, '-x','markeredgecolor','r')
% plot(ranged_max_thr_sc_hinder_sorted_occ_high_temp_low, '-s','markeredgecolor','k')
% plot(ranged_max_thr_sc_hinder_sorted_occ_high_temp_med, '-s','markeredgecolor','c')
% plot(ranged_max_thr_sc_hinder_sorted_occ_high_temp_high, '-s','markeredgecolor','r')
% grid on
% title('SC')
% xlabel('Spectral freq.')
% ylabel(['Av. Max throughput [Mbps]'])
% ylim([0 700])
% xlim([0.5 num_intervals_spectral_change_freq])
% xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)
% legend(['occ < ' num2str(THRESHOLD_OCC_LOW) ' AND temp <  ' num2str(THRESHOLD_TEMP_FREQ_LOW)],...
%     ['occ < ' num2str(THRESHOLD_OCC_LOW) ' AND (' num2str(THRESHOLD_TEMP_FREQ_LOW) ' < temp <  ' num2str(THRESHOLD_TEMP_FREQ_MED) ')'],...
%     ['occ < ' num2str(THRESHOLD_OCC_LOW) ' AND temp >  ' num2str(THRESHOLD_TEMP_FREQ_MED)],...
%     ['(' num2str(THRESHOLD_OCC_LOW) '< occ < ' num2str(THRESHOLD_OCC_MED) ') AND temp <  ' num2str(THRESHOLD_TEMP_FREQ_LOW)],...
%     ['(' num2str(THRESHOLD_OCC_LOW) '< occ < ' num2str(THRESHOLD_OCC_MED) ') AND (' num2str(THRESHOLD_TEMP_FREQ_LOW) ' < temp <  ' num2str(THRESHOLD_TEMP_FREQ_MED)],...
%     ['(' num2str(THRESHOLD_OCC_LOW) '< occ < ' num2str(THRESHOLD_OCC_MED) ') AND temp >  ' num2str(THRESHOLD_TEMP_FREQ_MED)],...
%     ['occ > ' num2str(THRESHOLD_OCC_MED) ' AND temp <  ' num2str(THRESHOLD_TEMP_FREQ_LOW)],...
%     ['occ > ' num2str(THRESHOLD_OCC_MED) ' AND (' num2str(THRESHOLD_TEMP_FREQ_LOW) ' < temp <  ' num2str(THRESHOLD_TEMP_FREQ_MED) ')'],...
%     ['occ > ' num2str(THRESHOLD_OCC_MED) ' AND temp >  ' num2str(THRESHOLD_TEMP_FREQ_MED)])
%
% subplot(1,3,2)
% hold on
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_low, '-o','markeredgecolor','k')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_med, '-o','markeredgecolor','c')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_high, '-o','markeredgecolor','r')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_low, '-x','markeredgecolor','k')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_med, '-x','markeredgecolor','c')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_high, '-x','markeredgecolor','r')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_low, '-s','markeredgecolor','k')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_med, '-s','markeredgecolor','c')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_high, '-s','markeredgecolor','r')
% grid on
% title('CB-cont')
% xlabel('Spectral freq.')
% ylabel(['Av. Max throughput [Mbps]'])
% ylim([0 700])
% xlim([0.5 num_intervals_spectral_change_freq])
% xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)
%
%
% subplot(1,3,3)
% hold on
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_low, '-o','markeredgecolor','k')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_med, '-o','markeredgecolor','c')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_high, '-o','markeredgecolor','r')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_low, '-x','markeredgecolor','k')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_med, '-x','markeredgecolor','c')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_high, '-x','markeredgecolor','r')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_low, '-s','markeredgecolor','k')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_med, '-s','markeredgecolor','c')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_high, '-s','markeredgecolor','r')
% grid on
% title('CB-non-cont')
% xlabel('Spectral freq.')
% ylabel(['Av. Max throughput [Mbps]'])
% ylim([0 700])
% xlim([0.5 num_intervals_spectral_change_freq])
% xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)

figure
subplot(1,3,1)
hold on
plot(ranged_max_thr_sc_hinder_sorted_occ_low_temp_low, 'k-x','markeredgecolor','k')
plot(ranged_max_thr_sc_hinder_sorted_occ_low_temp_high, 'k--x','markeredgecolor','k')
plot(ranged_max_thr_sc_hinder_sorted_occ_med_temp_low, 'c-x','markeredgecolor','c')
plot(ranged_max_thr_sc_hinder_sorted_occ_med_temp_high, 'c--x','markeredgecolor','c')
plot(ranged_max_thr_sc_hinder_sorted_occ_high_temp_low, 'r-x','markeredgecolor','r')
plot(ranged_max_thr_sc_hinder_sorted_occ_high_temp_high, 'r--x','markeredgecolor','r')
grid on
title('SC')
xlabel('Spectral freq.')
ylabel(['Av. Max throughput [Mbps]'])
ylim([0 700])
xlim([0.5 num_intervals_spectral_change_freq])
xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)
% legend(['occ < ' num2str(THRESHOLD_OCC_LOW) ' AND temp <  ' num2str(THRESHOLD_TEMP_FREQ_LOW)],...
%     ['occ < ' num2str(THRESHOLD_OCC_LOW) ' AND temp >  ' num2str(THRESHOLD_TEMP_FREQ_MED)],...
%     ['(' num2str(THRESHOLD_OCC_LOW) '< occ < ' num2str(THRESHOLD_OCC_MED) ') AND temp <  ' num2str(THRESHOLD_TEMP_FREQ_LOW)],...
%     ['(' num2str(THRESHOLD_OCC_LOW) '< occ < ' num2str(THRESHOLD_OCC_MED) ') AND temp >  ' num2str(THRESHOLD_TEMP_FREQ_MED)],...
%     ['occ > ' num2str(THRESHOLD_OCC_MED) ' AND temp <  ' num2str(THRESHOLD_TEMP_FREQ_LOW)],...
%     ['occ > ' num2str(THRESHOLD_OCC_MED) ' AND temp >  ' num2str(THRESHOLD_TEMP_FREQ_MED)])

legend('Low $\bar{o}$ \& low $\bar{\tau}$',...
    'Low $\bar{o}$ \& high $\bar{\tau}$',...
    'Med $\bar{o}$ \& low $\bar{\tau}$',...
    'Med $\bar{o}$ \& high $\bar{\tau}$',...
    'High $\bar{o}$ \& low $\bar{\tau}$',...
    'High $\bar{o}$ \& high $\bar{\tau}$')

subplot(1,3,2)
hold on
plot(ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_low, 'k-x','markeredgecolor','k')
plot(ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_high, 'k--x','markeredgecolor','k')
plot(ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_low, 'c-x','markeredgecolor','c')
plot(ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_high, 'c--x','markeredgecolor','c')
plot(ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_low, 'r-x','markeredgecolor','r')
plot(ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_high, 'r--x','markeredgecolor','r')
grid on
title('CB-cont')
xlabel('Spectral freq.')
ylabel(['Av. Max throughput [Mbps]'])
ylim([0 700])
xlim([0.5 num_intervals_spectral_change_freq])
xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)


subplot(1,3,3)
hold on
plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_low, 'k-x','markeredgecolor','k')
plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_high, 'k--x','markeredgecolor','k')
plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_low, 'c-x','markeredgecolor','c')
plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_high, 'c--x','markeredgecolor','c')
plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_low, 'r-x','markeredgecolor','r')
plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_high, 'r--x','markeredgecolor','r')
grid on
title('CB-non-cont')
xlabel('Spectral freq.')
ylabel(['Av. Max throughput [Mbps]'])
ylim([0 700])
xlim([0.5 num_intervals_spectral_change_freq])
xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)

%% Averaging per X-ranges in spectral change freq FOR JUST BEST-PRIMARY
% max_spectral_change_freq = 0.3;
% num_intervals_spectral_change_freq = 6;
% delta_intervals_spectral_change_freq = max_spectral_change_freq / num_intervals_spectral_change_freq;
%
% THRESHOLD_TEMP_FREQ_LOW = 0.1036;
% THRESHOLD_TEMP_FREQ_MED = 0.1036;
%
% ix_occ_low_temporal_low =  find(max_primary_temporal_sparsity_subits(ix_occ_low) < THRESHOLD_TEMP_FREQ_LOW);
% ix_occ_low_temporal_high =  find(max_primary_temporal_sparsity_subits(ix_occ_low) > THRESHOLD_TEMP_FREQ_MED);
%
% ix_occ_med_temporal_low =  find(max_primary_temporal_sparsity_subits(ix_occ_med) < THRESHOLD_TEMP_FREQ_LOW);
% ix_occ_med_temporal_high =  find(max_primary_temporal_sparsity_subits(ix_occ_med) > THRESHOLD_TEMP_FREQ_MED);
%
% ix_occ_high_temporal_low =  find(max_primary_temporal_sparsity_subits(ix_occ_high) < THRESHOLD_TEMP_FREQ_LOW);
% ix_occ_high_temporal_high =  find(max_primary_temporal_sparsity_subits(ix_occ_high) > THRESHOLD_TEMP_FREQ_MED);
%
% % - OCC low
% % -- TEMP low
% x_array = av_spectral_change_freq_subits(ix_occ_low(ix_occ_low_temporal_low));
% [ix_per_interval,~,sort_ixs] = ...
%     sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
% y_array = max_throughput_sc_hinder_subits(ix_occ_low(ix_occ_low_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_sc_hinder_sorted_occ_low_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_cont_hinder_subits(ix_occ_low(ix_occ_low_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_low(ix_occ_low_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
%
% % -- TEMP high
% x_array = av_spectral_change_freq_subits(ix_occ_low(ix_occ_low_temporal_high));
% [ix_per_interval,~,sort_ixs] = ...
%     sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
% y_array = max_throughput_sc_hinder_subits(ix_occ_low(ix_occ_low_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_sc_hinder_sorted_occ_low_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_cont_hinder_subits(ix_occ_low(ix_occ_low_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_low(ix_occ_low_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
%
% % - OCC med
% % -- TEMP low
% x_array = av_spectral_change_freq_subits(ix_occ_med(ix_occ_med_temporal_low));
% [ix_per_interval,~,sort_ixs] = ...
%     sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
% y_array = max_throughput_sc_hinder_subits(ix_occ_med(ix_occ_med_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_sc_hinder_sorted_occ_med_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_cont_hinder_subits(ix_occ_med(ix_occ_med_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_med(ix_occ_med_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
%
% % -- TEMP high
% x_array = av_spectral_change_freq_subits(ix_occ_med(ix_occ_med_temporal_high));
% [ix_per_interval,~,sort_ixs] = ...
%     sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
% y_array = max_throughput_sc_hinder_subits(ix_occ_med(ix_occ_med_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_sc_hinder_sorted_occ_med_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_cont_hinder_subits(ix_occ_med(ix_occ_med_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_med(ix_occ_med_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
%
% % - OCC high
% % -- TEMP low
% x_array = av_spectral_change_freq_subits(ix_occ_high(ix_occ_high_temporal_low));
% [ix_per_interval,~,sort_ixs] = ...
%     sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
% y_array = max_throughput_sc_hinder_subits(ix_occ_high(ix_occ_high_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_sc_hinder_sorted_occ_high_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_cont_hinder_subits(ix_occ_high(ix_occ_high_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_high(ix_occ_high_temporal_low));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_low = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
%
% % -- TEMP high
% x_array = av_spectral_change_freq_subits(ix_occ_high(ix_occ_high_temporal_high));
% [ix_per_interval,~,sort_ixs] = ...
%     sort_per_x_ranges(x_array, num_intervals_spectral_change_freq, delta_intervals_spectral_change_freq);
% y_array = max_throughput_sc_hinder_subits(ix_occ_high(ix_occ_high_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_sc_hinder_sorted_occ_high_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_cont_hinder_subits(ix_occ_high(ix_occ_high_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
% y_array = max_throughput_cb_noncont_hinder_subits(ix_occ_high(ix_occ_high_temporal_high));
% y_array = y_array(sort_ixs);
% ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_high = ...
%     get_average_per_x_ranges(y_array, ix_per_interval);
%
% figure
% subplot(1,2,1)
% hold on
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_low, 'k-x','markeredgecolor','k')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_low_temp_high, 'k--*','markeredgecolor','k')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_low, 'b-x','markeredgecolor','b')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_med_temp_high, 'b--*','markeredgecolor','b')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_low, 'r-x','markeredgecolor','r')
% plot(ranged_max_thr_cb_cont_hinder_sorted_occ_high_temp_high, 'r--*','markeredgecolor','r')
% grid on
% title('CB-cont')
% xlabel('Norm. spectral sparsity')
% ylabel(['Mean best-primary throughput [Mbps]'])
% ylim([0 700])
% xlim([0.5 num_intervals_spectral_change_freq])
% xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)
% legend('Low $\bar{o}$ \& low $\bar{\tau}^*$',...
%     'Low $\bar{o}$ \& high $\bar{\tau}^*$',...
%     'Med $\bar{o}$ \& low $\bar{\tau}^*$',...
%     'Med $\bar{o}$ \& high $\bar{\tau}^*$',...
%     'High $\bar{o}$ \& low $\bar{\tau}^*$',...
%     'High $\bar{o}$ \& high $\bar{\tau}^*$')
%
% subplot(1,2,2)
% hold on
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_low, 'k-x','markeredgecolor','k')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_low_temp_high, 'k--*','markeredgecolor','k')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_low, 'b-x','markeredgecolor','b')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_med_temp_high, 'b--*','markeredgecolor','b')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_low, 'r-x','markeredgecolor','r')
% plot(ranged_max_thr_cb_noncont_hinder_sorted_occ_high_temp_high, 'r--*','markeredgecolor','r')
% grid on
% title('CB-non-cont')
% xlabel('Norm. spectral sparsity')
% ylim([0 700])
% xlim([0.5 num_intervals_spectral_change_freq])
% xticklabels(((1:num_intervals_spectral_change_freq)-0.5)*delta_intervals_spectral_change_freq)



%%
% - Boxplot normalized best throughput in occupancy groups HINDER
figure
subplot(1,5,1)
x1 = max_throughput_cb_cont_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_cb_cont_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x3 = max_throughput_cb_cont_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
ylabel('Throughput [Mbps]')
xlabel('Mean occupancy at 160 MHz')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,2)
x1 = max_throughput_cb_noncont_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_cb_noncont_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x3 = max_throughput_cb_noncont_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-non-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,3)
x1 = max_throughput_scb_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_scb_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x3 = max_throughput_scb_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,4)
x1 = max_throughput_dcb_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_dcb_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x3 = max_throughput_dcb_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('DCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,5)
x1 = max_throughput_pp_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_pp_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x3 = max_throughput_pp_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('PP')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

mean_max_cb_noncont_low = mean(max_throughput_cb_noncont_hinder_subits(ix_occ_low));
mean_max_cb_noncont_med = mean(max_throughput_cb_noncont_hinder_subits(ix_occ_med));
mean_max_cb_noncont_high = mean(max_throughput_cb_noncont_hinder_subits(ix_occ_high));

mean_max_pp_low = mean(max_throughput_pp_hinder_subits(ix_occ_low));
mean_max_pp_med = mean(max_throughput_pp_hinder_subits(ix_occ_med));
mean_max_pp_high = mean(max_throughput_pp_hinder_subits(ix_occ_high));

%%
% - Bar chart throughput normalized SCB and DCB vs CB-cont, and PP vs CB-non-cont in occupancy groups HINDER

THRESHOLD_OCC_LOW = 0.1;
THRESHOLD_OCC_MED = 0.2;
ix_occ_low = find(av_occupancy_subits < THRESHOLD_OCC_LOW);
ix_occ_med = find((av_occupancy_subits >= THRESHOLD_OCC_LOW & av_occupancy_subits < THRESHOLD_OCC_MED));
ix_occ_high = find(av_occupancy_subits > THRESHOLD_OCC_MED);

figure

ratio_scb_co_low = max_throughput_scb_hinder_subits(ix_occ_low)./max_throughput_cb_cont_hinder_subits(ix_occ_low);
ratio_scb_co_med = max_throughput_scb_hinder_subits(ix_occ_med)./max_throughput_cb_cont_hinder_subits(ix_occ_med);
ratio_scb_co_high = max_throughput_scb_hinder_subits(ix_occ_high)./max_throughput_cb_cont_hinder_subits(ix_occ_high);

% Low, Low-Mid, ... High
ratio_scb_co = [mean(ratio_scb_co_low)...
    mean(ratio_scb_co_med)...
    mean(ratio_scb_co_high)];

ratio_dcb_co_low = max_throughput_dcb_hinder_subits(ix_occ_low)./max_throughput_cb_cont_hinder_subits(ix_occ_low);
ratio_dcb_co_med = max_throughput_dcb_hinder_subits(ix_occ_med)./max_throughput_cb_cont_hinder_subits(ix_occ_med);
ratio_dcb_co_high = max_throughput_dcb_hinder_subits(ix_occ_high)./max_throughput_cb_cont_hinder_subits(ix_occ_high);

ratio_dcb_co = [mean(ratio_dcb_co_low)...
    mean(ratio_dcb_co_med)...
    mean(ratio_dcb_co_high)];

ratio_pp_nc_low = max_throughput_pp_hinder_subits(ix_occ_low)./max_throughput_cb_noncont_hinder_subits(ix_occ_low);
ratio_pp_nc_med = max_throughput_pp_hinder_subits(ix_occ_med)./max_throughput_cb_noncont_hinder_subits(ix_occ_med);
ratio_pp_nc_high = max_throughput_pp_hinder_subits(ix_occ_high)./max_throughput_cb_noncont_hinder_subits(ix_occ_high);

ratio_pp_nc = [mean(ratio_pp_nc_low)...
    mean(ratio_pp_nc_med)...
    mean(ratio_pp_nc_high)];

fprintf('Mean\n')
fprintf('- SC/CO: low = %.2f - med = %.2f - high = %.2f\n', ...
        ratio_scb_co(1), ratio_scb_co(2), ratio_scb_co(3))
fprintf('- DCB/CO: low = %.2f - med = %.2f - high = %.2f\n', ...
    ratio_dcb_co(1), ratio_dcb_co(2), ratio_dcb_co(3))
fprintf('- PP/NC: low = %.2f - med = %.2f - high = %.2f\n', ...
    ratio_pp_nc(1), ratio_pp_nc(2), ratio_pp_nc(3))

% Percentile
PERCENTILE_MIN = 1;
fprintf('PERCENTILE %d %%\n', PERCENTILE_MIN)
fprintf('- SC/CO: low = %.2f - med = %.2f - high = %.2f\n', ...
        prctile(ratio_scb_co_low,PERCENTILE_MIN), prctile(ratio_scb_co_med,PERCENTILE_MIN), prctile(ratio_scb_co_high,PERCENTILE_MIN))
fprintf('- DCB/CO: low = %.2f - med = %.2f - high = %.2f\n', ...
    prctile(ratio_dcb_co_low,PERCENTILE_MIN), prctile(ratio_dcb_co_med,PERCENTILE_MIN), prctile(ratio_dcb_co_high,PERCENTILE_MIN))
fprintf('- PP/NC: low = %.2f - med = %.2f - high = %.2f\n', ...
    prctile(ratio_pp_nc_low,PERCENTILE_MIN), prctile(ratio_pp_nc_med,PERCENTILE_MIN), prctile(ratio_pp_nc_high,PERCENTILE_MIN))

figure
y = [ratio_scb_co; ratio_dcb_co; ratio_pp_nc];
bar(y)
ylabel('Throughput ratio', 'interpreter', 'latex')
set(gca,'XTickLabel',{'SCB/Cont', 'DCB/Cont', 'PP/Non-cont'});
grid on

legend('Low','Med','High')

%%
% - Boxplot normalized best throughput in occupancy groups HIDDEN

figure
subplot(1,5,1)
x1 = max_throughput_cb_cont_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low);
x2 = max_throughput_cb_cont_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med);
x3 = max_throughput_cb_cont_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
ylabel('Throughput [Mbps]')
xlabel('Mean occupancy at 160 MHz')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,2)
x1 = max_throughput_cb_noncont_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low);
x2 = max_throughput_cb_noncont_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med);
x3 = max_throughput_cb_noncont_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-non-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,3)
x1 = max_throughput_scb_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low);
x2 = max_throughput_scb_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med);
x3 = max_throughput_scb_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,4)
x1 = max_throughput_dcb_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low);
x2 = max_throughput_dcb_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med);
x3 = max_throughput_dcb_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('DCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,5)
x1 = max_throughput_pp_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low);
x2 = max_throughput_pp_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med);
x3 = max_throughput_pp_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('PP')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

%%
% - Boxplot normalized best throughput in occupancy groups HIDDEN - Just
% universal

THRESHOLD_OCC_LOW = 0.1;
THRESHOLD_OCC_MED = 0.2;
ix_occ_low = find(av_occupancy_subits < THRESHOLD_OCC_LOW);
ix_occ_med = find((av_occupancy_subits >= THRESHOLD_OCC_LOW & av_occupancy_subits < THRESHOLD_OCC_MED));
ix_occ_high = find(av_occupancy_subits > THRESHOLD_OCC_MED);

figure
subplot(1,2,1)
x1 = max_throughput_cb_cont_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low);
x2 = max_throughput_cb_cont_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med);
x3 = max_throughput_cb_cont_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

prob_sc_high_cb_cont_low = length(x1(x1<=1)) / length(x1);
prob_sc_high_cb_cont_med = length(x2(x2<=1)) / length(x2);
prob_sc_high_cb_cont_high = length(x3(x3<=1)) / length(x3);

fprintf('Prob SC greater than CO: low = %.2f - med = %.2f - high = %.2f\n',...
    prob_sc_high_cb_cont_low, prob_sc_high_cb_cont_med, prob_sc_high_cb_cont_high)

subplot(1,2,2)
x1 = max_throughput_cb_noncont_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low);
x2 = max_throughput_cb_noncont_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med);
x3 = max_throughput_cb_noncont_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-non-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')

prob_sc_high_cb_cont_low = length(x1(x1<=1)) / length(x1);
prob_sc_high_cb_cont_med = length(x2(x2<=1)) / length(x2);
prob_sc_high_cb_cont_high = length(x3(x3<=1)) / length(x3);

fprintf('Prob SC greater than NC: low = %.2f - med = %.2f - high = %.2f\n',...
    prob_sc_high_cb_cont_low, prob_sc_high_cb_cont_med, prob_sc_high_cb_cont_high)

% Throughput per occupancy hinder
figure
subplot(1,2,1)
x1 = max_throughput_cb_cont_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_cb_cont_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x3 = max_throughput_cb_cont_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CO')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

prob_sc_high_cb_cont_low = length(x1(x1<=1)) / length(x1);
prob_sc_high_cb_cont_med = length(x2(x2<=1)) / length(x2);
prob_sc_high_cb_cont_high = length(x3(x3<=1)) / length(x3);

fprintf('Prob SC greater than CO: low = %.2f - med = %.2f - high = %.2f\n',...
    prob_sc_high_cb_cont_low, prob_sc_high_cb_cont_med, prob_sc_high_cb_cont_high)

subplot(1,2,2)
x1 = max_throughput_cb_noncont_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_cb_noncont_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x3 = max_throughput_cb_noncont_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
xticklabels({'Low', 'Med', 'High'})
grid on
title('NC')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')


%%
% - Boxplot normalized best throughput in occupancy groups HINDER AND HIDDEN - Just
% universal

THRESHOLD_OCC_LOW_MIN = 0.05;
THRESHOLD_OCC_LOW_MAX = 0.10;
THRESHOLD_OCC_MED_MIN = 0.20;
THRESHOLD_OCC_MED_MAX = 0.30;
THRESHOLD_OCC_HIGH_MIN = 0.40;
THRESHOLD_OCC_HIGH_MAX = 0.50;
THRESHOLD_OCC_HIGH_MAX_2 = 0.60;
THRESHOLD_OCC_HIGH_MAX_3 = 0.70;
THRESHOLD_OCC_HIGH_MAX_4 = 0.80;
THRESHOLD_OCC_HIGH_MAX_5 = 0.90;
THRESHOLD_OCC_HIGH_MAX_6 = 1.00;

ix_occ_low = find(av_occupancy_subits >= THRESHOLD_OCC_LOW_MIN & av_occupancy_subits < THRESHOLD_OCC_LOW_MAX);
ix_occ_btw_low_med = find(av_occupancy_subits >= THRESHOLD_OCC_LOW_MAX & av_occupancy_subits < THRESHOLD_OCC_MED_MIN);
ix_occ_med = find(av_occupancy_subits >= THRESHOLD_OCC_MED_MIN & av_occupancy_subits < THRESHOLD_OCC_MED_MAX);
ix_occ_btw_med_high = find(av_occupancy_subits >= THRESHOLD_OCC_MED_MAX & av_occupancy_subits < THRESHOLD_OCC_HIGH_MIN);
ix_occ_high = find(av_occupancy_subits >= THRESHOLD_OCC_HIGH_MIN & av_occupancy_subits < THRESHOLD_OCC_HIGH_MAX);
ix_occ_high_2 = find(av_occupancy_subits >= THRESHOLD_OCC_HIGH_MAX & av_occupancy_subits < THRESHOLD_OCC_HIGH_MAX_2);
ix_occ_high_3 = find(av_occupancy_subits >= THRESHOLD_OCC_HIGH_MAX_2 & av_occupancy_subits < THRESHOLD_OCC_HIGH_MAX_3);
ix_occ_high_4 = find(av_occupancy_subits >= THRESHOLD_OCC_HIGH_MAX_3 & av_occupancy_subits < THRESHOLD_OCC_HIGH_MAX_4);
ix_occ_high_5 = find(av_occupancy_subits >= THRESHOLD_OCC_HIGH_MAX_4 & av_occupancy_subits < THRESHOLD_OCC_HIGH_MAX_5);
ix_occ_high_6 = find(av_occupancy_subits >= THRESHOLD_OCC_HIGH_MAX_5 & av_occupancy_subits < THRESHOLD_OCC_HIGH_MAX_6);

figure
subplot(1,2,1)
x1 = max_throughput_cb_cont_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_cb_cont_hinder_subits(ix_occ_btw_low_med)./max_throughput_sc_hinder_subits(ix_occ_btw_low_med);
x3 = max_throughput_cb_cont_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x4 = max_throughput_cb_cont_hinder_subits(ix_occ_btw_med_high)./max_throughput_sc_hinder_subits(ix_occ_btw_med_high);
x5 = max_throughput_cb_cont_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x6 = max_throughput_cb_cont_hinder_subits(ix_occ_high_2)./max_throughput_sc_hinder_subits(ix_occ_high_2);
x7 = max_throughput_cb_cont_hinder_subits(ix_occ_high_3)./max_throughput_sc_hinder_subits(ix_occ_high_3);
x8 = max_throughput_cb_cont_hinder_subits(ix_occ_high_4)./max_throughput_sc_hinder_subits(ix_occ_high_4);
x9 = max_throughput_cb_cont_hinder_subits(ix_occ_high_5)./max_throughput_sc_hinder_subits(ix_occ_high_5);
x10 = max_throughput_cb_cont_hinder_subits(ix_occ_high_6)./max_throughput_sc_hinder_subits(ix_occ_high_6);
x = [x1; x2; x3; x4; x5; x6; x7; x8; x9; x10];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1);...
     5*ones(length(x6), 1); 6*ones(length(x7), 1); 7*ones(length(x8), 1); 8*ones(length(x9), 1); 9*ones(length(x10), 1)];
boxplot(x, g)
ylim([0 6.5])
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
xticklabels({'10', '', '30', '', '50', '', '70', '', '90', '', '100'})
grid on
title('CO')
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)...
    mean(x6) mean(x7) mean(x8) mean(x9) mean(x10)];
plot(y_mean);

subplot(1,2,2)
x1 = max_throughput_cb_noncont_hinder_subits(ix_occ_low)./max_throughput_sc_hinder_subits(ix_occ_low);
x2 = max_throughput_cb_noncont_hinder_subits(ix_occ_btw_low_med)./max_throughput_sc_hinder_subits(ix_occ_btw_low_med);
x3 = max_throughput_cb_noncont_hinder_subits(ix_occ_med)./max_throughput_sc_hinder_subits(ix_occ_med);
x4 = max_throughput_cb_noncont_hinder_subits(ix_occ_btw_med_high)./max_throughput_sc_hinder_subits(ix_occ_btw_med_high);
x5 = max_throughput_cb_noncont_hinder_subits(ix_occ_high)./max_throughput_sc_hinder_subits(ix_occ_high);
x6 = max_throughput_cb_noncont_hinder_subits(ix_occ_high_2)./max_throughput_sc_hinder_subits(ix_occ_high_2);
x7 = max_throughput_cb_noncont_hinder_subits(ix_occ_high_3)./max_throughput_sc_hinder_subits(ix_occ_high_3);
x8 = max_throughput_cb_noncont_hinder_subits(ix_occ_high_4)./max_throughput_sc_hinder_subits(ix_occ_high_4);
x9 = max_throughput_cb_noncont_hinder_subits(ix_occ_high_5)./max_throughput_sc_hinder_subits(ix_occ_high_5);
x10 = max_throughput_cb_noncont_hinder_subits(ix_occ_high_6)./max_throughput_sc_hinder_subits(ix_occ_high_6);
x = [x1; x2; x3; x4; x5; x6; x7; x8; x9; x10];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1);...
     5*ones(length(x6), 1); 6*ones(length(x7), 1); 7*ones(length(x8), 1); 8*ones(length(x9), 1); 9*ones(length(x10), 1)];
boxplot(x, g)
ylim([0 6.5])
xticklabels({'10', '', '30', '', '50', '', '70', '', '90', '', '100'})
grid on
title('CN')
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)...
    mean(x6) mean(x7) mean(x8) mean(x9) mean(x10)];
plot(y_mean);

figure
subplot(1,2,1)
x1 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low));
x2 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_btw_low_med)./max_throughput_sc_hidden_subits(ix_occ_btw_low_med));
x3 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med));
x4 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_btw_med_high)./max_throughput_sc_hidden_subits(ix_occ_btw_med_high));
x5 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high));
x6 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_high_2)./max_throughput_sc_hidden_subits(ix_occ_high_2));
x7 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_high_3)./max_throughput_sc_hidden_subits(ix_occ_high_3));
x8 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_high_4)./max_throughput_sc_hidden_subits(ix_occ_high_4));
x9 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_high_5)./max_throughput_sc_hidden_subits(ix_occ_high_5));
x10 = rmmissing(max_throughput_cb_cont_hidden_subits(ix_occ_high_6)./max_throughput_sc_hidden_subits(ix_occ_high_6));
x = [x1; x2; x3; x4; x5; x6; x7; x8; x9; x10];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1);...
     5*ones(length(x6), 1); 6*ones(length(x7), 1); 7*ones(length(x8), 1); 8*ones(length(x9), 1); 9*ones(length(x10), 1)];
boxplot(x, g)
ylim([0 6.5])
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
xticklabels({'10', '', '30', '', '50', '', '70', '', '90', '', '100'})
grid on
title('CO')
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))



prob_sc_high_cb_cont_1 = length(x1(x1<=1)) / length(x1);
prob_sc_high_cb_cont_2 = length(x2(x2<=1)) / length(x2);
prob_sc_high_cb_cont_3 = length(x3(x3<=1)) / length(x3);
prob_sc_high_cb_cont_4 = length(x4(x4<=1)) / length(x4);
prob_sc_high_cb_cont_5 = length(x5(x5<=1)) / length(x5);
prob_sc_high_cb_cont_6 = length(x6(x6<=1)) / length(x6);
prob_sc_high_cb_cont_7 = length(x7(x7<=1)) / length(x7);
prob_sc_high_cb_cont_8 = length(x8(x8<=1)) / length(x8);
prob_sc_high_cb_cont_9 = length(x9(x9<=1)) / length(x9);
prob_sc_high_cb_cont_10 = length(x10(x10<=1)) / length(x10);

prob_cb_cont = [prob_sc_high_cb_cont_1;
    prob_sc_high_cb_cont_2;
    prob_sc_high_cb_cont_3;
    prob_sc_high_cb_cont_4;
    prob_sc_high_cb_cont_5;
    prob_sc_high_cb_cont_6;
    prob_sc_high_cb_cont_7;
    prob_sc_high_cb_cont_8;
    prob_sc_high_cb_cont_9;
    prob_sc_high_cb_cont_10];

yyaxis right
plot(smooth(prob_cb_cont))
ylim([0 1.01])

subplot(1,2,2)
x1 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_low)./max_throughput_sc_hidden_subits(ix_occ_low));
x2 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_btw_low_med)./max_throughput_sc_hidden_subits(ix_occ_btw_low_med));
x3 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_med)./max_throughput_sc_hidden_subits(ix_occ_med));
x4 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_btw_med_high)./max_throughput_sc_hidden_subits(ix_occ_btw_med_high));
x5 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_high)./max_throughput_sc_hidden_subits(ix_occ_high));
x6 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_high_2)./max_throughput_sc_hidden_subits(ix_occ_high_2));
x7 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_high_3)./max_throughput_sc_hidden_subits(ix_occ_high_3));
x8 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_high_4)./max_throughput_sc_hidden_subits(ix_occ_high_4));
x9 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_high_5)./max_throughput_sc_hidden_subits(ix_occ_high_5));
x10 = rmmissing(max_throughput_cb_noncont_hidden_subits(ix_occ_high_6)./max_throughput_sc_hidden_subits(ix_occ_high_6));
x = [x1; x2; x3; x4; x5; x6; x7; x8; x9; x10];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1);...
     5*ones(length(x6), 1); 6*ones(length(x7), 1); 7*ones(length(x8), 1); 8*ones(length(x9), 1); 9*ones(length(x10), 1)];
boxplot(x, g)
ylim([0 6.5])
xticklabels({'10', '', '30', '', '50', '', '70', '', '90', '', '100'})
grid on
title('CB-non-cont')
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylabel('norm. best-throughput $\hat{\Gamma}^*$','interpreter','latex')
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')

prob_sc_high_cb_noncont_1 = length(x1(x1<=1)) / length(x1);
prob_sc_high_cb_noncont_2 = length(x2(x2<=1)) / length(x2);
prob_sc_high_cb_noncont_3 = length(x3(x3<=1)) / length(x3);
prob_sc_high_cb_noncont_4 = length(x4(x4<=1)) / length(x4);
prob_sc_high_cb_noncont_5 = length(x5(x5<=1)) / length(x5);
prob_sc_high_cb_noncont_6 = length(x6(x6<=1)) / length(x6);
prob_sc_high_cb_noncont_7 = length(x7(x7<=1)) / length(x7);
prob_sc_high_cb_noncont_8 = length(x8(x8<=1)) / length(x8);
prob_sc_high_cb_noncont_9 = length(x9(x9<=1)) / length(x9);
prob_sc_high_cb_noncont_10 = length(x10(x10<=1)) / length(x10);

prob_cb_noncont = [prob_sc_high_cb_noncont_1;
    prob_sc_high_cb_noncont_2;
    prob_sc_high_cb_noncont_3;
    prob_sc_high_cb_noncont_4;
    prob_sc_high_cb_noncont_5;
    prob_sc_high_cb_noncont_6;
    prob_sc_high_cb_noncont_7;
    prob_sc_high_cb_noncont_8;
    prob_sc_high_cb_noncont_9;
    prob_sc_high_cb_noncont_10];

yyaxis right
plot(smooth(prob_cb_noncont))
ylim([0 1.01])

%%

% - Boxplot normalized mean throughput in occupancy groups
figure
subplot(1,5,1)
x1 = mean_throughput_cb_cont_hinder(ix_occ_low)./mean_throughput_sc_hinder(ix_occ_low);
x2 = mean_throughput_cb_cont_hinder(ix_occ_med)./mean_throughput_sc_hinder(ix_occ_med);
x3 = mean_throughput_cb_cont_hinder(ix_occ_high)./mean_throughput_sc_hinder(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
ylabel('Throughput [Mbps]')
xlabel('Mean occupancy at 160 MHz')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,2)
x1 = mean_throughput_cb_noncont_hinder(ix_occ_low)./mean_throughput_sc_hinder(ix_occ_low);
x2 = mean_throughput_cb_noncont_hinder(ix_occ_med)./mean_throughput_sc_hinder(ix_occ_med);
x3 = mean_throughput_cb_noncont_hinder(ix_occ_high)./mean_throughput_sc_hinder(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-non-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,3)
x1 = mean_throughput_scb_hinder(ix_occ_low)./mean_throughput_sc_hinder(ix_occ_low);
x2 = mean_throughput_scb_hinder(ix_occ_med)./mean_throughput_sc_hinder(ix_occ_med);
x3 = mean_throughput_scb_hinder(ix_occ_high)./mean_throughput_sc_hinder(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,4)
x1 = mean_throughput_dcb_hinder(ix_occ_low)./mean_throughput_sc_hinder(ix_occ_low);
x2 = mean_throughput_dcb_hinder(ix_occ_med)./mean_throughput_sc_hinder(ix_occ_med);
x3 = mean_throughput_dcb_hinder(ix_occ_high)./mean_throughput_sc_hinder(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('DCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,5,5)
x1 = mean_throughput_pp_hinder(ix_occ_low)./mean_throughput_sc_hinder(ix_occ_low);
x2 = mean_throughput_pp_hinder(ix_occ_med)./mean_throughput_sc_hinder(ix_occ_med);
x3 = mean_throughput_pp_hinder(ix_occ_high)./mean_throughput_sc_hinder(ix_occ_high);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 6.5])
grid on
xticklabels({'Low', 'Med', 'High'})
title('PP')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

%%

% Boxplot BW prevention
% figure
% subplot(1,6,1)
% x1 = max_bwprev_cb_cont_hinder_subits(ix_occ_low);
% x2 = max_bwprev_cb_cont_hinder_subits(ix_occ_med);
% x3 = max_bwprev_cb_cont_hinder_subits(ix_occ_high);
% x = [x1; x2; x3];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
% boxplot(x, g)
% ylim([0 40])
% ylabel('BW prevention [MHz] - best primary')
% xlabel('Mean occupancy')
% xticklabels({'Low', 'Med', 'High'})
% grid on
% title('CB-cont')
% y_mean = [mean(x1) mean(x2) mean(x3)];
% hold on
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
%
% subplot(1,6,2)
% x1 = max_bwprev_cb_noncont_hinder_subits(ix_occ_low);
% x2 = max_bwprev_cb_noncont_hinder_subits(ix_occ_med);
% x3 = max_bwprev_cb_noncont_hinder_subits(ix_occ_high);
% x = [x1; x2; x3];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
% boxplot(x, g)
% ylim([0 40])
% xticklabels({'Low', 'Med', 'High'})
% grid on
% title('CB-noncont')
% y_mean = [mean(x1) mean(x2) mean(x3)];
% hold on
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
%
% subplot(1,6,3)
% x1 = max_bwprev_sc_hinder_subits(ix_occ_low);
% x2 = max_bwprev_sc_hinder_subits(ix_occ_med);
% x3 = max_bwprev_sc_hinder_subits(ix_occ_high);
% x = [x1; x2; x3];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
% boxplot(x, g)
% ylim([0 40])
% grid on
% xticklabels({'Low', 'Med', 'High'})
% title('SC')
% y_mean = [mean(x1) mean(x2) mean(x3)];
% hold on
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
%
% subplot(1,6,4)
% x1 = max_bwprev_scb_hinder_subits(ix_occ_low);
% x2 = max_bwprev_scb_hinder_subits(ix_occ_med);
% x3 = max_bwprev_scb_hinder_subits(ix_occ_high);
% x = [x1; x2; x3];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
% boxplot(x, g)
% ylim([0 40])
% grid on
% xticklabels({'Low', 'Med', 'High'})
% title('SCB')
% y_mean = [mean(x1) mean(x2) mean(x3)];
% hold on
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
%
% subplot(1,6,5)
% x1 = max_bwprev_dcb_hinder_subits(ix_occ_low);
% x2 = max_bwprev_dcb_hinder_subits(ix_occ_med);
% x3 = max_bwprev_dcb_hinder_subits(ix_occ_high);
% x = [x1; x2; x3];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
% boxplot(x, g)
% ylim([0 40])
% grid on
% xticklabels({'Low', 'Med', 'High'})
% title('DCB')
% y_mean = [mean(x1) mean(x2) mean(x3)];
% hold on
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
%
% subplot(1,6,6)
% x1 = max_bwprev_pp_hinder_subits(ix_occ_low);
% x2 = max_bwprev_pp_hinder_subits(ix_occ_med);
% x3 = max_bwprev_pp_hinder_subits(ix_occ_high);
% x = [x1; x2; x3];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
% boxplot(x, g)
% ylim([0 40])
% grid on
% xticklabels({'Low', 'Med', 'High'})
% title('PP')
% y_mean = [mean(x1) mean(x2) mean(x3)];
% hold on
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)


%% BW prevention
% Boxplot BW prevention all primaries in Mbps - SC and universal policies

rate_mcs9_20MHz = 97.5; % [Mbps]

% - Boxplot parameters
THRESHOLD_OCC_LOW = 0.1;
THRESHOLD_OCC_MED = 0.2;
ix_occ_low = find(av_occupancy_subits < THRESHOLD_OCC_LOW);
ix_occ_med = find((av_occupancy_subits >= THRESHOLD_OCC_LOW & av_occupancy_subits < THRESHOLD_OCC_MED));
ix_occ_high = find(av_occupancy_subits > THRESHOLD_OCC_MED);

% Boxplot BW prevention all primaries in MHz - SC and universal policies
figure
subplot(1,3,1)
x1 = av_bwprev_sc_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_sc_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_sc_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 50])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('$\omega$ [MHz]','interpreter','latex')
xticklabels({'Low', 'Med', 'High'})
grid on
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
mean_prev_sc = y_mean;
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,3,2)
x1 = av_bwprev_cb_cont_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_cb_cont_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_cb_cont_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 50])
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')
ylabel('$\omega$ [MHz]','interpreter','latex')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CO')
y_mean = [mean(x1) mean(x2) mean(x3)];
mean_prev_co = y_mean;
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,3,3)
x1 = av_bwprev_cb_noncont_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_cb_noncont_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_cb_noncont_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 50])
xticklabels({'Low', 'Med', 'High'})
grid on
title('NC')
y_mean = [mean(x1) mean(x2) mean(x3)];
mean_prev_nc = y_mean;
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
yyaxis right
ylabel('$\omega$ [Mbps]','interpreter','latex')

% Compare to raw throughput per occupancy group
mean_thr_sc = [mean(mean_throughput_sc_hinder(ix_occ_low)),...
    mean(mean_throughput_sc_hinder(ix_occ_med)),...
    mean(mean_throughput_sc_hinder(ix_occ_high))];

mean_thr_co = [mean(mean_throughput_cb_cont_hinder(ix_occ_low)),...
    mean(mean_throughput_cb_cont_hinder(ix_occ_med)),...
    mean(mean_throughput_cb_cont_hinder(ix_occ_high))];

mean_thr_nc = [mean(mean_throughput_cb_noncont_hinder(ix_occ_low)),...
    mean(mean_throughput_cb_noncont_hinder(ix_occ_med)),...
    mean(mean_throughput_cb_noncont_hinder(ix_occ_high))];

mean_gain_ratio_co_sc = mean_thr_co./mean_thr_sc;

mean_gain_ratio_nc_sc = mean_thr_nc./mean_thr_sc;

mean_loss_ratio_co_sc = mean_prev_co./mean_prev_sc;

mean_loss_ratio_nc_sc = mean_prev_nc./mean_prev_sc;

mean_gain_co_sc = mean_thr_co - mean_thr_sc;

mean_gain_nc_sc = mean_thr_nc - mean_thr_sc;

mean_loss_co_sc = mean_prev_co - mean_prev_sc;

mean_loss_nc_sc = mean_prev_nc - mean_prev_sc;

fprintf('Individual thr:\n')
fprintf('- SC:')
disp(mean_thr_sc)
fprintf('- CO:')
disp(mean_thr_co)
fprintf('- NC:')
disp(mean_thr_nc)

fprintf('Individual thr ratio wrt SC:\n')
fprintf('- CO:')
disp(mean_thr_co./mean_thr_sc)
fprintf('- NC:')
disp(mean_thr_nc./mean_thr_sc)

fprintf('Prevention [Mbps]:\n')
fprintf('- SC:')
disp(mean_prev_sc)
fprintf('- CO:')
disp(mean_prev_co)
fprintf('- NC:')
disp(mean_prev_nc)

fprintf('Prevention ratio wrt SC:\n')
fprintf('- CO:')
disp(mean_prev_co./mean_prev_sc)
fprintf('- NC:')
disp(mean_prev_nc./mean_prev_sc)

fprintf('ratio individual raw thr vs. prevented thr\n')
fprintf('- CO:')
disp(mean_thr_co ./ mean_prev_co)
fprintf('- NC:')
disp(mean_thr_nc ./ mean_prev_nc)

% Compare thr gain wrt SC to thr loss wrt SC
fprintf('ratio norm individual thr gain vs. norm thr loss wrt SC\n')
fprintf('- CO:')
disp(mean_gain_ratio_co_sc ./ mean_loss_ratio_co_sc)
fprintf('- NC:')
disp(mean_gain_ratio_nc_sc ./ mean_loss_ratio_nc_sc)

fprintf('ratio individual thr gain vs. thr loss wrt SC\n')
fprintf('- CO:')
disp(mean_gain_co_sc ./ mean_loss_co_sc)
fprintf('- NC:')
disp(mean_gain_nc_sc ./ mean_loss_nc_sc)

%%
figure
subplot(1,3,1)
x1 = av_bwprev_sc_hinder_subits(ix_occ_low,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x1 = x1(:);
x2 = av_bwprev_sc_hinder_subits(ix_occ_med,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x2 = x2(:);
x3 = av_bwprev_sc_hinder_subits(ix_occ_high,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('BW prevention - all primaries [Mbps]')
ylim([0 250])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
%disp(y_mean./y_thr_mean)
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
subplot(1,3,2)
s1 = mean(av_throughput_cb_cont_hinder_subits(ix_occ_low,:)) * 1E-6;
s2 = mean(av_throughput_cb_cont_hinder_subits(ix_occ_med,:)) * 1E-6;
s3 = mean(av_throughput_cb_cont_hinder_subits(ix_occ_high,:)) * 1E-6;
s_mean = [mean(s1(:)) mean(s2(:)) mean(s3(:))];
x1 = av_bwprev_cb_cont_hinder_subits(ix_occ_low,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x1 = x1(:);
x2 = av_bwprev_cb_cont_hinder_subits(ix_occ_med,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x2 = x2(:);
x3 = av_bwprev_cb_cont_hinder_subits(ix_occ_high,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 250])
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
subplot(1,3,3)
s1 = mean(av_throughput_cb_noncont_hinder_subits(ix_occ_low,:)) * 1E-6;
s2 = mean(av_throughput_cb_noncont_hinder_subits(ix_occ_med,:)) * 1E-6;
s3 = mean(av_throughput_cb_noncont_hinder_subits(ix_occ_high,:)) * 1E-6;
s_mean = [mean(s1(:)) mean(s2(:)) mean(s3(:))];
x1 = av_bwprev_cb_noncont_hinder_subits(ix_occ_low,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x1 = x1(:);
x2 = av_bwprev_cb_noncont_hinder_subits(ix_occ_med,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x2 = x2(:);
x3 = av_bwprev_cb_noncont_hinder_subits(ix_occ_high,:) * T_SAMPLE / (T_PERIOD * BW_SC) * rate_mcs9_20MHz;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 250])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-noncont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
yyaxis right

%% Boxplot normalized BW prevention all primaries - SC and universal policies
figure
subplot(1,3,1)
x1 = av_bwprev_sc_hinder_subits(ix_occ_low,:)./((av_occupancy_subits(ix_occ_low))'*NUM_SAMPLES_PERIOD*8*20);
x1 = x1(:);
x2 = av_bwprev_sc_hinder_subits(ix_occ_med,:)./(av_occupancy_subits(ix_occ_med)'*NUM_SAMPLES_PERIOD*8*20);
x2 = x2(:);
x3 = av_bwprev_sc_hinder_subits(ix_occ_high,:)./(av_occupancy_subits(ix_occ_high)'*NUM_SAMPLES_PERIOD*8*20);
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Norm BW prevention - all primaries')
ylim([0 1])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
subplot(1,3,2)
x1 = av_bwprev_cb_cont_hinder_subits(ix_occ_low,:)./(av_occupancy_subits(ix_occ_low)'*NUM_SAMPLES_PERIOD*8*20);
x1 = x1(:);
x2 = av_bwprev_cb_cont_hinder_subits(ix_occ_med,:)./(av_occupancy_subits(ix_occ_med)'*NUM_SAMPLES_PERIOD*8*20);
x2 = x2(:);
x3 = av_bwprev_cb_cont_hinder_subits(ix_occ_high,:)./(av_occupancy_subits(ix_occ_high)'*NUM_SAMPLES_PERIOD*8*20);
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 1])
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
subplot(1,3,3)
x1 = av_bwprev_cb_noncont_hinder_subits(ix_occ_low,:)./(av_occupancy_subits(ix_occ_low)'*NUM_SAMPLES_PERIOD*8*20);
x1 = x1(:);
x2 = av_bwprev_cb_noncont_hinder_subits(ix_occ_med,:)./(av_occupancy_subits(ix_occ_med)'*NUM_SAMPLES_PERIOD*8*20);
x2 = x2(:);
x3 = av_bwprev_cb_noncont_hinder_subits(ix_occ_high,:)./(av_occupancy_subits(ix_occ_high)'*NUM_SAMPLES_PERIOD*8*20);
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 1])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-noncont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

%% Boxplot BW prevention all primaries - all policies
figure
subplot(1,6,1)
x1 = av_bwprev_cb_cont_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_cb_cont_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_cb_cont_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 40])
ylabel('BW prevention - all primaries [MHz]')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,6,2)
x1 = av_bwprev_cb_noncont_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_cb_noncont_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_cb_noncont_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 40])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-noncont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,6,3)
x1 = av_bwprev_sc_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_sc_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_sc_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 40])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,6,4)
x1 = av_bwprev_scb_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_scb_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_scb_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 40])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,6,5)
x1 = av_bwprev_dcb_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_dcb_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_dcb_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 40])
grid on
xticklabels({'Low', 'Med', 'High'})
title('DCB')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,6,6)
x1 = av_bwprev_pp_hinder_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
x2 = av_bwprev_pp_hinder_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
x3 = av_bwprev_pp_hinder_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 40])
grid on
xticklabels({'Low', 'Med', 'High'})
title('PP')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

%% BW enabled (for foreknowing)

% Boxplot BW enabled all primaries in MHz - SC and universal policies
figure
subplot(1,3,1)
x1 = bw_enabled_sc_TXOP_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1(isnan(x1)) = 0;
x1 = x1(:);
x2 = bw_enabled_sc_TXOP_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2(isnan(x2)) = 0;
x2 = x2(:);
x3 = bw_enabled_sc_TXOP_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3(isnan(x3)) = 0;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('BW enabled - all primaries [MHz]')
ylim([0 50])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
subplot(1,3,2)
x1 = bw_enabled_cb_cont_TXOP_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1(isnan(x1)) = 0;
x1 = x1(:);
x2 = bw_enabled_cb_cont_TXOP_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2(isnan(x2)) = 0;
x2 = x2(:);
x3 = bw_enabled_cb_cont_TXOP_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3(isnan(x3)) = 0;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 50])
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-cont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
subplot(1,3,3)
x1 = bw_enabled_cb_noncont_TXOP_subits(ix_occ_low,:) * T_SAMPLE / T_PERIOD;
x1(isnan(x1)) = 0;
x1 = x1(:);
x2 = bw_enabled_cb_noncont_TXOP_subits(ix_occ_med,:) * T_SAMPLE / T_PERIOD;
x2(isnan(x2)) = 0;
x2 = x2(:);
x3 = bw_enabled_cb_noncont_TXOP_subits(ix_occ_high,:) * T_SAMPLE / T_PERIOD;
x3(isnan(x3)) = 0;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 50])
xticklabels({'Low', 'Med', 'High'})
grid on
title('CB-noncont')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)


% Boxplot BW enabled best primary in MHz - SC and universal policies

figure
subplot(1,3,1)
linear_indices = sub2ind(size(bw_enabled_sc_TXOP_subits),ix_occ_low,max_ix_cb_cont_TXOP(ix_occ_low)');
x1 = bw_enabled_sc_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
linear_indices = sub2ind(size(bw_enabled_sc_TXOP_subits),ix_occ_med,max_ix_cb_cont_TXOP(ix_occ_med)');
x2 = bw_enabled_sc_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
linear_indices = sub2ind(size(bw_enabled_sc_TXOP_subits),ix_occ_high,max_ix_cb_cont_TXOP(ix_occ_high)');
x3 = bw_enabled_sc_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('BW enabled - best primary [MHz]')
ylim([0 50])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,3,2)
linear_indices = sub2ind(size(bw_enabled_cb_cont_TXOP_subits),ix_occ_low,max_ix_cb_cont_TXOP(ix_occ_low)');
x1 = bw_enabled_cb_cont_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
linear_indices = sub2ind(size(bw_enabled_cb_cont_TXOP_subits),ix_occ_med,max_ix_cb_cont_TXOP(ix_occ_med)');
x2 = bw_enabled_cb_cont_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
linear_indices = sub2ind(size(bw_enabled_cb_cont_TXOP_subits),ix_occ_high,max_ix_cb_cont_TXOP(ix_occ_high)');
x3 = bw_enabled_cb_cont_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 50])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

subplot(1,3,3)
linear_indices = sub2ind(size(bw_enabled_cb_noncont_TXOP_subits),ix_occ_low,max_ix_cb_cont_TXOP(ix_occ_low)');
x1 = bw_enabled_cb_noncont_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x1 = x1(:);
linear_indices = sub2ind(size(bw_enabled_cb_noncont_TXOP_subits),ix_occ_med,max_ix_cb_cont_TXOP(ix_occ_med)');
x2 = bw_enabled_cb_noncont_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x2 = x2(:);
linear_indices = sub2ind(size(bw_enabled_cb_noncont_TXOP_subits),ix_occ_high,max_ix_cb_cont_TXOP(ix_occ_high)');
x3 = bw_enabled_cb_noncont_TXOP_subits(linear_indices) * T_SAMPLE / T_PERIOD;
x3 = x3(:);
x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylim([0 50])
grid on
xticklabels({'Low', 'Med', 'High'})
title('SC')
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)

%% RSTD

% *** Hinder ****
% - Low occ
x = av_throughput_cb_cont_hinder_subits(ix_occ_low,:);
rstd_cb_cont_low_occ = get_rstad(x);
x = av_throughput_cb_noncont_hinder_subits(ix_occ_low,:);
rstd_cb_noncont_low_occ = get_rstad(x);
x = av_throughput_sc_hinder_subits(ix_occ_low,:);
[rstd_sc_low_occ, mean_sc_low_occ] = get_rstad(x);
x = av_throughput_scb_hinder_subits(ix_occ_low,:);
[rstd_scb_low_occ, mean_scb_low_occ] = get_rstad(x);
x = av_throughput_dcb_hinder_subits(ix_occ_low,:);
[rstd_dcb_low_occ, mean_dcb_low_occ] = get_rstad(x);
x = av_throughput_pp_hinder_subits(ix_occ_low,:);
[rstd_pp_low_occ, mean_pp_low_occ] = get_rstad(x);
y_rstd_low = [rstd_sc_low_occ rstd_scb_low_occ rstd_dcb_low_occ rstd_pp_low_occ];
y_mean_low = [mean_sc_low_occ mean_scb_low_occ mean_dcb_low_occ mean_pp_low_occ];

% - Med occ
x = av_throughput_cb_cont_hinder_subits(ix_occ_med,:);
rstd_cb_cont_med_occ = get_rstad(x);
x = av_throughput_cb_noncont_hinder_subits(ix_occ_med,:);
rstd_cb_noncont_med_occ = get_rstad(x);
x = av_throughput_sc_hinder_subits(ix_occ_med,:);
[rstd_sc_med_occ, mean_sc_med_occ] = get_rstad(x);
x = av_throughput_scb_hinder_subits(ix_occ_med,:);
[rstd_scb_med_occ, mean_scb_med_occ] = get_rstad(x);
x = av_throughput_dcb_hinder_subits(ix_occ_med,:);
[rstd_dcb_med_occ, mean_dcb_med_occ] = get_rstad(x);
x = av_throughput_pp_hinder_subits(ix_occ_med,:);
[rstd_pp_med_occ, mean_pp_med_occ] = get_rstad(x);
y_rstd_med = [rstd_sc_med_occ rstd_scb_med_occ rstd_dcb_med_occ rstd_pp_med_occ];
y_mean_med = [mean_sc_med_occ mean_scb_med_occ mean_dcb_med_occ mean_pp_med_occ];

% - High occ
x = av_throughput_cb_cont_hinder_subits(ix_occ_high,:);
rstd_cb_cont_high_occ = get_rstad(x);
x = av_throughput_cb_noncont_hinder_subits(ix_occ_high,:);
rstd_cb_noncont_high_occ = get_rstad(x);
x = av_throughput_sc_hinder_subits(ix_occ_high,:);
[rstd_sc_high_occ, mean_sc_high_occ] = get_rstad(x);
x = av_throughput_scb_hinder_subits(ix_occ_high,:);
[rstd_scb_high_occ, mean_scb_high_occ] = get_rstad(x);
x = av_throughput_dcb_hinder_subits(ix_occ_high,:);
[rstd_dcb_high_occ, mean_dcb_high_occ] = get_rstad(x);
x = av_throughput_pp_hinder_subits(ix_occ_high,:);
[rstd_pp_high_occ, mean_pp_high_occ] = get_rstad(x);
y_rstd_high = [rstd_sc_high_occ rstd_scb_high_occ rstd_dcb_high_occ rstd_pp_high_occ];
y_mean_high = [mean_sc_high_occ mean_scb_high_occ mean_dcb_high_occ mean_pp_high_occ];

y_rstd_hinder = [y_rstd_low; y_rstd_med; y_rstd_high];
y_mean_hinder = [y_mean_low; y_mean_med; y_mean_high];



% *** Hidden ****
% - Low occ
x = av_throughput_cb_cont_hidden_subits(ix_occ_low,:);
rstd_cb_cont_low_occ = get_rstad(x);
x = av_throughput_cb_noncont_hidden_subits(ix_occ_low,:);
rstd_cb_noncont_low_occ = get_rstad(x);
x = av_throughput_sc_hidden_subits(ix_occ_low,:);
[rstd_sc_low_occ mean_sc_low_occ] = get_rstad(x);
x = av_throughput_scb_hidden_subits(ix_occ_low,:);
[rstd_scb_low_occ mean_scb_low_occ] = get_rstad(x);
x = av_throughput_dcb_hidden_subits(ix_occ_low,:);
[rstd_dcb_low_occ mean_dcb_low_occ] = get_rstad(x);
x = av_throughput_pp_hidden_subits(ix_occ_low,:);
[rstd_pp_low_occ mean_pp_low_occ] = get_rstad(x);
y_rstd_low = [rstd_sc_low_occ rstd_scb_low_occ rstd_dcb_low_occ rstd_pp_low_occ];
y_mean_low = [mean_sc_low_occ mean_scb_low_occ mean_dcb_low_occ mean_pp_low_occ];

% - Med occ
x = av_throughput_cb_cont_hidden_subits(ix_occ_med,:);
rstd_cb_cont_med_occ = get_rstad(x);
x = av_throughput_cb_noncont_hidden_subits(ix_occ_med,:);
rstd_cb_noncont_med_occ = get_rstad(x);
x = av_throughput_sc_hidden_subits(ix_occ_med,:);
[rstd_sc_med_occ mean_sc_med_occ] = get_rstad(x);
x = av_throughput_scb_hidden_subits(ix_occ_med,:);
[rstd_scb_med_occ mean_scb_med_occ] = get_rstad(x);
x = av_throughput_dcb_hidden_subits(ix_occ_med,:);
[rstd_dcb_med_occ mean_dcb_med_occ]  = get_rstad(x);
x = av_throughput_pp_hidden_subits(ix_occ_med,:);
[rstd_pp_med_occ mean_pp_med_occ]  = get_rstad(x);
y_rstd_med = [rstd_sc_med_occ rstd_scb_med_occ rstd_dcb_med_occ rstd_pp_med_occ];
y_mean_med = [mean_sc_med_occ mean_scb_med_occ mean_dcb_med_occ mean_pp_med_occ];

% - High occ
x = av_throughput_cb_cont_hidden_subits(ix_occ_high,:);
rstd_cb_cont_high_occ = get_rstad(x);
x = av_throughput_cb_noncont_hidden_subits(ix_occ_high,:);
rstd_cb_noncont_high_occ = get_rstad(x);
x = av_throughput_sc_hidden_subits(ix_occ_high,:);
[rstd_sc_high_occ mean_sc_high_occ] = get_rstad(x);
x = av_throughput_scb_hidden_subits(ix_occ_high,:);
[rstd_scb_high_occ mean_scb_high_occ] = get_rstad(x);
x = av_throughput_dcb_hidden_subits(ix_occ_high,:);
[rstd_dcb_high_occ mean_dcb_high_occ] = get_rstad(x);
x = av_throughput_pp_hidden_subits(ix_occ_high,:);
[rstd_pp_high_occ mean_pp_high_occ] = get_rstad(x);
y_rstd_high = [rstd_sc_high_occ rstd_scb_high_occ rstd_dcb_high_occ rstd_pp_high_occ];
y_mean_high = [mean_sc_high_occ mean_scb_high_occ mean_dcb_high_occ mean_pp_high_occ];

y_rstd_hidden = [y_rstd_low; y_rstd_med; y_rstd_high];
y_mean_hidden = [y_mean_low; y_mean_med; y_mean_high];

figure
subplot(2,2,1)
bar(y_rstd_hinder)
grid on
set(gca,'XTickLabel',{'L','M','H'})
ylabel('RSTD')
xlabel('Mean occupancy')
legend('SC', 'SCB', 'DCB', 'PP')
title('Hinder')
ylim([0 1])

subplot(2,2,2)
bar(y_rstd_hidden)
grid on
set(gca,'XTickLabel',{'L','M','H'})
ylabel('RSTD')
xlabel('Mean occupancy')
title('Hidden')
ylim([0 1])

subplot(2,2,3)
bar(y_mean_hinder * 1E-6)
grid on
set(gca,'XTickLabel',{'L','M','H'})
ylabel('Mean throughput [Mbps]')
xlabel('Mean occupancy')
ylim([0 600])

subplot(2,2,4)
bar(y_mean_hidden * 1E-6)
grid on
set(gca,'XTickLabel',{'L','M','H'})
ylabel('Mean throughput [Mbps]')
xlabel('Mean occupancy')
ylim([0 600])





%% Boxplot optimal throughput 5 categories

THRESHOLD_OCC_1 = 0.2;
THRESHOLD_OCC_2 = 0.4;
THRESHOLD_OCC_3 = 0.6;
THRESHOLD_OCC_4 = 0.8;
ix_occ_1 = find(av_occupancy_subits < THRESHOLD_OCC_1);
ix_occ_2 = find((av_occupancy_subits >= THRESHOLD_OCC_1 & av_occupancy_subits < THRESHOLD_OCC_2));
ix_occ_3 = find((av_occupancy_subits >= THRESHOLD_OCC_2 & av_occupancy_subits < THRESHOLD_OCC_3));
ix_occ_4 = find((av_occupancy_subits >= THRESHOLD_OCC_3 & av_occupancy_subits < THRESHOLD_OCC_4));
ix_occ_5 = find(av_occupancy_subits >= THRESHOLD_OCC_4);
x_tick_labels = {'O1', 'O2', 'O3', 'O4', 'O5'};

% - HINDER -
figure
subplot(2,6,1)
x1 = max_throughput_cb_cont_hinder_subits(ix_occ_1);
x2 = max_throughput_cb_cont_hinder_subits(ix_occ_2);
x3 = max_throughput_cb_cont_hinder_subits(ix_occ_3);
x4 = max_throughput_cb_cont_hinder_subits(ix_occ_4);
x5 = max_throughput_cb_cont_hinder_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
ylabel('Opt. Through. [Mbps]')
xticklabels(x_tick_labels)
grid on
title('CB-cont')
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,2)
x1 = max_throughput_cb_noncont_hinder_subits(ix_occ_1);
x2 = max_throughput_cb_noncont_hinder_subits(ix_occ_2);
x3 = max_throughput_cb_noncont_hinder_subits(ix_occ_3);
x4 = max_throughput_cb_noncont_hinder_subits(ix_occ_4);
x5 = max_throughput_cb_noncont_hinder_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
title('CB-non-cont')
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,3)
x1 = max_throughput_sc_hinder_subits(ix_occ_1);
x2 = max_throughput_sc_hinder_subits(ix_occ_2);
x3 = max_throughput_sc_hinder_subits(ix_occ_3);
x4 = max_throughput_sc_hinder_subits(ix_occ_4);
x5 = max_throughput_sc_hinder_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
title('SC')
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,4)
x1 = max_throughput_scb_hinder_subits(ix_occ_1);
x2 = max_throughput_scb_hinder_subits(ix_occ_2);
x3 = max_throughput_scb_hinder_subits(ix_occ_3);
x4 = max_throughput_scb_hinder_subits(ix_occ_4);
x5 = max_throughput_scb_hinder_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
title('SCB')
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,5)
x1 = max_throughput_dcb_hinder_subits(ix_occ_1);
x2 = max_throughput_dcb_hinder_subits(ix_occ_2);
x3 = max_throughput_dcb_hinder_subits(ix_occ_3);
x4 = max_throughput_dcb_hinder_subits(ix_occ_4);
x5 = max_throughput_dcb_hinder_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
title('DCB')
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,6)
x1 = max_throughput_pp_hinder_subits(ix_occ_1);
x2 = max_throughput_pp_hinder_subits(ix_occ_2);
x3 = max_throughput_pp_hinder_subits(ix_occ_3);
x4 = max_throughput_pp_hinder_subits(ix_occ_4);
x5 = max_throughput_pp_hinder_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
title('PP')
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% - HIDDEN -
subplot(2,6,7)
x1 = max_throughput_cb_cont_hidden_subits(ix_occ_1);
x2 = max_throughput_cb_cont_hidden_subits(ix_occ_2);
x3 = max_throughput_cb_cont_hidden_subits(ix_occ_3);
x4 = max_throughput_cb_cont_hidden_subits(ix_occ_4);
x5 = max_throughput_cb_cont_hidden_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
ylabel('Opt. Through. [Mbps]')
xticklabels(x_tick_labels)
grid on
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,8)
x1 = max_throughput_cb_noncont_hidden_subits(ix_occ_1);
x2 = max_throughput_cb_noncont_hidden_subits(ix_occ_2);
x3 = max_throughput_cb_noncont_hidden_subits(ix_occ_3);
x4 = max_throughput_cb_noncont_hidden_subits(ix_occ_4);
x5 = max_throughput_cb_noncont_hidden_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,9)
x1 = max_throughput_sc_hidden_subits(ix_occ_1);
x2 = max_throughput_sc_hidden_subits(ix_occ_2);
x3 = max_throughput_sc_hidden_subits(ix_occ_3);
x4 = max_throughput_sc_hidden_subits(ix_occ_4);
x5 = max_throughput_sc_hidden_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,10)
x1 = max_throughput_scb_hidden_subits(ix_occ_1);
x2 = max_throughput_scb_hidden_subits(ix_occ_2);
x3 = max_throughput_scb_hidden_subits(ix_occ_3);
x4 = max_throughput_scb_hidden_subits(ix_occ_4);
x5 = max_throughput_scb_hidden_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,11)
x1 = max_throughput_dcb_hidden_subits(ix_occ_1);
x2 = max_throughput_dcb_hidden_subits(ix_occ_2);
x3 = max_throughput_dcb_hidden_subits(ix_occ_3);
x4 = max_throughput_dcb_hidden_subits(ix_occ_4);
x5 = max_throughput_dcb_hidden_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

subplot(2,6,12)
x1 = max_throughput_pp_hidden_subits(ix_occ_1);
x2 = max_throughput_pp_hidden_subits(ix_occ_2);
x3 = max_throughput_pp_hidden_subits(ix_occ_3);
x4 = max_throughput_pp_hidden_subits(ix_occ_4);
x5 = max_throughput_pp_hidden_subits(ix_occ_5);
x = [x1; x2; x3; x4; x5];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
boxplot(x, g)
ylim([0 700])
xticklabels(x_tick_labels)
grid on
hold on
y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

%% Boxplot bandwidth prevention 5 categories

% THRESHOLD_OCC_1 = 0.2;
% THRESHOLD_OCC_2 = 0.4;
% THRESHOLD_OCC_3 = 0.6;
% THRESHOLD_OCC_4 = 0.8;
% ix_occ_1 = find(av_occupancy_subits < THRESHOLD_OCC_1);
% ix_occ_2 = find((av_occupancy_subits >= THRESHOLD_OCC_1 & av_occupancy_subits < THRESHOLD_OCC_2));
% ix_occ_3 = find((av_occupancy_subits >= THRESHOLD_OCC_2 & av_occupancy_subits < THRESHOLD_OCC_3));
% ix_occ_4 = find((av_occupancy_subits >= THRESHOLD_OCC_3 & av_occupancy_subits < THRESHOLD_OCC_4));
% ix_occ_5 = find(av_occupancy_subits >= THRESHOLD_OCC_4);
% x_tick_labels = {'O1', 'O2', 'O3', 'O4', 'O5'};
%
% % - HINDER -
% figure
% subplot(1,6,1)
% x1 = av_bwprev_cb_cont_hinder_subits(ix_occ_1,:) * T_SAMPLE / T_PERIOD;
% x1 = x1(:);
% x2 = av_bwprev_cb_cont_hinder_subits(ix_occ_2,:) * T_SAMPLE / T_PERIOD;
% x2 = x2(:);
% x3 = av_bwprev_cb_cont_hinder_subits(ix_occ_3,:) * T_SAMPLE / T_PERIOD;
% x3 = x3(:);
% x4 = av_bwprev_cb_cont_hinder_subits(ix_occ_4,:) * T_SAMPLE / T_PERIOD;
% x4 = x4(:);
% x5 = av_bwprev_cb_cont_hinder_subits(ix_occ_5,:) * T_SAMPLE / T_PERIOD;
% x5 = x5(:);
% x = [x1; x2; x3; x4; x5];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
% boxplot(x, g)
% ylim([0 80])
% ylabel('BW prevention [MHz] - all primaries')
% xticklabels(x_tick_labels)
% grid on
% title('CB-cont')
% hold on
% y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
%
% subplot(1,6,2)
% x1 = av_bwprev_cb_noncont_hinder_subits(ix_occ_1,:) * T_SAMPLE / T_PERIOD;
% x1 = x1(:);
% x2 = av_bwprev_cb_noncont_hinder_subits(ix_occ_2,:) * T_SAMPLE / T_PERIOD;
% x2 = x2(:);
% x3 = av_bwprev_cb_noncont_hinder_subits(ix_occ_3,:) * T_SAMPLE / T_PERIOD;
% x3 = x3(:);
% x4 = av_bwprev_cb_noncont_hinder_subits(ix_occ_4,:) * T_SAMPLE / T_PERIOD;
% x4 = x4(:);
% x5 = av_bwprev_cb_noncont_hinder_subits(ix_occ_5,:) * T_SAMPLE / T_PERIOD;
% x5 = x5(:);
% x = [x1; x2; x3; x4; x5];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
% boxplot(x, g)
% ylim([0 80])
% xticklabels(x_tick_labels)
% grid on
% title('CB-non-cont')
% hold on
% y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
%
% subplot(1,6,3)
% x1 = av_bwprev_sc_hinder_subits(ix_occ_1,:) * T_SAMPLE / T_PERIOD;
% x1 = x1(:);
% x2 = av_bwprev_sc_hinder_subits(ix_occ_2,:) * T_SAMPLE / T_PERIOD;
% x2 = x2(:);
% x3 = av_bwprev_sc_hinder_subits(ix_occ_3,:) * T_SAMPLE / T_PERIOD;
% x3 = x3(:);
% x4 = av_bwprev_sc_hinder_subits(ix_occ_4,:) * T_SAMPLE / T_PERIOD;
% x4 = x4(:);
% x5 = av_bwprev_sc_hinder_subits(ix_occ_5,:) * T_SAMPLE / T_PERIOD;
% x5 = x5(:);
% x = [x1; x2; x3; x4; x5];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
% boxplot(x, g)
% ylim([0 80])
% xticklabels(x_tick_labels)
% grid on
% title('SC')
% hold on
% y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
%
% subplot(1,6,4)
% x1 = av_bwprev_scb_hinder_subits(ix_occ_1,:) * T_SAMPLE / T_PERIOD;
% x1 = x1(:);
% x2 = av_bwprev_scb_hinder_subits(ix_occ_2,:) * T_SAMPLE / T_PERIOD;
% x2 = x2(:);
% x3 = av_bwprev_scb_hinder_subits(ix_occ_3,:) * T_SAMPLE / T_PERIOD;
% x3 = x3(:);
% x4 = av_bwprev_scb_hinder_subits(ix_occ_4,:) * T_SAMPLE / T_PERIOD;
% x4 = x4(:);
% x5 = av_bwprev_scb_hinder_subits(ix_occ_5,:) * T_SAMPLE / T_PERIOD;
% x5 = x5(:);
% x = [x1; x2; x3; x4; x5];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
% boxplot(x, g)
% ylim([0 700])
% xticklabels(x_tick_labels)
% grid on
% title('SCB')
% hold on
% y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
%
% subplot(1,6,5)
% x1 = av_bwprev_dcb_hinder_subits(ix_occ_1,:) * T_SAMPLE / T_PERIOD;
% x1 = x1(:);
% x2 = av_bwprev_dcb_hinder_subits(ix_occ_2,:) * T_SAMPLE / T_PERIOD;
% x2 = x2(:);
% x3 = av_bwprev_dcb_hinder_subits(ix_occ_3,:) * T_SAMPLE / T_PERIOD;
% x3 = x3(:);
% x4 = av_bwprev_dcb_hinder_subits(ix_occ_4,:) * T_SAMPLE / T_PERIOD;
% x4 = x4(:);
% x5 = av_bwprev_dcb_hinder_subits(ix_occ_5,:) * T_SAMPLE / T_PERIOD;
% x5 = x5(:);
% x = [x1; x2; x3; x4; x5];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
% boxplot(x, g)
% ylim([0 80])
% xticklabels(x_tick_labels)
% grid on
% title('DCB')
% hold on
% y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
%
% subplot(1,6,6)
% x1 = av_bwprev_pp_hinder_subits(ix_occ_1,:) * T_SAMPLE / T_PERIOD;
% x1 = x1(:);
% x2 = av_bwprev_pp_hinder_subits(ix_occ_2,:) * T_SAMPLE / T_PERIOD;
% x2 = x2(:);
% x3 = av_bwprev_pp_hinder_subits(ix_occ_3,:) * T_SAMPLE / T_PERIOD;
% x3 = x3(:);
% x4 = av_bwprev_pp_hinder_subits(ix_occ_4,:) * T_SAMPLE / T_PERIOD;
% x4 = x4(:);
% x5 = av_bwprev_pp_hinder_subits(ix_occ_5,:) * T_SAMPLE / T_PERIOD;
% x5 = x5(:);
% x = [x1; x2; x3; x4; x5];
% g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1); 3*ones(length(x4), 1); 4*ones(length(x5), 1)];
% boxplot(x, g)
% ylim([0 80])
% xticklabels(x_tick_labels)
% grid on
% title('PP')
% hold on
% y_mean = [mean(x1) mean(x2) mean(x3) mean(x4) mean(x5)];
% plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

%%

% Penalty of not depriving [Mbps]

penalty_cb_cont =  max_throughput_cb_cont_hinder_subits - max_throughput_cb_cont_foreknowing_subits;
penalty_cb_noncont =  max_throughput_cb_noncont_hinder_subits - max_throughput_cb_noncont_foreknowing_subits;



figure
subplot(1,2,1)
x1 = penalty_cb_cont(ix_occ_low);
x2 = penalty_cb_cont(ix_occ_med);
x3 = penalty_cb_cont(ix_occ_high);

x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Individual penalty [Mbps]', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-cont')
rectangle('Position', [-1 -100 42 100], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])

subplot(1,2,2)

x1 = penalty_cb_noncont(ix_occ_low);
x2 = penalty_cb_noncont(ix_occ_med);
x3 = penalty_cb_noncont(ix_occ_high);

x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-non-cont')
rectangle('Position', [-1 -100 42 100], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])

% Gain to surrounding BSSs due to foreknowing

num_env_active_samples = av_occupancy_subits * num_rssi_samples_down_subit * NUM_RFs;

linear_indices = sub2ind(size(av_bwprev_sc_hinder_subits),1:length(av_bwprev_sc_hinder_subits),max_ix_cb_cont_hinder');

factor_samples_to_Mbps = T_SAMPLE * rate_mcs9_20MHz / T_PERIOD;

thr_ext_cb_cont_TXOP = num_env_active_samples * factor_samples_to_Mbps;
thr_ext_cb_noncont_TXOP = num_env_active_samples * factor_samples_to_Mbps;
thr_ext_cb_cont_hinder = (num_env_active_samples -...
    av_bwprev_cb_cont_hinder_subits(linear_indices) / BW_SC) * factor_samples_to_Mbps;
thr_ext_cb_noncont_hinder = (num_env_active_samples -...
    av_bwprev_cb_noncont_hinder_subits(linear_indices) / BW_SC) * factor_samples_to_Mbps;

gain_cb_cont = thr_ext_cb_cont_TXOP - thr_ext_cb_cont_hinder;
gain_cb_noncont = thr_ext_cb_noncont_TXOP - thr_ext_cb_noncont_hinder;

% Ratios
ratio_low_cb_cont = mean(penalty_cb_cont(ix_occ_low)) / mean(gain_cb_cont(ix_occ_low));
ratio_med_cb_cont = mean(penalty_cb_cont(ix_occ_med)) / mean(gain_cb_cont(ix_occ_med));
ratio_high_cb_cont = mean(penalty_cb_cont(ix_occ_high)) / mean(gain_cb_cont(ix_occ_high));

fprintf('Ratio CB-cont ind. penalty / ext. gain: Low = %.2f, Med = %.2f, Hig = %.2f\n',...
    ratio_low_cb_cont, ratio_med_cb_cont, ratio_high_cb_cont)

ratio_low_cb_noncont = mean(penalty_cb_noncont(ix_occ_low)) / mean(gain_cb_noncont(ix_occ_low));
ratio_med_cb_noncont = mean(penalty_cb_noncont(ix_occ_med)) / mean(gain_cb_noncont(ix_occ_med));
ratio_high_cb_noncont = mean(penalty_cb_noncont(ix_occ_high)) / mean(gain_cb_noncont(ix_occ_high));

fprintf('Ratio CB-non-cont ind. penalty / ext. gain: Low = %.2f, Med = %.2f, Hig = %.2f\n',...
    ratio_low_cb_noncont, ratio_med_cb_noncont, ratio_high_cb_noncont)

figure
subplot(1,2,1)
x1 = gain_cb_cont(ix_occ_low);
x2 = gain_cb_cont(ix_occ_med);
x3 = gain_cb_cont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('External gain [Mbps]', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-cont')
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])

subplot(1,2,2)
x1 = gain_cb_noncont(ix_occ_low);
x2 = gain_cb_noncont(ix_occ_med);
x3 = gain_cb_noncont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-non-cont')
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])



% ------------
subplot(1,4,1)
x1 = penalty_cb_cont(ix_occ_low);
x2 = penalty_cb_cont(ix_occ_med);
x3 = penalty_cb_cont(ix_occ_high);

x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Individual penalty [Mbps]', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-cont')
rectangle('Position', [-1 -100 42 100], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])

subplot(1,4,2)

x1 = penalty_cb_noncont(ix_occ_low);
x2 = penalty_cb_noncont(ix_occ_med);
x3 = penalty_cb_noncont(ix_occ_high);

x = [x1; x2; x3];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-non-cont')
rectangle('Position', [-1 -100 42 100], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])


subplot(1,4,3)
x1 = gain_cb_cont(ix_occ_low);
x2 = gain_cb_cont(ix_occ_med);
x3 = gain_cb_cont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('External gain [Mbps]', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-cont')
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])

subplot(1,4,4)
x1 = gain_cb_noncont(ix_occ_low);
x2 = gain_cb_noncont(ix_occ_med);
x3 = gain_cb_noncont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-non-cont')
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
ylim([-100 600])

% ---------------

% Penalty vs. gain due to foreknowing

ratio_penalty_gain_cb_cont = gain_cb_cont./penalty_cb_cont';
ratio_penalty_gain_cb_noncont = gain_cb_noncont./penalty_cb_noncont';

figure
subplot(1,2,1)
x1 = ratio_penalty_gain_cb_cont(ix_occ_low);
x2 = ratio_penalty_gain_cb_cont(ix_occ_med);
x3 = ratio_penalty_gain_cb_cont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Ext. gain / Ind. penalty', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-cont')
set(gca,'children',flipud(get(gca,'children')))
ylim([-10 10])
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

subplot(1,2,2)
x1 = ratio_penalty_gain_cb_noncont(ix_occ_low);
x2 = ratio_penalty_gain_cb_noncont(ix_occ_med);
x3 = ratio_penalty_gain_cb_noncont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-non-cont')
set(gca,'children',flipud(get(gca,'children')))
ylim([-10 10])
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))


% Ratio penalty vs. gain

ratio_penalty_gain_cb_cont = penalty_cb_cont'./gain_cb_cont;
ratio_penalty_gain_cb_noncont = penalty_cb_noncont'./gain_cb_noncont;

figure
subplot(1,2,1)
x1 = ratio_penalty_gain_cb_cont(ix_occ_low);
x2 = ratio_penalty_gain_cb_cont(ix_occ_med);
x3 = ratio_penalty_gain_cb_cont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
ylabel('Ind. penalty / Ext. gain', 'Interpreter','latex')
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-cont')
set(gca,'children',flipud(get(gca,'children')))
ylim([-20 80])
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

subplot(1,2,2)
x1 = ratio_penalty_gain_cb_noncont(ix_occ_low);
x2 = ratio_penalty_gain_cb_noncont(ix_occ_med);
x3 = ratio_penalty_gain_cb_noncont(ix_occ_high);

x = [x1'; x2'; x3'];
g = [zeros(length(x1), 1); ones(length(x2), 1); 2*ones(length(x3), 1)];
boxplot(x, g)
xlabel('Mean occupancy')
xticklabels({'Low', 'Med', 'High'})
grid on
y_mean = [mean(x1) mean(x2) mean(x3)];
hold on
plot(y_mean,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 6)
title('CB-non-cont')
set(gca,'children',flipud(get(gca,'children')))
ylim([-20 80])
rectangle('Position', [-1 -0.25 7 0.01], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

function [av_rstd, av_mean_val] = get_rstad(x)
    
    mean_val = mean(x,2);
    var_val = var(x,0,2);
    av_mean_val = mean(mean_val);
    av_var_val = mean(var_val);
    av_std_val = sqrt(av_var_val);
    av_rstd = av_std_val / av_mean_val;
    
end

function mean_without_max = get_mean_without_max(in_matrix)
   
    num_rows = size(in_matrix,1);
    num_cols = size(in_matrix,2);
    matrix_without_max = zeros(num_rows, num_cols-1);
    
    for sub_ix = 1:num_rows
        thr_subit = in_matrix(sub_ix,:);
        [~, indexOfMax] = max(thr_subit); % Find index of the min.
        thr_subit(indexOfMax) = [];  % Delete the min element.
        matrix_without_max(sub_ix,:) = thr_subit;
    end
    
    mean_without_max = mean(matrix_without_max, 2);
    
end
