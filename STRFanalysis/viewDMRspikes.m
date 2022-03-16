function [isis] = viewDMRspikes(sp,stimdur,varargin)
% [isis smrate] = viewDMRspikes(sp,stimdur,varargin)
% view ISI distribution of spike trains captured during DMR STRF experiments
% sp - spike times in sec
% stimulation duration in seconds
% isis - list of isis in msec

par.histbins = 1000; % number of histogram bins for full distribution
par.shortisi = 50; % cutoff for short isi distribution
par.histbinsshort = 200; % number of histogram bins for short isi distribution

par = parse_pv_pairs(par, varargin);

sp = sp(:)'; % make spikes into a row vector

disp(['Mean spike rate = ' num2str(length(sp)/stimdur)])
% calc isis
isis = diff(sp)*1000;

% full isi histogram
subplot(1,2,1)
histogram(isis,par.histbins)
title('ISIs')
xlabel('msec')

% histogram for short isis
subplot(1,2,2)
histogram(isis(isis<=par.shortisi),par.histbinsshort)
title('Short ISIs')
xlabel('msec')

