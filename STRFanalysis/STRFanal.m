% STRFLNPanal
%  analysis data flow for STRFs still a bit rough
% uses discretized analysis at fairly low res to keep memory constraints
% down

% resolution parameters
dt = 2; % temporal bin size (msec)
tbinN = 41; % number of temporal bins in STRF
fbinN = 81; % number of frequency bins in STRF


% flags for parts of analsysis
dispISIs = 1; % display ISI distributions
calcSTA =1; % flag for whether to calculate spike triggered average STA, also calculates linear filter
calcNL = 1; % use histogram to calculate nonlinear transform 
calcpsdcc = 1; % calculate power spectral density and coherence (takes a bit of time)
viewprd_v_sp = 0; % view stimulus/predictions vs. spikes (not done yet)

% data paths
DRMpath = 'S:\Smotherman_Lab\Kushal Bakshi\Data\DMRbox\'; % path of DMR stimulus parameters
datapath = 'C:\Users\kbakshi\Documents\Data\STRF Analysis\Manual Sort\'; % path of info file relative to current path
% unitname = 'Tb111_5_Chn6_Unit2';
% unitname = 'Tb111_4_Chn15_Unit1';
unitname = 'Tb111_Site 4 Chn 5 Unit 1';

% load stimulus parameters
load(fullfile(DRMpath,'dmr-5000flo-80000fhi-4SM-40TM-40db-200000khz-48DF-15min_param.mat'));
Nsamp = M;
Tmax = 1000*M/Fs; % stimulus duration in msec

% make DMR/STRF grid
XSTRFrange = [0 log2(faxis(end)/faxis(1))]; % in octaves from faxis(1)
XSTRF = linspace(XSTRFrange(1), XSTRFrange(2),fbinN);
fSTRF = faxis(1)*(2.^XSTRF)/1000; % frequency
tSTRF = dt*(0:tbinN-1)';
tbins = dt/2:dt:Tmax; % full time grid (STRF)


% load spikes
load(fullfile(datapath,[unitname ' info.mat']));
sp = binspikes(times,tbins)'; % sp = binned spike counts (usually binary vector)

% look at ISI statistics
figISI = figure(1);
set(figISI,'numbertitle','off','Name',[unitname ' ISIs'])
clf
[ISIs] = viewDMRspikes(times/1000,Tmax/1000); 

% calculate STRF DMRgrid
if calcSTA
    riptimes = (0:length(RD)-1)*1000/Fsn;
    RDgrid = interp1(riptimes,RD,tbins,'pchip');
    RPgrid = interp1(riptimes,RP,tbins,'pchip');
    % make DMRgrid
    DMRgrid = sin(2*pi*XSTRF(:)*RDgrid+ ones(length(XSTRF),1)*RPgrid);

    % Compute STA
    STA = simpleSTC(DMRgrid',sp,length(tSTRF))';  % compute STA using code from Jonathan Pillow
    STA = STA./norm(STA(:));  % normalize sta to be a unit vector
    
    figSTRF = figure(2);
    set(figSTRF,'numbertitle','off','Name',[unitname ' STRF'])
    clf;
    viewSTRF(tSTRF,fSTRF,STA);
    % get convolution of filter and stimulus
    linpred = sameconv(DMRgrid', STA');
end

if calcNL == 1
    % Estimate piecewise-constant nonlinearity ("reconstruction" method using histograms)
    nhistbins = 15; % # histogram bins to use
    [NLinctrs,NLoutctrs,NLcounts,NLinedges] = fitNlinhist(linpred, sp, nhistbins,dt); 
    % make sure points go to edges to allow interpolation
    % find distributions of spike/no spike/far from spike distributions
    [spcnts nospcnts nearspcnts spnospctrs] = seplinpreddist(linpred, sp, 10/dt,NLinedges); 
    NLin = [NLinedges(1) NLinctrs NLinedges(end)]; 
    NLout = [NLoutctrs(1); NLoutctrs; NLoutctrs(end)];
    % get "simple" prediction from two piece linear fit
    tmpfit = polyfit(NLinctrs(NLinctrs>0),NLoutctrs(NLinctrs>0),1); % fit of positive histogram points
    lowval = mean(NLoutctrs(NLinctrs<0)); % average of negative entries for histogram
    NL2in = [NLinedges(1) 0 NLinedges(end)];
    NL2out = [lowval lowval  polyval(tmpfit,NLinedges(end))];
    % display histogram
    fighist = figure(3);
    set(fighist,'numbertitle','off','Name',[unitname ' histogram'])
    clf
    subplot(2,1,1)
    cla; hold on
    viewNLhist(NLin,NLout,NLcounts,NL2in,NL2out);
    subplot(2,1,2)
    plot(spnospctrs,spcnts/max(spcnts))
    plot(spnospctrs,nospcnts/max(nospcnts))
    plot(spnospctrs,nearspcnts/max(nearspcnts),'--')
    set(gca,'ytick',[])
    legend({'Spikes','No spikes','Near'})
    xlabel('Filtered Input (arb)')
end

if calcpsdcc == 1
    % find spectral desnsities and coherence between predicted and actual rates
    predrate = interp1(NLin,NLout,linpred);
    predrate2 = interp1(NL2in,NL2out,linpred);
    winlen = 2^ceil(log2(2*size(STA,2))); % window power of 2 greater than twice duration of STRF
    if calcpsdcc == 1
        disp('Calculating PSDs and Coherences');
        [sppsd,F, linpredpsd,predratepsd,predrate2psd,linpredspcc,predratespcc,predrate2spcc] = ...
                calcCC(winlen,dt,sp,linpred,predrate,predrate2);
        disp('Done')
    end
    figcohere = figure(4);
    set(figcohere,'numbertitle','off','Name',[unitname ' coherence'])
    clf
    hold on
    viewpsdcc(sppsd,F,10,predratepsd,predratespcc,linpredpsd,linpredspcc,predrate2psd,predrate2spcc);
end

viewDMR(DMRgrid,STA,sp,linpred,predrate,fSTRF,tSTRF,dt,'twidth',5);