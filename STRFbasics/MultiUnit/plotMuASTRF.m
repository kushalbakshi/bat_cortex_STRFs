function [fig1, maxRate] = plotMuASTRF(STA, taxis, faxis, maxfreq, latency)
% Generates a highly annotated STRF figure including depth of recording
% site, latency/integration time of the excitatory component, peak
% frequency of the excitatory component

fig1 = figure('Color', 'w', 'Position', [30 50 1200 800]);
ss = surface(taxis,faxis,STA);
set(ss,'edgecolor','none');
xlabel('Time (ms)')
ylabel('Frequency (kHz)')
xlim([0 200])
ylim([5000 max(faxis)])
set(gca, 'xdir','reverse', 'view',[0 90], 'FontSize', 18);
yticks([10000 20000 30000 40000 50000 60000 70000 80000])
yticklabels([10 20 30 40 50 60 70 80])
colormap jet
lim=caxis;
caxis([-lim(1,2),lim(1,2)])
c_bar=colorbar;
maxRate = lim(1,2);
ylabel(c_bar,'Firing rate')

annotation('textbox',[.71 .87 .1 .1],'string',...
    ['Latency of peak excitation: ',num2str(latency),' ms'],...
    'Edgecolor','none','FontSize',12)

annotation('textbox',[.71 .902 .1 .1],'string',...
    ['Freq at peak excitation: ',num2str(maxfreq),' kHz'],...
    'Edgecolor','none','FontSize',12)