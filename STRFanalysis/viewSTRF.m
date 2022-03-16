function viewSTRF(taxis,faxis,STA)
% viewSTRF(taxis,faxis,STA)
% plots STRF and sets colormap etc

ss = surf(taxis,faxis,fliplr(STA));
view([0 90]);
set(ss,'edgecolor','none');
xlabel('Time (ms)')
ylabel('Frequency (kHz)')
xlim([min(taxis) max(taxis)])
ylim([min(faxis) max(faxis)])
set(gca,'yscale','log');
set(gca,'xdir','reverse');
set(gca,'view',[0 90])
colormap jet
lim=caxis;
caxis([-lim(1,2),lim(1,2)])