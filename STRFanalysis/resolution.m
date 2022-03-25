function [integration, o_BW, f_BW] = resolution(STA, oaxis, faxis)

STA_hil = hilbert(STA) * sqrt(-1);
STA_power = abs(STA + STA_hil).^2;

spectral_power = trapz(STA_power, 2)/trapz(trapz(STA_power));
temporal_power = trapz(STA_power)/trapz(trapz(STA_power));

integration = 2 * std(temporal_power) * 1000;
oBW_SD = 2 * std(spectral_power);
[x0, ~, ~, ~] = intersections(oaxis, spectral_power, oaxis, repmat(oBW_SD, 316, 1));

x_min = find(abs(oaxis-min(x0)) < 0.01);
x_max = find(abs(oaxis-max(x0)) < 0.01);
o_BW = oaxis(x_max(end)) - oaxis(x_min(1));
f_BW = faxis(x_max(end)) - faxis(x_min(1));