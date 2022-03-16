function fig2 = plotSortedMTF(MTF, tempmod, specmod)

MTF = abs(MTF);

fig2 = figure('Color', 'w', 'Position', [30 50 1200 800]);
ax1 = axes('Position', [.15 .1 .75 .65]);
s2 = surface(ax1, tempmod,specmod,MTF);
set(s2, 'FaceColor','interp','EdgeColor','interp');
xlim([-100 100])
xlabel('Temporal Modulation (Hz)')
ylim([0 5])
ylabel('Spectral Modulation (cycles/octave)')
cbar = colorbar;
colormap jet
set(gca, 'FontSize', 18)

sMTF = trapz(MTF, 2);
sMTF = rescale(sMTF, 0, 1);
[~, m_ind] = max(sMTF);
sMTF_max = specmod(m_ind);

tMTF = trapz(MTF, 1);
tMTF = rescale(tMTF, 0, 1);
[~, m_ind] = max(tMTF);
tMTF_max = tempmod(1, m_ind);

[~, r_max] = max(MTF(:));
[col, row] = ind2sub([158 401], r_max);

ax2 = axes('Position', [.035 .1 .07 .65]);
plot(MTF(:,row), specmod, 'k')
title(ax2, 'sMTF')
cbar_lim = get(cbar, 'Limits');
cutoff = cbar_lim(2)*0.5;
set(gca, 'xdir', 'reverse', 'xlim', [cutoff cbar_lim(2)],...
    'ylim', [0 5], 'Visible', 'off')
set(findall(gca, 'type', 'text'), 'visible', 'on')

ax3 = axes('Position', [.15 .78 .65 .07]);
plot(tempmod, MTF(col, :), 'k')
title(ax3, 'tMTF')
set(gca, 'xlim', [-100 100], 'ylim', [0 cbar_lim(2)], 'Visible', 'off')
set(findall(gca, 'type', 'text'), 'visible', 'on')
