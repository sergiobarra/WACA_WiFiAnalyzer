%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% waca_main.m
%
% This files runs a WACA measurement campaing.
%
% - x6 RXers (with 4 RFs each). x6 FMC daughter boards. Thus, all RXer WARPs need to implement 4RF.bin at their SD
% cards. There's no TXer.
% - x24 20-MHz channels considered for receiving. There is no channel switching.
% - Iteration system included
% - Extension to full 5GHz band including channels #149 to #161
%
% ------------------------------------------------------------------------
% WARPLab: Copyright (c) 2015 Mango Communications - All Rights Reserved
% Distributed under the WARP License (http://warpproject.org/license)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all
clc

%% Experiment setup

% Set the date and time for the experiment to start
% - If a past date is entered, the experiment will run instantaneously
dtime_now = datetime('now');
dtime_start = datetime(2019,8,4,17,24,00);
formatOut = 'dd/mm/yy HH:MM:SS';
fprintf('Experiment scheduled at %s for starting at %s\n',...
    datestr(dtime_now,formatOut), datestr(dtime_start,formatOut))
time_wait = seconds(dtime_start-dtime_now);
fprintf('Waiting %.0f seconds (%.2f hours)...\n', time_wait, time_wait/3600)
pause(time_wait)
fprintf('Action started at %s\n', datestr(datetime('now'), formatOut))

% WARPLab metadata
NUMNODES = 6;                           % No. of WARP nodes required
BAND = 5;                               % Frequency band (2.4, 5) GHz

% - Signals capturing
get_signals = false;    % Capture signals (listen to actual values of the channel)
get_rssi = true;        % Capture RSSI values
% - Plots
plot_signals = false;   % Plot signals
plot_rssi = false;      % Plot RSSI in dBm
plot_rssi_1024 = false;  % Plot RSSI in 10 bit scale [0-1023]
plot_av_rssi = false;   % Plot Av. RSSI
plot_rssi_dbm_max_ylim = -40;
plot_rssi_1024_max_ylim = 900;

% - Save results
save_signals = false;   % Save signals in .mat
save_rssi = true;       % Save RSSI in .mat
% - Clear variables after each iteration.
%    * This is required to avoid running out of memory in the PC. Note that the workspace consumes a lot of memory
% if arrays rx_vec_air_temporal and rssi_temporal are not free.
clear_signals = false;   % Clear signal arrays
clear_rssi = true;      % Clear RSSI arrays

% - Duration of the experiment
NUM_SAMPLES_MILLISECOND = 40000;    % 40000 samples = 1 ms
num_ms_sniff = 1000;    % Duration in ms of each sniff
num_iterations = 6000;   % Num. of sniffing iterations
num_rx_samples = NUM_SAMPLES_MILLISECOND * num_ms_sniff;
num_rssi_samples  = num_rx_samples/4;
cca_ed = -62;
cca_cs = -82;
downsample_factor_rssi = 100; % RSSI frequency sample is divided by this factor

% - Save experiment
name_experiment = 'test';
formatOut = 'mm-dd-yy_HH-MM-SS';
date_str = datestr(datetime('now'),formatOut);
path_output = ['experiments/sniff/' date_str '_ms' num2str(num_ms_sniff) '_it' num2str(num_iterations)];
path_diary =  [path_output '/console_logs.txt'];

% Channel dictionary
CHANNELS_11AC = [36,38,40,44,46,48,52,54,56,60,62,64,100,102,104,108,110,112,116,118,120,124,126,128,132,134,136,140,142,144,149,151,153,157,159,161];
CHANNELS_11AC_20MHZ = [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140,144,149,153,157,161];
CHANNELS_11AC_40MHZ = [38,46,54,62,102,110,118,126,134,142];
CHANNELS_20MHZ = [1,3,4,6,7,9,10,12,13,15,16,18,19,21,22,24,25,27,28,30,31,33,34,36];
CHANNELS_40MHZ = [2,5,8,11,14,17,20,23,26,29];

% Calibration
% CHANNEL_CALIBRATION = 64;
% cal_thr = cca_cs;
%
% RX_CHANNEL_AC_A_a = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_B_a = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_C_a = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_D_a = CHANNEL_CALIBRATION;
%
% RX_CHANNEL_AC_A_b = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_B_b = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_C_b = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_D_b = CHANNEL_CALIBRATION;
%
% RX_CHANNEL_AC_A_c = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_B_c = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_C_c = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_D_c = CHANNEL_CALIBRATION;
%
% RX_CHANNEL_AC_A_d = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_B_d = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_C_d = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_D_d = CHANNEL_CALIBRATION;
%
% RX_CHANNEL_AC_A_e = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_B_e = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_C_e = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_D_e = CHANNEL_CALIBRATION;
%
% RX_CHANNEL_AC_A_f = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_B_f = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_C_f = CHANNEL_CALIBRATION;
% RX_CHANNEL_AC_D_f = CHANNEL_CALIBRATION;

RX_CHANNEL_AC_A_a = 36;
RX_CHANNEL_AC_B_a = 40;
RX_CHANNEL_AC_C_a = 44;
RX_CHANNEL_AC_D_a = 48;

RX_CHANNEL_AC_A_b = 52;
RX_CHANNEL_AC_B_b = 56;
RX_CHANNEL_AC_C_b = 60;
RX_CHANNEL_AC_D_b = 64;

RX_CHANNEL_AC_A_c = 100;
RX_CHANNEL_AC_B_c = 104;
RX_CHANNEL_AC_C_c = 108;
RX_CHANNEL_AC_D_c = 112;

RX_CHANNEL_AC_A_d = 116;
RX_CHANNEL_AC_B_d = 120;
RX_CHANNEL_AC_C_d = 124;
RX_CHANNEL_AC_D_d = 128;

RX_CHANNEL_AC_A_e = 132;
RX_CHANNEL_AC_B_e = 136;
RX_CHANNEL_AC_C_e = 140;
RX_CHANNEL_AC_D_e = 144;

RX_CHANNEL_AC_A_f = 149;
RX_CHANNEL_AC_B_f = 153;
RX_CHANNEL_AC_C_f = 157;
RX_CHANNEL_AC_D_f = 161;

RX_CHANNEL_A_a = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_A_a);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_B_a = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_B_a);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_C_a = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_C_a);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_D_a = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_D_a);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])

RX_CHANNEL_A_b = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_A_b);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_B_b = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_B_b);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_C_b = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_C_b);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_D_b = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_D_b);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])

RX_CHANNEL_A_c = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_A_c);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_B_c = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_B_c);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_C_c = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_C_c);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_D_c = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_D_c);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])

RX_CHANNEL_A_d = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_A_d);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_B_d = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_B_d);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_C_d = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_C_d);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_D_d = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_D_d);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])

RX_CHANNEL_A_e = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_A_e);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_B_e = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_B_e);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_C_e = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_C_e);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_D_e = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_D_e);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])

RX_CHANNEL_A_f = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_A_f);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_B_f = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_B_f);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_C_f = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_C_f);    % Choose the RXer A's channel (2.4: [1,14], 5: [1,44])
RX_CHANNEL_D_f = CHANNELS_20MHZ(CHANNELS_11AC_20MHZ==RX_CHANNEL_AC_D_f);    % Choose the RXer B's channel (2.4: [1,14], 5: [1,44])

% Signal params
rx_lpf_corn_freq = 0;               % corner frequency for the MAX2829 Rx path low pass filter. Must be integer in [0,1,2,3] for approx ![7.5,9.5,14,18]MHz corner frequencies ([15,19,28,36]MHz bandwidths)
rx_gain_rf = 3;                     % Rx RF Gain in [1:3] (Just for AGC no active)
rx_gain_bb = 0;                     % Rx Baseband Gain in [0:31] (Just for AGC no active)
TRIGGER_OFFSET_TOL_NS   = 0;        % Trigger time offset toleration between Tx and Rx that can be accomodated

% Global variables
rx_vec_air_temporal_A_a = [];
rssi_temporal_A_a = [];
rx_vec_air_temporal_B_a = [];
rssi_temporal_B_a = [];
rx_vec_air_temporal_C_a = [];
rssi_temporal_C_a = [];
rx_vec_air_temporal_D_a = [];
rssi_temporal_D_a = [];

rx_vec_air_temporal_A_b = [];
rssi_temporal_A_b = [];
rx_vec_air_temporal_B_b = [];
rssi_temporal_B_b = [];
rx_vec_air_temporal_C_b = [];
rssi_temporal_C_b = [];
rx_vec_air_temporal_D_b = [];
rssi_temporal_D_b = [];

rx_vec_air_temporal_A_c = [];
rssi_temporal_A_c = [];
rx_vec_air_temporal_B_c = [];
rssi_temporal_B_c = [];
rx_vec_air_temporal_C_c = [];
rssi_temporal_C_c = [];
rx_vec_air_temporal_D_c = [];
rssi_temporal_D_c = [];

