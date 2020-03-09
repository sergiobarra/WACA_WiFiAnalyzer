function [spec_vblity_av_cont_ch, spec_vbility_widest_ch] = get_spectral_variability_metrics(occupancy_array_at_time_sample)
    
    a = not(occupancy_array_at_time_sample);
    out = double(diff([~a(1);a(:)]) == 1);
    v = accumarray(cumsum(out).*a(:)+1,1);
    out(out == 1) = v(2:end);
    consecutive_free_channels = out(out>=1)';
    
    spec_vblity_av_cont_ch = sum(consecutive_free_channels) / 8;
   
    if max(consecutive_free_channels)>0
        spec_vbility_widest_ch = max(consecutive_free_channels);
    else
        spec_vbility_widest_ch = 0;
    end
    
%     
%     fprintf("--------\n")
%     disp(occupancy_array_at_time_sample)
%     disp(out')
%     disp(spec_vblity_av_cont_ch)
%     disp(spec_vbility_widest_ch)
end