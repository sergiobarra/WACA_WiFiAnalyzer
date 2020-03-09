%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_sim_output_aggregation.m
% 
% Plots the output of simulating the dataset (variable no. of data packets aggregated per frame)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
clc

% Load
load('results_subiterations_100ms.mat')
load('results_subiterations_100ms_20Dec2019.mat')
fprintf('All loaded')

%% Assess

NUM_SUBITS = size(throughput_per_ch_per_Nagg_sc,1);
NUM_RFs = size(throughput_per_ch_per_Nagg_sc,2);
NUM_Naggs = size(throughput_per_ch_per_Nagg_sc,3);

%Nagg_VALUES = 1 8 16 ... 256;

% Get optimal primary
[max_throughput_per_Nagg_cb_cont, max_throughput_ix_per_Nagg_cb_cont] = get_max_Nagg(throughput_per_ch_per_Nagg_cb_cont);
[max_throughput_per_Nagg_cb_noncont, max_throughput_ix_per_Nagg_cb_noncont] = get_max_Nagg(throughput_per_ch_per_Nagg_cb_noncont);
[max_throughput_per_Nagg_sc, max_throughput_ix_per_Nagg_sc] = get_max_Nagg(throughput_per_ch_per_Nagg_sc);
[max_throughput_per_Nagg_scb, max_throughput_ix_per_Nagg_scb] = get_max_Nagg(throughput_per_ch_per_Nagg_scb);
[max_throughput_per_Nagg_dcb, max_throughput_ix_per_Nagg_dcb] = get_max_Nagg(throughput_per_ch_per_Nagg_dcb);
[max_throughput_per_Nagg_pp, max_throughput_ix_per_Nagg_pp] = get_max_Nagg(throughput_per_ch_per_Nagg_pp);

% Occupancy thresholds
THRESHOLD_OCC_LOW = 0.1;
THRESHOLD_OCC_MED = 0.2;
ix_occ_low = find(av_occupancy_subits < THRESHOLD_OCC_LOW);
ix_occ_med = find((av_occupancy_subits >= THRESHOLD_OCC_LOW & av_occupancy_subits < THRESHOLD_OCC_MED));
ix_occ_high = find(av_occupancy_subits > THRESHOLD_OCC_MED);

%% Boxplot

% Occupancy as x-axis
figure

% CB-cont
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_cb_cont)', av_occupancy_subits);
subplot(1,6,1)
boxplot(x, g)
ylim([1 256])
grid on
title('CB-cont')
ylabel('Optimal No. pkts. agg.')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% CB-non-cont
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_cb_noncont)', av_occupancy_subits);
subplot(1,6,2)
boxplot(x, g)
ylim([1 256])
grid on
title('CB-non-cont')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% SC
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_sc)', av_occupancy_subits);
subplot(1,6,3)
boxplot(x, g)
ylim([1 256])
grid on
title('SC')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% SCB
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_scb)', av_occupancy_subits);
subplot(1,6,4)
boxplot(x, g)
ylim([1 256])
grid on
title('SCB')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% DCB
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_dcb)', av_occupancy_subits);
subplot(1,6,5)
boxplot(x, g)
ylim([1 256])
grid on
title('DCB')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% PP
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_pp)', av_occupancy_subits);
subplot(1,6,6)
boxplot(x, g)
ylim([1 256])
grid on
title('PP')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

%% Boxplot only universal

% Occupancy as x-axis
figure

% CB-cont
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_cb_cont)', av_occupancy_subits);
subplot(1,2,1)
boxplot(x, g)
ylim([1 256])
grid on
title('CB-cont')
ylabel('opt. no. pkts. agg $N_a^*$','Interpreter','latex')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')