rx_vec_air_temporal_A_d = [];
rssi_temporal_A_d = [];
rx_vec_air_temporal_B_d = [];
rssi_temporal_B_d = [];
rx_vec_air_temporal_C_d = [];
rssi_temporal_C_d = [];
rx_vec_air_temporal_D_d = [];
rssi_temporal_D_d = [];

rx_vec_air_temporal_A_e = [];
rssi_temporal_A_e = [];
rx_vec_air_temporal_B_e = [];
rssi_temporal_B_e = [];
rx_vec_air_temporal_C_e = [];
rssi_temporal_C_e = [];
rx_vec_air_temporal_D_e = [];
rssi_temporal_D_e = [];

rx_vec_air_temporal_A_f = [];
rssi_temporal_A_f = [];
rx_vec_air_temporal_B_f = [];
rssi_temporal_B_f = [];
% rssi_temporal_B_f_down= [];
% rssi_temporal_B_f_redown= [];
rx_vec_air_temporal_C_f = [];
rssi_temporal_C_f = [];
rx_vec_air_temporal_D_f = [];
rssi_temporal_D_f = [];

%% WARPLab setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up the WARPLab experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nodes   = wl_initNodes(NUMNODES);   % Create a vector of node objects
node_rx_a = nodes(1);                 % RXer node WARP-a
node_rx_b = nodes(2);                 % RXer node WARP-b
node_rx_c = nodes(3);                 % RXer node WARP-c
node_rx_d = nodes(4);                 % RXer node WARP-d
node_rx_e = nodes(5);                 % RXer node WARP-e
node_rx_f = nodes(6);                 % RXer node WARP-f

% **********
% Triggers
% **********

% [Sergio] I'm not sure about how triggers work. For the moment, I just use
% the same UDP broadcast for the RXer and TXer.
% Create a UDP broadcast trigger and tell each node to be ready for it
eth_trig = wl_trigger_eth_udp_broadcast(NUMNODES);
eth_trig_rx_a = eth_trig(1);
eth_trig_rx_b = eth_trig(1);
eth_trig_rx_c = eth_trig(1);
eth_trig_rx_d = eth_trig(1);
eth_trig_rx_e = eth_trig(1);
eth_trig_rx_f = eth_trig(1);

wl_triggerManagerCmd(node_rx_a, 'add_ethernet_trigger', eth_trig_rx_a);
wl_triggerManagerCmd(node_rx_b, 'add_ethernet_trigger', eth_trig_rx_b);
wl_triggerManagerCmd(node_rx_c, 'add_ethernet_trigger', eth_trig_rx_c);
wl_triggerManagerCmd(node_rx_d, 'add_ethernet_trigger', eth_trig_rx_d);
wl_triggerManagerCmd(node_rx_e, 'add_ethernet_trigger', eth_trig_rx_e);
wl_triggerManagerCmd(node_rx_f, 'add_ethernet_trigger', eth_trig_rx_f);

% Read Trigger IDs into workspace
% [Sergio] I assume that it is the same to input node_rx or node_tx since
% they are the same type of WARP
trig_in_ids_rx_a  = wl_getTriggerInputIDs(node_rx_a);
trig_out_ids_rx_a = wl_getTriggerOutputIDs(node_rx_a);
trig_in_ids_rx_b  = wl_getTriggerInputIDs(node_rx_b);
trig_out_ids_rx_b = wl_getTriggerOutputIDs(node_rx_b);
trig_in_ids_rx_c  = wl_getTriggerInputIDs(node_rx_c);
trig_out_ids_rx_c = wl_getTriggerOutputIDs(node_rx_c);
trig_in_ids_rx_d  = wl_getTriggerInputIDs(node_rx_d);
trig_out_ids_rx_d = wl_getTriggerOutputIDs(node_rx_d);
trig_in_ids_rx_e  = wl_getTriggerInputIDs(node_rx_e);
trig_out_ids_rx_e = wl_getTriggerOutputIDs(node_rx_e);
trig_in_ids_rx_f = wl_getTriggerInputIDs(node_rx_f);
trig_out_ids_rx_f = wl_getTriggerOutputIDs(node_rx_f);

% For the three nodes, we will allow Ethernet to trigger the buffer baseband and the AGC
wl_triggerManagerCmd(node_rx_a, 'output_config_input_selection',...
    [trig_out_ids_rx_a.BASEBAND, trig_out_ids_rx_a.AGC], [trig_in_ids_rx_a.ETH_A]);
wl_triggerManagerCmd(node_rx_b, 'output_config_input_selection',...
    [trig_out_ids_rx_b.BASEBAND, trig_out_ids_rx_b.AGC], [trig_in_ids_rx_b.ETH_A]);
wl_triggerManagerCmd(node_rx_c, 'output_config_input_selection',...
    [trig_out_ids_rx_c.BASEBAND, trig_out_ids_rx_c.AGC], [trig_in_ids_rx_c.ETH_A]);
wl_triggerManagerCmd(node_rx_d, 'output_config_input_selection',...
    [trig_out_ids_rx_d.BASEBAND, trig_out_ids_rx_d.AGC], [trig_in_ids_rx_d.ETH_A]);
wl_triggerManagerCmd(node_rx_e, 'output_config_input_selection',...
    [trig_out_ids_rx_e.BASEBAND, trig_out_ids_rx_e.AGC], [trig_in_ids_rx_e.ETH_A]);
wl_triggerManagerCmd(node_rx_f, 'output_config_input_selection',...
    [trig_out_ids_rx_f.BASEBAND, trig_out_ids_rx_f.AGC], [trig_in_ids_rx_f.ETH_A]);

% Set the trigger output delays.
wl_triggerManagerCmd(node_rx_a,'output_config_delay', [trig_out_ids_rx_a.BASEBAND], 0);
wl_triggerManagerCmd(node_rx_b,'output_config_delay', [trig_out_ids_rx_b.BASEBAND], 0);
wl_triggerManagerCmd(node_rx_c,'output_config_delay', [trig_out_ids_rx_c.BASEBAND], 0);
wl_triggerManagerCmd(node_rx_d,'output_config_delay', [trig_out_ids_rx_d.BASEBAND], 0);
wl_triggerManagerCmd(node_rx_e,'output_config_delay', [trig_out_ids_rx_e.BASEBAND], 0);
wl_triggerManagerCmd(node_rx_f,'output_config_delay', [trig_out_ids_rx_f.BASEBAND], 0);

wl_triggerManagerCmd(node_rx_a,'output_config_delay', [trig_out_ids_rx_a.AGC], TRIGGER_OFFSET_TOL_NS);
wl_triggerManagerCmd(node_rx_b,'output_config_delay', [trig_out_ids_rx_b.AGC], TRIGGER_OFFSET_TOL_NS);
wl_triggerManagerCmd(node_rx_c,'output_config_delay', [trig_out_ids_rx_c.AGC], TRIGGER_OFFSET_TOL_NS);
wl_triggerManagerCmd(node_rx_d,'output_config_delay', [trig_out_ids_rx_d.AGC], TRIGGER_OFFSET_TOL_NS);
wl_triggerManagerCmd(node_rx_e,'output_config_delay', [trig_out_ids_rx_e.AGC], TRIGGER_OFFSET_TOL_NS);
wl_triggerManagerCmd(node_rx_f,'output_config_delay', [trig_out_ids_rx_f.AGC], TRIGGER_OFFSET_TOL_NS);

% *******
% Set interfaces
% *******

% Get IDs for the interfaces on the boards.
ifc_ids_RX_a = wl_getInterfaceIDs(node_rx_a);
ifc_ids_RX_b = wl_getInterfaceIDs(node_rx_b);
ifc_ids_RX_c = wl_getInterfaceIDs(node_rx_c);
ifc_ids_RX_d = wl_getInterfaceIDs(node_rx_d);
ifc_ids_RX_e = wl_getInterfaceIDs(node_rx_e);
ifc_ids_RX_f = wl_getInterfaceIDs(node_rx_f);

% Set up the TX / RX nodes and RF interfaces
ifc_ids_rx_a = wl_getInterfaceIDs(node_rx_a);
ifc_ids_rx_b = wl_getInterfaceIDs(node_rx_b);
ifc_ids_rx_c = wl_getInterfaceIDs(node_rx_c);
ifc_ids_rx_d = wl_getInterfaceIDs(node_rx_d);
ifc_ids_rx_e = wl_getInterfaceIDs(node_rx_e);
ifc_ids_rx_f = wl_getInterfaceIDs(node_rx_f);

% Set channel and band of RXers
wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_A, 'channel', BAND, RX_CHANNEL_A_a);
wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_B, 'channel', BAND, RX_CHANNEL_B_a);
wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_C, 'channel', BAND, RX_CHANNEL_C_a);
wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_D, 'channel', BAND, RX_CHANNEL_D_a);

wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_A, 'channel', BAND, RX_CHANNEL_A_b);
wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_B, 'channel', BAND, RX_CHANNEL_B_b);
wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_C, 'channel', BAND, RX_CHANNEL_C_b);
wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_D, 'channel', BAND, RX_CHANNEL_D_b);

wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_A, 'channel', BAND, RX_CHANNEL_A_c);
wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_B, 'channel', BAND, RX_CHANNEL_B_c);
wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_C, 'channel', BAND, RX_CHANNEL_C_c);
wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_D, 'channel', BAND, RX_CHANNEL_D_c);

wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_A, 'channel', BAND, RX_CHANNEL_A_d);
wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_B, 'channel', BAND, RX_CHANNEL_B_d);
wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_C, 'channel', BAND, RX_CHANNEL_C_d);
wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_D, 'channel', BAND, RX_CHANNEL_D_d);

wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_A, 'channel', BAND, RX_CHANNEL_A_e);
wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_B, 'channel', BAND, RX_CHANNEL_B_e);
wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_C, 'channel', BAND, RX_CHANNEL_C_e);
wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_D, 'channel', BAND, RX_CHANNEL_D_e);

wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_A, 'channel', BAND, RX_CHANNEL_A_f);
wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_B, 'channel', BAND, RX_CHANNEL_B_f);
wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_C, 'channel', BAND, RX_CHANNEL_C_f);
wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_D, 'channel', BAND, RX_CHANNEL_D_f);

% Set the TX and RX gains on all interfaces
wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_gain_mode', 'manual');
wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_gains', rx_gain_rf, rx_gain_bb);
wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_ALL, 'rx_gain_mode', 'manual');
wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_ALL, 'rx_gains', rx_gain_rf, rx_gain_bb);
wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_ALL, 'rx_gain_mode', 'manual');
wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_ALL, 'rx_gains', rx_gain_rf, rx_gain_bb);
wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_ALL, 'rx_gain_mode', 'manual');
wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_ALL, 'rx_gains', rx_gain_rf, rx_gain_bb);
wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_ALL, 'rx_gain_mode', 'manual');
wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_ALL, 'rx_gains', rx_gain_rf, rx_gain_bb);
wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_ALL, 'rx_gain_mode', 'manual');
wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_ALL, 'rx_gains', rx_gain_rf, rx_gain_bb);

% Get sampling rates
rx_samp_freq = wl_basebandCmd(node_rx_a, 'rx_buff_clk_freq');
ts_rx = 1 / rx_samp_freq;      % Sample duration at the RX buffer 25 ns (40 Msps)
ts_rssi = 1 / (wl_basebandCmd(node_rx_a, 'rx_rssi_clk_freq'));    % Sample duration at the RSSI buffer 100 ns (10 Msps)

% Get no. of RSSI samples
wl_basebandCmd(nodes, 'rx_length', num_rx_samples);   % Number of samples to receive

% ***************
% Experiment
% ***************
fprintf('Channel allocations:\n')
fprintf('- RXer a (WARP-a): RF_A = #%d, RF_B = #%d, RF_C = #%d, RF_D = #%d\n', ...
    RX_CHANNEL_AC_A_a, RX_CHANNEL_AC_B_a, RX_CHANNEL_AC_C_a, RX_CHANNEL_AC_D_a)
fprintf('- RXer b (WARP-b): RF_A = #%d, RF_B = #%d, RF_C = #%d, RF_D = #%d\n', ...
    RX_CHANNEL_AC_A_b, RX_CHANNEL_AC_B_b, RX_CHANNEL_AC_C_b, RX_CHANNEL_AC_D_b)
fprintf('- RXer c (WARP-c): RF_A = #%d, RF_B = #%d, RF_C = #%d, RF_D = #%d\n', ...
    RX_CHANNEL_AC_A_c, RX_CHANNEL_AC_B_c, RX_CHANNEL_AC_C_c, RX_CHANNEL_AC_D_c)
fprintf('- RXer d (WARP-d): RF_A = #%d, RF_B = #%d, RF_C = #%d, RF_D = #%d\n', ...
    RX_CHANNEL_AC_A_d, RX_CHANNEL_AC_B_d, RX_CHANNEL_AC_C_d, RX_CHANNEL_AC_D_d)
fprintf('- RXer e (WARP-e): RF_A = #%d, RF_B = #%d, RF_C = #%d, RF_D = #%d\n', ...
    RX_CHANNEL_AC_A_e, RX_CHANNEL_AC_B_e, RX_CHANNEL_AC_C_e, RX_CHANNEL_AC_D_e)
fprintf('- RXer f (WARP-f): RF_A = #%d, RF_B = #%d, RF_C = #%d, RF_D = #%d\n', ...
    RX_CHANNEL_AC_A_f, RX_CHANNEL_AC_B_f, RX_CHANNEL_AC_C_f, RX_CHANNEL_AC_D_f)

%% Sniffer action
dtime_start = datetime('now');
fprintf('Experiment started at %s\n', datestr(dtime_start,'HH:MM:SS.FFF'))
dtime_past = dtime_start;
dif_time = [];

if save_rssi || save_signals
    mkdir(path_output)
    path_general = [path_output '/experiment_general.mat'];
    fprintf('   + saving experiment general data in %s\n', path_general);
    save(path_general)
    diary(path_diary);
end

