function [xbinctrs,ybinctrs,counts,xbinedges] = fitNlin_hist1D(filtin, sps, nfbins,dt)
% [xbinctrs,ybinctrs,counts,xbinedges] = fitNlin_hist1D(filtin, sps, nfbins,dt)
%
% Computes a histogram-based estimate of nonlinear function in a single-filter LNP model.
%
% INPUTS:
%          filtin [Nx1] - output of filter applied to stimulus
%          sps  [Nx1] - column vector of spike counts in each bin
%        nfbins [1x1] - number of bins 
%            dt [1x1] - time per bin (msec)
%
% OUTPUT:
%            xbinctrs - input bin centers for nonlinearity
%            ybinctrs - y values for nonlinearity
%            counts - number of spiked in each bin
%            xbinctrs - bin edges for nonlinearity
%
% Compute histogram-based estimate for piece-wise constant nonlinearity by
% binning filter output and computing, for each bin, the mean spike rate

% % --- Check inputs ----
% if nargin < 4 || isempty(RefreshRate)
%     RefreshRate = 1; 
%     fprintf('fitNlin_hist1D: Assuming RefreshRate=1 (units will be spikes/bin)\n');
% end

% Set minimum rate (so we don't produce 0 spike rate)
MINRATE = 1/(length(filtin)*(dt/1000));  % default choice: set to 1/number of time bins

% bin filter output and get bin index for each filtered stimulus
[counts,xbinedges,binID] = histcounts(filtin,nfbins); 
xbinctrs = xbinedges(1:end-1)+diff(xbinedges(1:2))/2; % use bin centers for x positions

% now compute mean spike count in each bin
ybinctrs = zeros(nfbins,1); % y values for each bin
for jj = 1:nfbins
    ybinctrs(jj) = mean(sps(binID==jj));
end
ybinctrs = max(ybinctrs,MINRATE)/(dt/1000); % divide by bin size to get units of sp/s;

