function [integration, o_BW, f_BW] = resolution(STA)

STA_hil = hilbert(STA) * sqrt(-1);
STA_power = abs(STA + STA_hil).^2;

spectral_power = trapz(STA_power, 2)/trapz(trapz(STA_power, 2));
temporal_power = trapz(STA_power)/trapz(trapz(STA_power));

integration = 2 * std(spectral_power) * 1000;
o_BW = 2 * std(temporal_power);
f_BW = 2^(o_BW)*5000;