% CB-non-cont
[x, g, mean_val] = get_boxplot_group(Nagg_VALUES(max_throughput_ix_per_Nagg_cb_noncont)', av_occupancy_subits);
subplot(1,2,2)
boxplot(x, g)
ylim([1 256])
grid on
title('CB-non-cont')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
xlabel('mean occupancy $\bar{o}_B$','interpreter','latex')



%%
%*** Throughput ***

% Policy as x-axis
figure

% Low
ix_occ = ix_occ_low;
thr_sc_opt = max_throughput_per_Nagg_sc(ix_occ) * 1E-6;
thr_scb_opt = max_throughput_per_Nagg_scb(ix_occ) * 1E-6;
thr_dcb_opt = max_throughput_per_Nagg_dcb(ix_occ) * 1E-6;
thr_pp_opt = max_throughput_per_Nagg_pp(ix_occ) * 1E-6;
y_boxplot = [thr_sc_opt thr_scb_opt thr_dcb_opt thr_pp_opt];
subplot(1,3,1)
boxplot(y_boxplot)
ylim([0 700])
grid on
title('Low occ.')
ylabel('Optimal throughput [Mbps]')
set(gca,'XTickLabel',{'SC','SCB','DCB','PP'})


% Moderate
ix_occ = ix_occ_med;
thr_sc_opt = max_throughput_per_Nagg_sc(ix_occ) * 1E-6;
thr_scb_opt = max_throughput_per_Nagg_scb(ix_occ) * 1E-6;
thr_dcb_opt = max_throughput_per_Nagg_dcb(ix_occ) * 1E-6;
thr_pp_opt = max_throughput_per_Nagg_pp(ix_occ) * 1E-6;
y_boxplot = [thr_sc_opt thr_scb_opt thr_dcb_opt thr_pp_opt];
subplot(1,3,2)
boxplot(y_boxplot)
ylim([0 700])
grid on
title('Med. occ.')
set(gca,'XTickLabel',{'SC','SCB','DCB','PP'})

% High
ix_occ = ix_occ_high;
thr_sc_opt = max_throughput_per_Nagg_sc(ix_occ) * 1E-6;
thr_scb_opt = max_throughput_per_Nagg_scb(ix_occ) * 1E-6;
thr_dcb_opt = max_throughput_per_Nagg_dcb(ix_occ) * 1E-6;
thr_pp_opt = max_throughput_per_Nagg_pp(ix_occ) * 1E-6;
y_boxplot = [thr_sc_opt thr_scb_opt thr_dcb_opt thr_pp_opt];
subplot(1,3,3)
boxplot(y_boxplot)
ylim([0 700])
grid on
title('High occ.')
set(gca,'XTickLabel',{'SC','SCB','DCB','PP'})

% Occupancy as x-axis
figure

% CB-cont
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_cb_cont * 1E-6, av_occupancy_subits);
subplot(1,6,1)
boxplot(x, g)
ylim([0 700])
grid on
title('CB-cont')
ylabel('Optimal throughput [Mbps]')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% CB-non-cont
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_cb_noncont * 1E-6, av_occupancy_subits);
subplot(1,6,2)
boxplot(x, g)
ylim([0 700])
grid on
title('CB-non-cont')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% SC
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_sc * 1E-6, av_occupancy_subits);
subplot(1,6,3)
boxplot(x, g)
ylim([0 700])
grid on
title('SC')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% SCB
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_scb * 1E-6, av_occupancy_subits);
subplot(1,6,4)
boxplot(x, g)
ylim([0 700])
grid on
title('SCB')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% DCB
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_dcb * 1E-6, av_occupancy_subits);
subplot(1,6,5)
boxplot(x, g)
ylim([0 700])
grid on
title('DCB')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)

% PP
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_pp * 1E-6, av_occupancy_subits);
subplot(1,6,6)
boxplot(x, g)
ylim([0 700])
grid on
title('PP')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
legend('Mean')


%% 
%*** Throughput ***

% Policy as x-axis
figure

% Low
ix_occ = ix_occ_low;
thr_sc_opt = max_throughput_per_Nagg_sc(ix_occ) * 1E-6;
thr_scb_opt = max_throughput_per_Nagg_scb(ix_occ) * 1E-6;
thr_dcb_opt = max_throughput_per_Nagg_dcb(ix_occ) * 1E-6;
thr_pp_opt = max_throughput_per_Nagg_pp(ix_occ) * 1E-6;
y_boxplot = [thr_sc_opt thr_scb_opt thr_dcb_opt thr_pp_opt];
subplot(1,3,1)
boxplot(y_boxplot)
ylim([0 700])
grid on
title('Low occ.')
ylabel('Optimal throughput [Mbps]')
set(gca,'XTickLabel',{'SC','SCB','DCB','PP'})


% Moderate
ix_occ = ix_occ_med;
thr_sc_opt = max_throughput_per_Nagg_sc(ix_occ) * 1E-6;
thr_scb_opt = max_throughput_per_Nagg_scb(ix_occ) * 1E-6;
thr_dcb_opt = max_throughput_per_Nagg_dcb(ix_occ) * 1E-6;
thr_pp_opt = max_throughput_per_Nagg_pp(ix_occ) * 1E-6;
y_boxplot = [thr_sc_opt thr_scb_opt thr_dcb_opt thr_pp_opt];
subplot(1,3,2)
boxplot(y_boxplot)
ylim([0 700])
grid on
title('Med. occ.')
set(gca,'XTickLabel',{'SC','SCB','DCB','PP'})

