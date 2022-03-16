function [spcnts nospcnts nearspcnts spnospctrs] = seplinpreddist(linpred, sp, winhw, NLinedges)
% [spcnts nospcnts nearspcnts spnospctrs] = seplinpreddist(linpred, sp, winwidth, NLinedges); 
% find distribution of linpred values for spike bins (spkcnts), bins that are far
% from spikes (nospkcnts), and bins that are near spcnts
% spnospctrs are centers of bins for linpred distribution
% winhw holds the number of bins on either side of a spike bin to exclude

% get binary vectors of spike containing bins, and bins that are near spike
% containing bins
spbins = sp>0;
nearsp = conv(spbins,ones(2*winhw+1,1),'same')>0;

disp(['Totals: spike bins=' num2str(sum(spbins)) '; no spike bins=' num2str(sum(~nearsp)) ...
        '; near spike bins=' num2str(sum(nearsp)-sum(spbins))]);
% find counts
spcnts = histcounts(linpred(spbins),NLinedges);
nospcnts = histcounts(linpred(~nearsp),NLinedges);
nearspcnts = histcounts(linpred(nearsp),NLinedges)-spcnts;

% calculate centers (for convenience)
spnospctrs = (NLinedges(1:end-1)+NLinedges(2:end))/2;
