%% Set parameters
strf_info = readtable(['C:\Users\kbakshi\Documents\Data'...
    '\STRF Analysis\STRF Summary.xlsx'], 'Sheet', 'Spike Sorting');
strf_location = 'C:\Users\kbakshi\Documents\Data\STRF Analysis\Sorted\';
save_path = 'C:\Users\kbakshi\Documents\Data\STRF Analysis\';

depth_pos = xlsread('S:\Smotherman_Lab\Auditory cortex\NN 4x4 probe depth.xlsx');
RC_pos = xlsread('S:\Smotherman_Lab\Auditory cortex\NN 4x4 probes RC.xlsx');

strf_table(1,:) = {'Bat', 'ExperimentalSite', 'RCLocation', 'Depth',...
    'PeakExcitatoryFrequency', 'LatencyAtPeak', 'PeakInhibitoryFrequency',...
    'LatencyAtMin', 'PeakFiringRate', 'IntegrationTime', 'OctaveBW',...
    'FrequencyBW', 'InhibitoryIntegrationTime', 'InhibitoryOctaveBW',...
    'InhibitoryFreqBW', 'IER', 'DSI', 'Seperability',...
    'sMTF', 'tMTF', 'sMTFcutoff', 'tMTFcutoff'};
iter = 2;

for n = 1:height(strf_info)
    fname = char(strf_info.FileName(n));
    bat = fname(1:5);
    filepath = [strf_location, bat, '\', fname(7:end), ' info.mat'];
    load(filepath)
   
    if isempty(str2num(fname(end-8))) == 1
        channel = fname(end-7);
    else
        channel = fname(end-8:end-7);
    end
    
    if isempty(str2num(fname(13))) == 1
        site = fname(12);
    elseif isempty(str2num(fname(13))) == 0
        site = fname(12:13);
    end
    unit = fname(end);
    
    marker = load(['C:\Users\kbakshi\Documents\Data\',...
        fname(1:5), '\Data\', fname(1:5),...
        '_', site,'_marker_tc.mat']);
    
    depth = marker.depth - depth_pos(str2num(channel));
    RC = marker.rostro_caudal - RC_pos(str2num(channel));
    
    [col,row]=find(STA==max(STA(:)));
    if length(row) == 1
        latency=taxis(row);
        peak_freq=faxis(col)/1000;
        
    else
        latency = NaN;
        peak_freq = NaN;
    end
    
    [col,row]=find(STA==min(STA(:)));
    if length(row) == 1
        min_peak_freq = faxis(col)/1000;
        min_latency = taxis(row);
    else
        min_peak_freq = NaN;
        min_latency = NaN;
    end
    if ~isnan(min_peak_freq)
        inSTA = STA;
        inSTA(inSTA >= 0) = 0;
        [in_integration, inO_bw, inF_bw] = resolution(abs(inSTA), X, faxis);
    else
        inSTA = NaN;
        in_integration = NaN;
        inO_bw = NaN;
        inF_bw = NaN;
    end
    IER = strfIER(STA, inSTA);
    [integration, o_BW, f_BW] = resolution(STA, X, faxis);
    DSI = dsiSTRF(MTF);
    alpha = seperability(STA);
    
    [~, maxFR] = plotSortedSTRF(STA, taxis, faxis, latency, peak_freq,...
        str2num(site), str2num(channel), unit);
    
    [MTF, tempmod, specmod] = STRF2MTF(STA, taxis, X);
    [~, sMTF_max, tMTF_max, specmod_cut, tempmod_cut] = plotMTF(MTF,...
        tempmod, specmod);
    
    strf_table(iter,:) = {fname(1:5),...
        fname(7:end),...
        RC, depth, peak_freq, latency, min_peak_freq,...
        min_latency, maxFR, integration,...
        o_BW, f_BW, in_integration, inO_bw, inF_bw, IER, DSI, alpha, sMTF_max,...
        tMTF_max, specmod_cut, tempmod_cut};
    iter = iter+1;
    close all
end

save([save_path, 'sorted_STRFs_032522.mat'], 'strf_table')