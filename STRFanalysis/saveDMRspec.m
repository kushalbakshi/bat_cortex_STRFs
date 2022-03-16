% script for saving DMR stimulus as a matrix at appropriate grid setting
saveDMR = 1;

dt = 2; % temporal bin size
tbinN = 40; % number of temporal bins
tSTRF = dt*(0:tbinN)';
fbinN = 2*length(tSTRF); % number of spectral bins

% load DMR stimulus info
DRMlocation = '../../kushaldata/STRFs for MURI/DMR Stimulus';
load(fullfile(DRMlocation,'dmr-5000flo-80000fhi-4SM-40TM-40db-200000khz-48DF-15min_param.mat'));
Nsamp = M;
Tmax = 1000*M/Fs; % stimulus duration in msec
% set frequency grid
XSTRFrange = [0 log2(faxis(end)/faxis(1))]; % in octaves from faxis(1)
XSTRF = linspace(XSTRFrange(1), XSTRFrange(2),fbinN);
fSTRF = faxis(1)*(2.^XSTRF); % frequency


% get ripple density/phase variables at time grid
tbins = dt/2:dt:Tmax; % time grid

riptimes = (0:length(RD)-1)*1000/FsN;
RDgrid = interp1(riptimes,RD,tbins,'pchip');
RPgrid = interp1(riptimes,RP,tbins,'pchip');

% make DMRgrid
DMRgrid = (Mdb/2)*sin(2*pi*XSTRF(:)*RDgrid+ ones(length(XSTRF),1)*RPgrid);

% save
if saveDMR
    save(['DMRgrid_' num2str(length(fSTRF)) '_' num2str(length(tSTRF)) '.mat'],...
        'DMRgrid','RDgrid','RPgrid','tbins','dt','tSTRF','fSTRF');
end