for it = 1:num_iterations
    fprintf('- Iteration #%d started at %s\n', it, datestr(now,'HH:MM:SS.FFF'))
    
    %% - Enable RXers
    % - Enable to node to receive data
    %wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_en');
    wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_en');
    wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_ALL, 'rx_en');
    wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_ALL, 'rx_en');
    wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_ALL, 'rx_en');
    wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_ALL, 'rx_en');
    wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_ALL, 'rx_en');
    % - Enable the buffers for RXers
    %wl_basebandCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_buff_en');
    wl_basebandCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_buff_en');
    wl_basebandCmd(node_rx_b, ifc_ids_rx_b.RF_ALL, 'rx_buff_en');
    wl_basebandCmd(node_rx_c, ifc_ids_rx_c.RF_ALL, 'rx_buff_en');
    wl_basebandCmd(node_rx_d, ifc_ids_rx_d.RF_ALL, 'rx_buff_en');
    wl_basebandCmd(node_rx_e, ifc_ids_rx_e.RF_ALL, 'rx_buff_en');
    wl_basebandCmd(node_rx_f, ifc_ids_rx_f.RF_ALL, 'rx_buff_en');
    
    % - Open up the transceiver's low-pass filter - maximum bandwidth (36MHz)
    % - Must be integer in [0,1,2,3] for approx ![7.5,9.5,14,18]MHz corner frequencies ([15,19,28,36]MHz bandwidths)
    %wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_lpf_corn_freq', rx_lpf_corn_freq);
    wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'rx_lpf_corn_freq', rx_lpf_corn_freq);
    wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_ALL, 'rx_lpf_corn_freq', rx_lpf_corn_freq);
    wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_ALL, 'rx_lpf_corn_freq', rx_lpf_corn_freq);
    wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_ALL, 'rx_lpf_corn_freq', rx_lpf_corn_freq);
    wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_ALL, 'rx_lpf_corn_freq', rx_lpf_corn_freq);
    wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_ALL, 'rx_lpf_corn_freq', rx_lpf_corn_freq);
    
    % Trigger the Tx/Rx cycle at both nodes
    eth_trig_rx_a.send();
    eth_trig_rx_b.send();
    eth_trig_rx_c.send();
    eth_trig_rx_d.send();
    eth_trig_rx_e.send();
    eth_trig_rx_f.send();
    
    %% - Get signals
    if get_signals
        % Retrieve the received waveform from the Rx node
        rx_vec_air_A_a = wl_basebandCmd(node_rx_a, ifc_ids_rx_a.RF_A, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_B_a = wl_basebandCmd(node_rx_a, ifc_ids_rx_a.RF_B, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_C_a = wl_basebandCmd(node_rx_a, ifc_ids_rx_a.RF_C, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_D_a = wl_basebandCmd(node_rx_a, ifc_ids_rx_a.RF_D, 'read_IQ', 0, num_rx_samples);
        
        rx_vec_air_A_b = wl_basebandCmd(node_rx_b, ifc_ids_rx_b.RF_A, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_B_b = wl_basebandCmd(node_rx_b, ifc_ids_rx_b.RF_B, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_C_b = wl_basebandCmd(node_rx_b, ifc_ids_rx_b.RF_C, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_D_b = wl_basebandCmd(node_rx_b, ifc_ids_rx_b.RF_D, 'read_IQ', 0, num_rx_samples);
        
        rx_vec_air_A_c = wl_basebandCmd(node_rx_c, ifc_ids_rx_c.RF_A, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_B_c = wl_basebandCmd(node_rx_c, ifc_ids_rx_c.RF_B, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_C_c = wl_basebandCmd(node_rx_c, ifc_ids_rx_c.RF_C, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_D_c = wl_basebandCmd(node_rx_c, ifc_ids_rx_c.RF_D, 'read_IQ', 0, num_rx_samples);
        
        rx_vec_air_A_d = wl_basebandCmd(node_rx_d, ifc_ids_rx_d.RF_A, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_B_d = wl_basebandCmd(node_rx_d, ifc_ids_rx_d.RF_B, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_C_d = wl_basebandCmd(node_rx_d, ifc_ids_rx_d.RF_C, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_D_d = wl_basebandCmd(node_rx_d, ifc_ids_rx_d.RF_D, 'read_IQ', 0, num_rx_samples);
        
        rx_vec_air_A_e = wl_basebandCmd(node_rx_e, ifc_ids_rx_e.RF_A, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_B_e = wl_basebandCmd(node_rx_e, ifc_ids_rx_e.RF_B, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_C_e = wl_basebandCmd(node_rx_e, ifc_ids_rx_e.RF_C, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_D_e = wl_basebandCmd(node_rx_e, ifc_ids_rx_e.RF_D, 'read_IQ', 0, num_rx_samples);
        
        rx_vec_air_A_f = wl_basebandCmd(node_rx_f, ifc_ids_rx_f.RF_A, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_B_f = wl_basebandCmd(node_rx_f, ifc_ids_rx_f.RF_B, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_C_f = wl_basebandCmd(node_rx_f, ifc_ids_rx_f.RF_C, 'read_IQ', 0, num_rx_samples);
        rx_vec_air_D_f = wl_basebandCmd(node_rx_f, ifc_ids_rx_f.RF_D, 'read_IQ', 0, num_rx_samples);
        
        rx_vec_air_temporal_A_a = [rx_vec_air_temporal_A_a; rx_vec_air_A_a];
        rx_vec_air_temporal_B_a = [rx_vec_air_temporal_B_a; rx_vec_air_B_a];
        rx_vec_air_temporal_C_a = [rx_vec_air_temporal_C_a; rx_vec_air_C_a];
        rx_vec_air_temporal_D_a = [rx_vec_air_temporal_D_a; rx_vec_air_D_a];
        
        rx_vec_air_temporal_A_b = [rx_vec_air_temporal_A_b; rx_vec_air_A_b];
        rx_vec_air_temporal_B_b = [rx_vec_air_temporal_B_b; rx_vec_air_B_b];
        rx_vec_air_temporal_C_b = [rx_vec_air_temporal_C_b; rx_vec_air_C_b];
        rx_vec_air_temporal_D_b = [rx_vec_air_temporal_D_b; rx_vec_air_D_b];
        
        rx_vec_air_temporal_A_c = [rx_vec_air_temporal_A_c; rx_vec_air_A_c];
        rx_vec_air_temporal_B_c = [rx_vec_air_temporal_B_c; rx_vec_air_B_c];
        rx_vec_air_temporal_C_c = [rx_vec_air_temporal_C_c; rx_vec_air_C_c];
        rx_vec_air_temporal_D_c = [rx_vec_air_temporal_D_c; rx_vec_air_D_c];
        
        rx_vec_air_temporal_A_d = [rx_vec_air_temporal_A_d; rx_vec_air_A_d];
        rx_vec_air_temporal_B_d = [rx_vec_air_temporal_B_d; rx_vec_air_B_d];
        rx_vec_air_temporal_C_d = [rx_vec_air_temporal_C_d; rx_vec_air_C_d];
        rx_vec_air_temporal_D_d = [rx_vec_air_temporal_D_d; rx_vec_air_D_d];
        
        rx_vec_air_temporal_A_e = [rx_vec_air_temporal_A_e; rx_vec_air_A_e];
        rx_vec_air_temporal_B_e = [rx_vec_air_temporal_B_e; rx_vec_air_B_e];
        rx_vec_air_temporal_C_e = [rx_vec_air_temporal_C_e; rx_vec_air_C_e];
        rx_vec_air_temporal_D_e = [rx_vec_air_temporal_D_e; rx_vec_air_D_e];
        
        rx_vec_air_temporal_A_f = [rx_vec_air_temporal_A_f; rx_vec_air_A_f];
        rx_vec_air_temporal_B_f = [rx_vec_air_temporal_B_f; rx_vec_air_B_f];
        rx_vec_air_temporal_C_f = [rx_vec_air_temporal_C_f; rx_vec_air_C_f];
        rx_vec_air_temporal_D_f = [rx_vec_air_temporal_D_f; rx_vec_air_D_f];
        
    end
    
    %% - Get RSSI
    if get_rssi
        rx_RSSI_A_a = wl_basebandCmd(node_rx_a, ifc_ids_RX_a.RF_A, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_B_a = wl_basebandCmd(node_rx_a, ifc_ids_RX_a.RF_B, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_C_a = wl_basebandCmd(node_rx_a, ifc_ids_RX_a.RF_C, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_D_a = wl_basebandCmd(node_rx_a, ifc_ids_RX_a.RF_D, 'read_RSSI', 0, num_rssi_samples);
        
        rx_RSSI_A_b = wl_basebandCmd(node_rx_b, ifc_ids_RX_b.RF_A, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_B_b = wl_basebandCmd(node_rx_b, ifc_ids_RX_b.RF_B, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_C_b = wl_basebandCmd(node_rx_b, ifc_ids_RX_b.RF_C, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_D_b = wl_basebandCmd(node_rx_b, ifc_ids_RX_b.RF_D, 'read_RSSI', 0, num_rssi_samples);
        
        rx_RSSI_A_c = wl_basebandCmd(node_rx_c, ifc_ids_RX_c.RF_A, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_B_c = wl_basebandCmd(node_rx_c, ifc_ids_RX_c.RF_B, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_C_c = wl_basebandCmd(node_rx_c, ifc_ids_RX_c.RF_C, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_D_c = wl_basebandCmd(node_rx_c, ifc_ids_RX_c.RF_D, 'read_RSSI', 0, num_rssi_samples);
        
        rx_RSSI_A_d = wl_basebandCmd(node_rx_d, ifc_ids_RX_d.RF_A, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_B_d = wl_basebandCmd(node_rx_d, ifc_ids_RX_d.RF_B, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_C_d = wl_basebandCmd(node_rx_d, ifc_ids_RX_d.RF_C, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_D_d = wl_basebandCmd(node_rx_d, ifc_ids_RX_d.RF_D, 'read_RSSI', 0, num_rssi_samples);
        
        rx_RSSI_A_e = wl_basebandCmd(node_rx_e, ifc_ids_RX_e.RF_A, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_B_e = wl_basebandCmd(node_rx_e, ifc_ids_RX_e.RF_B, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_C_e = wl_basebandCmd(node_rx_e, ifc_ids_RX_e.RF_C, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_D_e = wl_basebandCmd(node_rx_e, ifc_ids_RX_e.RF_D, 'read_RSSI', 0, num_rssi_samples);
        
        rx_RSSI_A_f = wl_basebandCmd(node_rx_f, ifc_ids_RX_f.RF_A, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_B_f = wl_basebandCmd(node_rx_f, ifc_ids_RX_f.RF_B, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_C_f = wl_basebandCmd(node_rx_f, ifc_ids_RX_f.RF_C, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_D_f = wl_basebandCmd(node_rx_f, ifc_ids_RX_f.RF_D, 'read_RSSI', 0, num_rssi_samples);
        
        rx_RSSI_A_a = wl_basebandCmd(node_rx_a, ifc_ids_RX_a.RF_A, 'read_RSSI', 0, num_rssi_samples);
        rx_RSSI_B_a = wl_basebandCmd(node_rx_a, ifc_ids_RX_a.RF_B, 'read_RSSI', 0, num_rssi_samples);
               
        rssi_temporal_A_a = [rssi_temporal_A_a; downsample(rx_RSSI_A_a,downsample_factor_rssi)];
        rssi_temporal_B_a = [rssi_temporal_B_a; downsample(rx_RSSI_B_a,downsample_factor_rssi)];
        rssi_temporal_C_a = [rssi_temporal_C_a; downsample(rx_RSSI_C_a,downsample_factor_rssi)];
        rssi_temporal_D_a = [rssi_temporal_D_a; downsample(rx_RSSI_D_a,downsample_factor_rssi)];
        
        rssi_temporal_A_b = [rssi_temporal_A_b; downsample(rx_RSSI_A_b,downsample_factor_rssi)];
        rssi_temporal_B_b = [rssi_temporal_B_b; downsample(rx_RSSI_B_b,downsample_factor_rssi)];
        rssi_temporal_C_b = [rssi_temporal_C_b; downsample(rx_RSSI_C_b,downsample_factor_rssi)];
        %         rssi_temporal_C_b = [rssi_temporal_C_b; ...
        %             (nanmean(reshape([rx_RSSI_C_b; nan(mod(-numel(rx_RSSI_C_b),downsample_factor_rssi),1)],downsample_factor_rssi,[])))'];
        
        rssi_temporal_D_b = [rssi_temporal_D_b; downsample(rx_RSSI_D_b,downsample_factor_rssi)];
        
        rssi_temporal_A_c = [rssi_temporal_A_c; downsample(rx_RSSI_A_c,downsample_factor_rssi)];
        rssi_temporal_B_c = [rssi_temporal_B_c; downsample(rx_RSSI_B_c,downsample_factor_rssi)];
        rssi_temporal_C_c = [rssi_temporal_C_c; downsample(rx_RSSI_C_c,downsample_factor_rssi)];
        rssi_temporal_D_c = [rssi_temporal_D_c; downsample(rx_RSSI_D_c,downsample_factor_rssi)];
        
        rssi_temporal_A_d = [rssi_temporal_A_d; downsample(rx_RSSI_A_d,downsample_factor_rssi)];
        rssi_temporal_B_d = [rssi_temporal_B_d; downsample(rx_RSSI_B_d,downsample_factor_rssi)];
        rssi_temporal_C_d = [rssi_temporal_C_d; downsample(rx_RSSI_C_d,downsample_factor_rssi)];
        rssi_temporal_D_d = [rssi_temporal_D_d; downsample(rx_RSSI_D_d,downsample_factor_rssi)];
        
        rssi_temporal_A_e = [rssi_temporal_A_e; downsample(rx_RSSI_A_e,downsample_factor_rssi)];
        rssi_temporal_B_e = [rssi_temporal_B_e; downsample(rx_RSSI_B_e,downsample_factor_rssi)];
        rssi_temporal_C_e = [rssi_temporal_C_e; downsample(rx_RSSI_C_e,downsample_factor_rssi)];
        rssi_temporal_D_e = [rssi_temporal_D_e; downsample(rx_RSSI_D_e,downsample_factor_rssi)];
        
        rssi_temporal_A_f = [rssi_temporal_A_f; downsample(rx_RSSI_A_f,downsample_factor_rssi)];
        rssi_temporal_B_f = [rssi_temporal_B_f; downsample(rx_RSSI_B_f,downsample_factor_rssi)];
        rssi_temporal_C_f = [rssi_temporal_C_f; downsample(rx_RSSI_C_f,downsample_factor_rssi)];
        rssi_temporal_D_f = [rssi_temporal_D_f; downsample(rx_RSSI_D_f,downsample_factor_rssi)];

        if save_rssi
            % Save raw RSSI samples
            path_iteration = [path_output '/it' num2str(it, '%04d') '_' datestr(dtime_past,formatOut) '.mat'];
            fprintf('   + saving RSSI in %s\n',path_iteration);
            save(path_iteration,...
                'rssi_temporal_A_a','rssi_temporal_B_a', 'rssi_temporal_C_a','rssi_temporal_D_a',...
                'rssi_temporal_A_b','rssi_temporal_B_b', 'rssi_temporal_C_b','rssi_temporal_D_b',...
                'rssi_temporal_A_c','rssi_temporal_B_c', 'rssi_temporal_C_c','rssi_temporal_D_c',...
                'rssi_temporal_A_d','rssi_temporal_B_d', 'rssi_temporal_C_d','rssi_temporal_D_d',...
                'rssi_temporal_A_e','rssi_temporal_B_e', 'rssi_temporal_C_e','rssi_temporal_D_e',...
                'rssi_temporal_A_f','rssi_temporal_B_f', 'rssi_temporal_C_f','rssi_temporal_D_f')
        end
        
        if clear_rssi
            rssi_temporal_A_a = [];
            rssi_temporal_B_a = [];
            rssi_temporal_C_a = [];
            rssi_temporal_D_a = [];
            
            rssi_temporal_A_b = [];
            rssi_temporal_B_b = [];
            rssi_temporal_C_b = [];
            rssi_temporal_D_b = [];
            
            rssi_temporal_A_c = [];
            rssi_temporal_B_c = [];
            rssi_temporal_C_c = [];
            rssi_temporal_D_c = [];
            
            rssi_temporal_A_d = [];
            rssi_temporal_B_d = [];
            rssi_temporal_C_d = [];
            rssi_temporal_D_d = [];
            
            rssi_temporal_A_e = [];
            rssi_temporal_B_e = [];
            rssi_temporal_C_e = [];
            rssi_temporal_D_e = [];
            
            rssi_temporal_A_f = [];
            rssi_temporal_B_f = [];
            rssi_temporal_C_f = [];
            rssi_temporal_D_f = [];
        end
        
        av_rssi_A_a = mean(rx_RSSI_A_a);
        av_rssi_B_a = mean(rx_RSSI_B_a);
        av_rssi_C_a = mean(rx_RSSI_C_a);
        av_rssi_D_a = mean(rx_RSSI_D_a);
        
        av_rssi_A_b = mean(rx_RSSI_A_b);
        av_rssi_B_b = mean(rx_RSSI_B_b);
        av_rssi_C_b = mean(rx_RSSI_C_b);
        av_rssi_D_b = mean(rx_RSSI_D_b);
        
        av_rssi_A_c = mean(rx_RSSI_A_c);
        av_rssi_B_c = mean(rx_RSSI_B_c);
        av_rssi_C_c = mean(rx_RSSI_C_c);
        av_rssi_D_c = mean(rx_RSSI_D_c);
        
        av_rssi_A_d = mean(rx_RSSI_A_d);
        av_rssi_B_d = mean(rx_RSSI_B_d);
        av_rssi_C_d = mean(rx_RSSI_C_d);
        av_rssi_D_d = mean(rx_RSSI_D_d);
        
        av_rssi_A_e = mean(rx_RSSI_A_e);
        av_rssi_B_e = mean(rx_RSSI_B_e);
        av_rssi_C_e = mean(rx_RSSI_C_e);
        av_rssi_D_e = mean(rx_RSSI_D_e);
        
        av_rssi_A_f = mean(rx_RSSI_A_f);
        av_rssi_B_f = mean(rx_RSSI_B_f);
        av_rssi_C_f = mean(rx_RSSI_C_f);
        av_rssi_D_f = mean(rx_RSSI_D_f);
        
    end
    
    %% - Disable RXers
    % Disable the Tx/Rx radios and buffers
    wl_basebandCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'tx_rx_buff_dis');
    wl_basebandCmd(node_rx_b, ifc_ids_rx_b.RF_ALL, 'tx_rx_buff_dis');
    wl_basebandCmd(node_rx_c, ifc_ids_rx_c.RF_ALL, 'tx_rx_buff_dis');
    wl_basebandCmd(node_rx_d, ifc_ids_rx_d.RF_ALL, 'tx_rx_buff_dis');
    wl_basebandCmd(node_rx_e, ifc_ids_rx_e.RF_ALL, 'tx_rx_buff_dis');
    wl_basebandCmd(node_rx_f, ifc_ids_rx_f.RF_ALL, 'tx_rx_buff_dis');
    
    wl_interfaceCmd(node_rx_a, ifc_ids_rx_a.RF_ALL, 'tx_rx_dis');
    wl_interfaceCmd(node_rx_b, ifc_ids_rx_b.RF_ALL, 'tx_rx_dis');
    wl_interfaceCmd(node_rx_c, ifc_ids_rx_c.RF_ALL, 'tx_rx_dis');
    wl_interfaceCmd(node_rx_d, ifc_ids_rx_d.RF_ALL, 'tx_rx_dis');
    wl_interfaceCmd(node_rx_e, ifc_ids_rx_e.RF_ALL, 'tx_rx_dis');
    wl_interfaceCmd(node_rx_f, ifc_ids_rx_f.RF_ALL, 'tx_rx_dis');
    
    dtime = datetime('now');
    dif_time = [dif_time milliseconds(dtime-dtime_past)];
    dtime_past = dtime;
end

dtime_finsih = datetime('now');
fprintf('Experiment finished at %s\n', datestr(datetime,'HH:MM:SS.FFF'))

fprintf('Sniffing times: \n')
fprintf(' - Experiment duration: %.3f s\n', seconds(dtime_finsih-dtime_start));
fprintf(' - Average duration of an iteration (full band sniff): %.0f ms\n', mean(dif_time));
fprintf(' - Frequency iterations: %.2f/s\n', 1/(mean(dif_time)*1E-3));
fprintf(' - Max. iteration duration: %.0f ms\n', max(dif_time))


%% Results and plots
rssi_temporal_dBm_A_a = rssi_to_dBm(rssi_temporal_A_a, rx_gain_rf);
rssi_temporal_dBm_B_a = rssi_to_dBm(rssi_temporal_B_a, rx_gain_rf);
rssi_temporal_dBm_C_a = rssi_to_dBm(rssi_temporal_C_a, rx_gain_rf);
rssi_temporal_dBm_D_a = rssi_to_dBm(rssi_temporal_D_a, rx_gain_rf);

rssi_temporal_dBm_A_b = rssi_to_dBm(rssi_temporal_A_b, rx_gain_rf);
rssi_temporal_dBm_B_b = rssi_to_dBm(rssi_temporal_B_b, rx_gain_rf);
rssi_temporal_dBm_C_b = rssi_to_dBm(rssi_temporal_C_b, rx_gain_rf);
rssi_temporal_dBm_D_b = rssi_to_dBm(rssi_temporal_D_b, rx_gain_rf);

rssi_temporal_dBm_A_c = rssi_to_dBm(rssi_temporal_A_c, rx_gain_rf);
rssi_temporal_dBm_B_c = rssi_to_dBm(rssi_temporal_B_c, rx_gain_rf);
rssi_temporal_dBm_C_c = rssi_to_dBm(rssi_temporal_C_c, rx_gain_rf);
rssi_temporal_dBm_D_c = rssi_to_dBm(rssi_temporal_D_c, rx_gain_rf);

rssi_temporal_dBm_A_d = rssi_to_dBm(rssi_temporal_A_d, rx_gain_rf);
rssi_temporal_dBm_B_d = rssi_to_dBm(rssi_temporal_B_d, rx_gain_rf);
rssi_temporal_dBm_C_d = rssi_to_dBm(rssi_temporal_C_d, rx_gain_rf);
rssi_temporal_dBm_D_d = rssi_to_dBm(rssi_temporal_D_d, rx_gain_rf);

rssi_temporal_dBm_A_e = rssi_to_dBm(rssi_temporal_A_e, rx_gain_rf);
rssi_temporal_dBm_B_e = rssi_to_dBm(rssi_temporal_B_e, rx_gain_rf);
rssi_temporal_dBm_C_e = rssi_to_dBm(rssi_temporal_C_e, rx_gain_rf);
rssi_temporal_dBm_D_e = rssi_to_dBm(rssi_temporal_D_e, rx_gain_rf);

rssi_temporal_dBm_A_f = rssi_to_dBm(rssi_temporal_A_f, rx_gain_rf);
rssi_temporal_dBm_B_f = rssi_to_dBm(rssi_temporal_B_f, rx_gain_rf);
rssi_temporal_dBm_C_f = rssi_to_dBm(rssi_temporal_C_f, rx_gain_rf);
rssi_temporal_dBm_D_f = rssi_to_dBm(rssi_temporal_D_f, rx_gain_rf);

% rssi_temporal_dBm_B_f_down = rssi_to_dBm(rssi_temporal_B_f_down, rx_gain_rf);
% rssi_temporal_dBm_B_f_redown = rssi_to_dBm(rssi_temporal_B_f_redown, rx_gain_rf);

%% - Plot signals
if plot_signals
    
    figure
    % a
    subplot(24,2,1)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_A_a))
    ylabel('a-A')
    title('Amplitude')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,2)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_a)
    ylim([-100 -40])
    title('RSSI [dBm]')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,3)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_B_a))
    ylabel('a-B')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,4)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_a)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,5)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_C_a))
    ylabel('a-C')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,6)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_a)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,7)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_D_a))
    ylabel('a-D')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,8)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_a)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % b
    subplot(24,2,9)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_A_b))
    ylabel('b-A')
    grid on
    
    subplot(24,2,10)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_b)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,11)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_B_b))
    ylabel('b-B')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,12)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_b)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,13)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_C_b))
    ylabel('b-C')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,14)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_b)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,15)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_D_b))
    ylabel('b-D')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,16)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_b)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % c
    subplot(24,2,17)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_A_c))
    ylabel('c-A')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,18)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_c)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,19)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_B_c))
    ylabel('c-B')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,20)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_c)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,21)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_C_c))
    ylabel('c-C')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,22)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_c)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,23)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_D_c))
    ylabel('c-D')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,24)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_c)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % d
    subplot(24,2,25)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_A_d))
    ylabel('d-A')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,26)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_d)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,27)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_B_d))
    ylabel('d-B')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,28)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_d)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,29)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_C_d))
    ylabel('d-C')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,30)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_d)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,31)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_D_d))
    ylabel('d-D')
    grid on
    
    subplot(24,2,32)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_d)
    ylim([-100 -40])
    grid on
    
    % e
    subplot(24,2,33)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_A_e))
    ylabel('e-A')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,34)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_e)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,35)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_B_e))
    ylabel('e-B')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,36)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_e)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,37)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_C_e))
    ylabel('e-C')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,38)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_e)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,39)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_D_e))
    ylabel('e-D')
    grid on
    
    subplot(24,2,40)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_e)
    ylim([-100 -40])
    grid on
    
    % f
    subplot(24,2,41)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_A_f))
    ylabel('f-A')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,42)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_f)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,43)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_B_f))
    ylabel('f-B')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,44)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_f)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,45)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_C_f))
    ylabel('f-C')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,46)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_f)
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,2,47)
    plot(ts_rx*1e3.*(1:num_rx_samples*num_iterations),real(rx_vec_air_temporal_D_f))
    xlabel('time [ms]')
    ylabel('f-D')
    grid on
    
    subplot(24,2,48)
    plot(ts_rssi*1e3.*(1:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_f)
    ylim([-100 -40])
    xlabel('time [ms]')
    grid on
    
end

%% - Plot RSSI [dBm]
if plot_rssi
    
    fprintf('Plotting RSSI...\n')
    
    % Plot just RSSI
    figure
    % a
    subplot(24,1,1)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_a)
    ylim([-100 -40])
    ylabel({'a-A';['#' num2str(RX_CHANNEL_AC_A_a)]})
    title('RSSI [dBm]')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,2)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_a)
    ylabel({'a-B';['#' num2str(RX_CHANNEL_AC_B_a)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,3)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_a)
    ylabel({'a-C';['#' num2str(RX_CHANNEL_AC_C_a)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,4)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_a)
    ylabel({'a-D';['#' num2str(RX_CHANNEL_AC_D_a)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % b
    subplot(24,1,5)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_b)
    ylabel({'b-A';['#' num2str(RX_CHANNEL_AC_A_b)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,6)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_b)
    ylim([-100 -40])
    ylabel({'b-B';['#' num2str(RX_CHANNEL_AC_B_b)]})
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,7)
    plot(ts_rssi*1e3.*(1:num_rssi_samples/downsample_factor_rssi*num_iterations),rssi_temporal_dBm_C_b)
    ylabel({'b-C';['#' num2str(RX_CHANNEL_AC_C_b)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,8)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_b)
    ylabel({'b-D';['#' num2str(RX_CHANNEL_AC_D_b)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % c
    subplot(24,1,9)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_c)
    ylabel({'c-A';['#' num2str(RX_CHANNEL_AC_A_c)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,10)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_c)
    ylabel({'c-B';['#' num2str(RX_CHANNEL_AC_B_c)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,11)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_c)
    ylabel({'c-C';['#' num2str(RX_CHANNEL_AC_C_c)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,12)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_c)
    ylabel({'c-D';['#' num2str(RX_CHANNEL_AC_D_c)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % d
    subplot(24,1,13)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_d)
    ylabel({'d-A';['#' num2str(RX_CHANNEL_AC_A_d)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,14)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_d)
    ylabel({'d-B';['#' num2str(RX_CHANNEL_AC_B_d)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,15)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_d)
    ylabel({'d-C';['#' num2str(RX_CHANNEL_AC_C_d)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,16)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_d)
    ylabel({'d-D';['#' num2str(RX_CHANNEL_AC_D_d)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % e
    subplot(24,1,17)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_e)
    ylabel({'e-A';['#' num2str(RX_CHANNEL_AC_A_e)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,18)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_e)
    ylabel({'e-B';['#' num2str(RX_CHANNEL_AC_B_e)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,19)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_e)
    ylabel({'e-C';['#' num2str(RX_CHANNEL_AC_C_e)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,20)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_e)
    ylabel({'e-D';['#' num2str(RX_CHANNEL_AC_D_e)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    % f
    subplot(24,1,21)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_A_f)
    ylabel({'f-A';['#' num2str(RX_CHANNEL_AC_A_f)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,22)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_f)
    ylabel({'f-B';['#' num2str(RX_CHANNEL_AC_B_f)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,23)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_C_f)
    ylabel({'f-C';['#' num2str(RX_CHANNEL_AC_C_f)]})
    ylim([-100 -40])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,24)
    plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_D_f)
    ylabel({'f-D';['#' num2str(RX_CHANNEL_AC_D_f)]})
    ylim([-100 -40])
    xlabel('time [ms]')
    grid on
    
end

%% - Plot RSSI [1024]
xaxis = ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations);

if plot_rssi_1024
    
    fprintf('Plotting RSSI in 1024 format...\n')
    
    % Plot just RSSI
    figure
    % a
    subplot(24,1,1)
    plot(xaxis,rssi_temporal_A_a)
    ylim([0 plot_rssi_1024_max_ylim])
    ylabel({'a-A';['#' num2str(RX_CHANNEL_AC_A_a)]})
    title('RSSI [1024]')
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,2)
    plot(xaxis,rssi_temporal_B_a)
    ylabel({'a-B';['#' num2str(RX_CHANNEL_AC_B_a)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,3)
    plot(xaxis,rssi_temporal_C_a)
    ylabel({'a-C';['#' num2str(RX_CHANNEL_AC_C_a)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,4)
    plot(xaxis,rssi_temporal_D_a)
    ylabel({'a-D';['#' num2str(RX_CHANNEL_AC_D_a)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    % b
    subplot(24,1,5)
    plot(xaxis,rssi_temporal_A_b)
    ylabel({'b-A';['#' num2str(RX_CHANNEL_AC_A_b)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,6)
    plot(xaxis,rssi_temporal_B_b)
    ylim([0 plot_rssi_1024_max_ylim])
    ylabel({'b-B';['#' num2str(RX_CHANNEL_AC_B_b)]})
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,7)
    plot(xaxis,rssi_temporal_C_b)
    ylabel({'b-C';['#' num2str(RX_CHANNEL_AC_C_b)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,8)
    plot(xaxis,rssi_temporal_D_b)
    ylabel({'b-D';['#' num2str(RX_CHANNEL_AC_D_b)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    % c
    subplot(24,1,9)
    plot(xaxis,rssi_temporal_A_c)
    ylabel({'c-A';['#' num2str(RX_CHANNEL_AC_A_c)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,10)
    plot(xaxis,rssi_temporal_B_c)
    ylabel({'c-B';['#' num2str(RX_CHANNEL_AC_B_c)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,11)
    plot(xaxis,rssi_temporal_C_c)
    ylabel({'c-C';['#' num2str(RX_CHANNEL_AC_C_c)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,12)
    plot(xaxis,rssi_temporal_D_c)
    ylabel({'c-D';['#' num2str(RX_CHANNEL_AC_D_c)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    % d
    subplot(24,1,13)
    plot(xaxis,rssi_temporal_A_d)
    ylabel({'d-A';['#' num2str(RX_CHANNEL_AC_A_d)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,14)
    plot(xaxis,rssi_temporal_B_d)
    ylabel({'d-B';['#' num2str(RX_CHANNEL_AC_B_d)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,15)
    plot(xaxis,rssi_temporal_C_d)
    ylabel({'d-C';['#' num2str(RX_CHANNEL_AC_C_d)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,16)
    plot(xaxis,rssi_temporal_D_d)
    ylabel({'d-D';['#' num2str(RX_CHANNEL_AC_D_d)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    % e
    subplot(24,1,17)
    plot(xaxis,rssi_temporal_A_e)
    ylabel({'e-A';['#' num2str(RX_CHANNEL_AC_A_e)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,18)
    plot(xaxis,rssi_temporal_B_e)
    ylabel({'e-B';['#' num2str(RX_CHANNEL_AC_B_e)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,19)
    plot(xaxis,rssi_temporal_C_e)
    ylabel({'e-C';['#' num2str(RX_CHANNEL_AC_C_e)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,20)
    plot(xaxis,rssi_temporal_D_e)
    ylabel({'e-D';['#' num2str(RX_CHANNEL_AC_D_e)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    % f
    subplot(24,1,21)
    plot(xaxis,rssi_temporal_A_f)
    ylabel({'f-A';['#' num2str(RX_CHANNEL_AC_A_f)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,22)
    plot(xaxis,rssi_temporal_B_f)
    ylabel({'f-B';['#' num2str(RX_CHANNEL_AC_B_f)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,23)
    plot(xaxis,rssi_temporal_C_f)
    ylabel({'f-C';['#' num2str(RX_CHANNEL_AC_C_f)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    set(gca,'xticklabel',{[]})
    
    subplot(24,1,24)
    plot(xaxis,rssi_temporal_D_f)
    ylabel({'f-D';['#' num2str(RX_CHANNEL_AC_D_f)]})
    ylim([0 plot_rssi_1024_max_ylim])
    grid on
    xlabel('time [ms]')
end

% figure
% plot(xaxis,rssi_temporal_C_b)
% ylabel({'b-C';['#' num2str(RX_CHANNEL_AC_C_b)]})
% ylim([0 plot_rssi_1024_max_ylim])
% grid on
% xlabel('time [ms]')
%
% figure
% plot(xaxis,rssi_temporal_C_d)
% ylabel({'d-C';['#' num2str(RX_CHANNEL_AC_C_d)]})
% ylim([0 plot_rssi_1024_max_ylim])
% grid on
% xlabel('time [ms]')

% figure
% title('RSSI [1024]')
% subplot(3,1,1)
%
% plot(ts_rssi*1e3.*(1:downsample_factor_rssi:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_f)
% ylabel({['f-B #' num2str(RX_CHANNEL_AC_B_f)]; ' 100 ns'})
% ylim([-100 -40])
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(3,1,2)
% plot(ts_rssi*1e3.*(1:10:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_f_down)
% ylabel({['f-B #' num2str(RX_CHANNEL_AC_B_f)]; ' 1 us'})
% ylim([-100 -40])
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(3,1,3)
% plot(ts_rssi*1e3.*(1:100:num_rssi_samples*num_iterations),rssi_temporal_dBm_B_f_redown)
% ylabel({['f-B #' num2str(RX_CHANNEL_AC_B_f)]; ' 10 us'})
% ylim([-100 -40])
% grid on
% xlabel('time [ms]')



%% -------------
% Plot just RSSI

% % a
% figure
% subplot(4,1,1)
% plot(xaxis,rssi_temporal_A_a)
% ylim([0 300])
% ylabel({'a-A';['#' num2str(RX_CHANNEL_AC_A_a)]})
% title('RSSI [1024]')
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(4,1,2)
% plot(xaxis,rssi_temporal_B_a)
% ylabel({'a-B';['#' num2str(RX_CHANNEL_AC_B_a)]})
% ylim([0 300])
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(4,1,3)
% plot(xaxis,rssi_temporal_C_a)
% ylabel({'a-C';['#' num2str(RX_CHANNEL_AC_C_a)]})
% ylim([0 300])
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(4,1,4)
% plot(xaxis,rssi_temporal_D_a)
% ylabel({'a-D';['#' num2str(RX_CHANNEL_AC_D_a)]})
% ylim([0 300])
% grid on
% set(gca,'xticklabel',{[]})
%
% % b
% figure
% subplot(4,1,1)
% plot(xaxis,rssi_temporal_A_b)
% ylabel({'b-A';['#' num2str(RX_CHANNEL_AC_A_b)]})
% ylim([0 300])
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(4,1,2)
% plot(xaxis,rssi_temporal_B_b)
% ylim([0 300])
% ylabel({'b-B';['#' num2str(RX_CHANNEL_AC_B_b)]})
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(4,1,3)
% plot(xaxis,rssi_temporal_C_b)
% ylabel({'b-C';['#' num2str(RX_CHANNEL_AC_C_b)]})
% ylim([0 300])
% grid on
% set(gca,'xticklabel',{[]})
%
% subplot(4,1,4)
% plot(xaxis,rssi_temporal_D_b)
% ylabel({'b-D';['#' num2str(RX_CHANNEL_AC_D_b)]})
% ylim([0 300])
% grid on
% set(gca,'xticklabel',{[]})

%% -------------

%% - Plot Av. RSSI [dBm]
av_rssi_ch_dbm = rssi_to_dBm([av_rssi_A_a av_rssi_B_a av_rssi_C_a av_rssi_D_a...
    av_rssi_A_b av_rssi_B_b av_rssi_C_b av_rssi_D_b...
    av_rssi_A_c av_rssi_B_c av_rssi_C_c av_rssi_D_c...
    av_rssi_A_d av_rssi_B_d av_rssi_C_d av_rssi_D_d...
    av_rssi_A_e av_rssi_B_e av_rssi_C_e av_rssi_D_e...
    av_rssi_A_f av_rssi_B_f av_rssi_C_f av_rssi_D_f], rx_gain_rf);

if plot_av_rssi
    
    figure
    subplot(2,1,1)
    h = bar(av_rssi_ch_dbm);
    xlabel('Channel #')
    xticks(1:24)
    xticklabels([RX_CHANNEL_AC_A_a RX_CHANNEL_AC_B_a RX_CHANNEL_AC_C_a RX_CHANNEL_AC_D_a...
        RX_CHANNEL_AC_A_b RX_CHANNEL_AC_B_b RX_CHANNEL_AC_C_b RX_CHANNEL_AC_D_b...
        RX_CHANNEL_AC_A_c RX_CHANNEL_AC_B_c RX_CHANNEL_AC_C_c RX_CHANNEL_AC_D_c...
        RX_CHANNEL_AC_A_d RX_CHANNEL_AC_B_d RX_CHANNEL_AC_C_d RX_CHANNEL_AC_D_d...
        RX_CHANNEL_AC_A_e RX_CHANNEL_AC_B_e RX_CHANNEL_AC_C_e RX_CHANNEL_AC_D_e...
        RX_CHANNEL_AC_A_f RX_CHANNEL_AC_B_f RX_CHANNEL_AC_C_f RX_CHANNEL_AC_D_f])
    title(['RSSI per channel'])
    grid on
    ylabel('RSSI [dBm]')
    ylim([-100 -30])
    
    subplot(2,1,2)
    h = bar([av_rssi_A_a av_rssi_B_a av_rssi_C_a av_rssi_D_a...
        av_rssi_A_b av_rssi_B_b av_rssi_C_b av_rssi_D_b...
        av_rssi_A_c av_rssi_B_c av_rssi_C_c av_rssi_D_c...
        av_rssi_A_d av_rssi_B_d av_rssi_C_d av_rssi_D_d...
        av_rssi_A_d av_rssi_B_d av_rssi_C_d av_rssi_D_e...
        av_rssi_A_d av_rssi_B_d av_rssi_C_d av_rssi_D_f]);
    ylim([0 1024])
    grid on
    ylabel('RSSI [1024-val]')
    xlabel('Channel #')
    xticks(1:24)
    xticklabels([RX_CHANNEL_AC_A_a RX_CHANNEL_AC_B_a RX_CHANNEL_AC_C_a RX_CHANNEL_AC_D_a...
        RX_CHANNEL_AC_A_b RX_CHANNEL_AC_B_b RX_CHANNEL_AC_C_b RX_CHANNEL_AC_D_b...
        RX_CHANNEL_AC_A_c RX_CHANNEL_AC_B_c RX_CHANNEL_AC_C_c RX_CHANNEL_AC_D_c...
        RX_CHANNEL_AC_A_d RX_CHANNEL_AC_B_d RX_CHANNEL_AC_C_d RX_CHANNEL_AC_D_d...
        RX_CHANNEL_AC_A_d RX_CHANNEL_AC_B_d RX_CHANNEL_AC_C_d RX_CHANNEL_AC_D_e...
        RX_CHANNEL_AC_A_d RX_CHANNEL_AC_B_d RX_CHANNEL_AC_C_d RX_CHANNEL_AC_D_f])
end

%% - Results

fprintf("\n--------------------------------------------\n")
fprintf("RESULTS:\n")
fprintf("- Samples:\n")
fprintf('   + Data samples per RX: %d, %.2f ms (%.2f us)\n',...
    num_rx_samples, (num_rx_samples * ts_rx * 1e3), (num_rx_samples * ts_rx * 1e6));
fprintf('   + RSSI samples per RX: %d, %.2f ms (%.2f us)\n', ...
    num_rssi_samples, (num_rssi_samples * ts_rssi * 1e3), (num_rssi_samples * ts_rssi * 1e6));
fprintf('   + RX sampling rate: %.0f Msps (sample duration = %.0f ns)\n',...
    wl_basebandCmd(node_rx_a, 'tx_buff_clk_freq') * 1e-6, ts_rx * 1e9)
fprintf('   + RSSI sampling rate: %.0f Msps (sample duration = %.0f ns)\n',...
    wl_basebandCmd(node_rx_a, 'rx_rssi_clk_freq') * 1e-6, ts_rssi * 1e9)

%% Calibration test

% % a
% [A_a_peak_rssi_av, A_a_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_A_a, cal_thr);
% [B_a_peak_rssi_av, B_a_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_B_a, cal_thr);
% [C_a_peak_rssi_av, C_a_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_C_a, cal_thr);
% [D_a_peak_rssi_av, D_a_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_D_a, cal_thr);
%
% % b
% [A_b_peak_rssi_av, A_b_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_A_b, cal_thr);
% [B_b_peak_rssi_av, B_b_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_B_b, cal_thr);
% [C_b_peak_rssi_av, C_b_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_C_b, cal_thr);
% [D_b_peak_rssi_av, D_b_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_D_b, cal_thr);
%
% % c
% [A_c_peak_rssi_av, A_c_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_A_c, cal_thr);
% [B_c_peak_rssi_av, B_c_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_B_c, cal_thr);
% [C_c_peak_rssi_av, C_c_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_C_c, cal_thr);
% [D_c_peak_rssi_av, D_c_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_D_c, cal_thr);
%
% % d
% [A_d_peak_rssi_av, A_d_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_A_d, cal_thr);
% [B_d_peak_rssi_av, B_d_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_B_d, cal_thr);
% [C_d_peak_rssi_av, C_d_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_C_d, cal_thr);
% [D_d_peak_rssi_av, D_d_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_D_d, cal_thr);
%
% % e
% [A_e_peak_rssi_av, A_e_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_A_e, cal_thr);
% [B_e_peak_rssi_av, B_e_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_B_e, cal_thr);
% [C_e_peak_rssi_av, C_e_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_C_e, cal_thr);
% [D_e_peak_rssi_av, D_e_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_D_e, cal_thr);
%
% % f
% [A_f_peak_rssi_av, A_f_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_A_f, cal_thr);
% [B_f_peak_rssi_av, B_f_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_B_f, cal_thr);
% [C_f_peak_rssi_av, C_f_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_C_f, cal_thr);
% [D_f_peak_rssi_av, D_f_peak_count] = get_av_peak_rssi(rssi_temporal_dBm_D_f, cal_thr);
%
%
% fprintf('Av. peak RSSI [dBm]:\n')
% fprintf('- RXer a (WARP-a): RF_A = %.2f, RF_B = %.2f, RF_C = %.2f, RF_D = %.2f\n', ...
%     A_a_peak_rssi_av, B_a_peak_rssi_av, C_a_peak_rssi_av, D_a_peak_rssi_av)
% fprintf('- RXer b (WARP-b): RF_A = %.2f, RF_B = %.2f, RF_C = %.2f, RF_D = %.2f\n', ...
%     A_b_peak_rssi_av, B_b_peak_rssi_av, C_b_peak_rssi_av, D_b_peak_rssi_av)
% fprintf('- RXer c (WARP-c): RF_A = %.2f, RF_B = %.2f, RF_C = %.2f, RF_D = %.2f\n', ...
%     A_c_peak_rssi_av, B_c_peak_rssi_av, C_c_peak_rssi_av, D_c_peak_rssi_av)
% fprintf('- RXer d (WARP-d): RF_A = %.2f, RF_B = %.2f, RF_C = %.2f, RF_D = %.2f\n', ...
%     A_d_peak_rssi_av, B_d_peak_rssi_av, C_d_peak_rssi_av, D_d_peak_rssi_av)
% fprintf('- RXer e (WARP-e): RF_A = %.2f, RF_B = %.2f, RF_C = %.2f, RF_D = %.2f\n', ...
%     A_e_peak_rssi_av, B_e_peak_rssi_av, C_e_peak_rssi_av, D_e_peak_rssi_av)
% fprintf('- RXer f (WARP-f): RF_A = %.2f, RF_B = %.2f, RF_C = %.2f, RF_D = %.2f\n', ...
%     A_f_peak_rssi_av, B_f_peak_rssi_av, C_f_peak_rssi_av, D_f_peak_rssi_av)
%
% list_peak_rssi_av = [A_a_peak_rssi_av, B_a_peak_rssi_av, C_a_peak_rssi_av, D_a_peak_rssi_av,...
% A_b_peak_rssi_av, B_b_peak_rssi_av, C_b_peak_rssi_av, D_b_peak_rssi_av,...
% A_c_peak_rssi_av, B_c_peak_rssi_av, C_c_peak_rssi_av, D_c_peak_rssi_av,...
% A_d_peak_rssi_av, B_d_peak_rssi_av, C_d_peak_rssi_av, D_d_peak_rssi_av,...
% A_e_peak_rssi_av, B_e_peak_rssi_av, C_e_peak_rssi_av, D_e_peak_rssi_av,...
% A_f_peak_rssi_av, B_f_peak_rssi_av, C_f_peak_rssi_av, D_f_peak_rssi_av]';
%
% list_peak_rssi_count = [A_a_peak_count, B_a_peak_count, C_a_peak_count, D_a_peak_count,...
% A_b_peak_count, B_b_peak_count, C_b_peak_count, D_b_peak_count,...
% A_c_peak_count, B_c_peak_count, C_c_peak_count, D_c_peak_count,...
% A_d_peak_count, B_d_peak_count, C_d_peak_count, D_d_peak_count,...
% A_e_peak_count, B_e_peak_count, C_e_peak_count, D_e_peak_count,...
% A_f_peak_count, B_f_peak_count, C_f_peak_count, D_f_peak_count]'
%
% DICTIONARY = {'a-A', 'a-B', 'a-C', 'a-D',...
%     'b-A', 'b-B', 'b-C', 'b-D',...
%     'c-A', 'c-B', 'c-C', 'c-D',...
%     'd-A', 'd-B', 'd-C', 'd-D',...
%     'e-A', 'e-B', 'e-C', 'e-D',...
%     'f-A', 'f-B', 'f-C', 'f-D'};
%
% fprintf('- Order (minor to higher) for peak av RSSI:\n')
% [~, ixes] = sort(list_peak_rssi_av);
% ordered_dictionary = DICTIONARY(ixes);
% fprintf(1, '%s\n', ordered_dictionary{:})
% list_peak_rssi_av(ixes)
%
% fprintf('- Order (minor to higher) for peak counts:\n')
% [~, ixes] = sort(list_peak_rssi_count);
% ordered_dictionary = DICTIONARY(ixes);
% fprintf(1, '%s\n', ordered_dictionary{:})
% list_peak_rssi_count(ixes)

diary('off');