function [sppsd,linpredpsd,predratepsd,predrate2psd,linpredspcc,predratespcc,predrate2spcc] = ...
            viewCC(winlen,dt,sp,linpred,predrate,predrate2)
% [sppsd,linpredpsd,predratepsd,predrate2psd,linpredspcc,predratespcc,predrate2spcc} = ...
%     viewCC(winlen,dt,sp,linpred,predrate,predrate2)
% computes powerspectrectal densities and cross coherence for STRF calculations

winlen = 2^ceil(log2(2*size(STA,2))); % window power of 2 greater than twice duration of STRF
[linpredpsd] = pwelch(linpred,winlen,winlen/2,winlen,1000/dt);
[predratepsd] = pwelch(predrate,winlen,winlen/2,winlen,1000/dt);
[predrate2psd] = pwelch(predrate2,winlen,winlen/2,winlen,1000/dt);
[sppsd] = pwelch(sp,winlen,winlen/2,winlen,1000/dt);
% linpredxy = cpsd(linpred,sp,winlen,winlen/2,winlen,1000/dt);
[linpredcc F] = mscohere(linpred,sp,winlen,winlen/2,winlen,1000/dt);
[predratecc F] = mscohere(predrate,sp,winlen,winlen/2,winlen,1000/dt);
[predrate2cc F] = mscohere(predrate2,sp,winlen,winlen/2,winlen,1000/dt);
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