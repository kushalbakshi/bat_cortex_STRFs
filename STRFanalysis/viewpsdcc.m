function viewpsdcc(sppsd,F,lowF,predratepsd,predratespcc,linpredpsd,linpredspcc,predrate2psd,predrate2spcc)
% figh = viewpsdcc(sppsd,F,lowF,predratepsd,predratespcc,linpredpsd,linpredspcc,predrate2psd,predrate2spcc)
% plots psd and coherence
% psds are plotted in dashed lines
% allows for scrollable viewing
% normalize psd to equal sum above lowF
% don't plot zero frequency bin
% by default cut off display at maxfreq = 100 Hz 

% find indices for normalization/display cutoffs
iinm = min(find(F>=lowF));
iidisp = min(find(F>0));
% normalize psd so area above lowF is the same as area of predratespcc
targsum = sum(predratespcc(iinm:end));

% spike psd
sppsd = targsum*sppsd/sum(sppsd(iinm:end));
pp = plot(F(iidisp:end),sppsd(iidisp:end),'k');
% rate psd/cc
predratepsd = targsum*predratepsd/sum(predratepsd(iinm:end));
pp1 = plot(F(iidisp:end),predratepsd(iidisp:end));
pp2 = plot(F(iidisp:end),predratespcc(iidisp:end),'--');
    set(pp2,'color',get(pp1,'color'));
% linpred psd/cc
linpredpsd = targsum*linpredpsd/sum(linpredpsd(iinm:end));
pp1 = plot(F(iidisp:end),linpredpsd(iidisp:end));
pp2 = plot(F(iidisp:end),linpredspcc(iidisp:end),'--');
    set(pp2,'color',get(pp1,'color'));
% rate2 psd/cc
predrate2psd = targsum*predrate2psd/sum(predrate2psd(iinm:end));
pp1 = plot(F(iidisp:end),predrate2psd(iidisp:end));
pp2 = plot(F(iidisp:end),predrate2spcc(iidisp:end),'--');
    set(pp2,'color',get(pp1,'color'));

legend({'Spikes','Pred Rate','','Filt Inp','','Pred Rate 2'});
set(gca, 'xlim',[0 100]);
xlabel('Frequency (Hz)')