% High
ix_occ = ix_occ_high;
thr_sc_opt = max_throughput_per_Nagg_sc(ix_occ) * 1E-6;
thr_scb_opt = max_throughput_per_Nagg_scb(ix_occ) * 1E-6;
thr_dcb_opt = max_throughput_per_Nagg_dcb(ix_occ) * 1E-6;
thr_pp_opt = max_throughput_per_Nagg_pp(ix_occ) * 1E-6;
y_boxplot = [thr_sc_opt thr_scb_opt thr_dcb_opt thr_pp_opt];
subplot(1,3,3)
boxplot(y_boxplot)
ylim([0 700])
grid on
title('High occ.')
set(gca,'XTickLabel',{'SC','SCB','DCB','PP'})

% Occupancy as x-axis
figure

% CB-cont
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_cb_cont./max_throughput_per_Nagg_sc, av_occupancy_subits);
subplot(1,2,1)
boxplot(x, g)
ylim([0 8])
grid on
title('CO')
ylabel('Optimal norm throughput [Mbps]', 'interpreter', 'latex')
xlabel('mean occupancy $\bar{o}_B$', 'interpreter', 'latex')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))

fprintf('Opt. normalized throughput for L, M and H occupancy\n')
fprintf('- CO:\n')
disp(mean_val)

% CB-non-cont
[x, g, mean_val] = get_boxplot_group(max_throughput_per_Nagg_cb_noncont./max_throughput_per_Nagg_sc, av_occupancy_subits);
subplot(1,2,2)
boxplot(x, g)
ylim([0 8])
grid on
title('NC')
xlabel('mean occupancy $\bar{o}_B$', 'interpreter', 'latex')
set(gca,'XTickLabel',{'L','M','H'})
hold on
plot(mean_val,'g-o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 4)
rectangle('Position', [-1 -1 100 2], 'FaceColor', [0 0 1 0.3])
set(gca,'children',flipud(get(gca,'children')))
fprintf('- NC:\n')
disp(mean_val)


function [max_throughput_per_Nagg, max_throughput_ix_per_Nagg] = get_max_Nagg(throughput_per_ch_per_Nagg)
    
    NUM_SUBITS = size(throughput_per_ch_per_Nagg,1);
    NUM_RFs = size(throughput_per_ch_per_Nagg,2);
    NUM_Naggs = size(throughput_per_ch_per_Nagg,3);
    
    max_throughput_ix_per_Nagg = zeros(NUM_SUBITS,1);
    max_throughput_per_Nagg = zeros(NUM_SUBITS,1);
    
    for subit_ix = 1:NUM_SUBITS
        matrix_3d = throughput_per_ch_per_Nagg(subit_ix,:,:);    % matrix 1 x NUM_RFs x NUM_Naggs
        matrix_2d = reshape(matrix_3d,[NUM_RFs NUM_Naggs]);        % matrix NUM_RFs x NUM_Naggs
        [maxVal, maxIndex] = max(matrix_2d(:));                     % Find max throughput
        max_throughput_per_Nagg(subit_ix) = maxVal;
        [~, col] = ind2sub(size(matrix_2d), maxIndex);            % Find row and column of max
        max_throughput_ix_per_Nagg(subit_ix) = col;
    end
    
end

function [x,g,mean_val] = get_boxplot_group(val_per_Nagg, av_occupancy_subits)
    
    THRESHOLD_OCC_LOW = 0.1;
    THRESHOLD_OCC_MED = 0.2;
    ix_occ_low = av_occupancy_subits < THRESHOLD_OCC_LOW;
    ix_occ_med = (av_occupancy_subits >= THRESHOLD_OCC_LOW & av_occupancy_subits < THRESHOLD_OCC_MED);
    ix_occ_high = av_occupancy_subits > THRESHOLD_OCC_MED;
    
    val = val_per_Nagg;
    val_low = val(ix_occ_low);
    val_med = val(ix_occ_med);
    val_high = val(ix_occ_high);
    
    x = [val_low; val_med; val_high];
    g = [zeros(length(val_low), 1); ones(length(val_med), 1); 2*ones(length(val_high), 1)];
    mean_val = [mean(val_low) mean(val_med) mean(val_high)];
    
end