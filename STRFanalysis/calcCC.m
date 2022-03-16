function [sppsd,F, linpredpsd,predratepsd,predrate2psd,linpredspcc,predratespcc,predrate2spcc] = ...
            calcCC(winlen,dt,sp,linpred,predrate,predrate2)
% [sppsd,F, linpredpsd,predratepsd,predrate2psd,linpredspcc,predratespcc,predrate2spcc} = ...
%     calcCC(winlen,dt,sp,linpred,predrate,predrate2)
% computes powerspectrectal densities and cross coherence for STRF calculations
%  generally winlen is power of 2

[sppsd F] = pwelch(sp,winlen,winlen/2,winlen,1000/dt);
% predicted input
if ~isempty(linpred)
    [linpredpsd] = pwelch(linpred,winlen,winlen/2,winlen,1000/dt);
    [linpredspcc] = mscohere(linpred,sp,winlen,winlen/2,winlen,1000/dt);
else
    linpredpsd = [];
    linpredspcc = [];
end
% predicted rate
if ~isempty(predrate)
    [predratepsd] = pwelch(predrate,winlen,winlen/2,winlen,1000/dt);
    [predratespcc] = mscohere(predrate,sp,winlen,winlen/2,winlen,1000/dt);
else
    predratepsd = [];
    predratespcc = [];
end
% predicted rate 2
if ~isempty(predrate2)
    [predrate2psd] = pwelch(predrate2,winlen,winlen/2,winlen,1000/dt);
    [predrate2spcc] = mscohere(predrate2,sp,winlen,winlen/2,winlen,1000/dt);
else
    predrate2psd = [];
    predrate2spcc = [];
end
