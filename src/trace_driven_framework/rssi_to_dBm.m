function [rssi_dBm] = rssi_to_dBm(rssi_1024, rx_gain_rf)
    %RSSI_TO_DBM Converts an RSSI value in 1024 (10 bits) to dBm
    %   Input:
    %       - rssi_1024: RSSI in 10 bits ADC
    %       - rx_gain_rf: RF RX gain
    %   Output:
    %       - rssi_dBm: RSSI [dBm]
    
    %rssi_dBm = rssi_1024 *(70/1023) - 70 - (rx_gain_rf-1)*15;
    
    %
    switch rx_gain_rf
        case 1
            c = 126/2; % for high gain
        case 2
            c = 155/2; % for high gain
        case 3
            c = 280/3; % for high gain
    end
    rssi_dBm = (200/3069) * rssi_1024 - c;    
end

