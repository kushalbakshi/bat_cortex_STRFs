function spkbin = binspikes(spk,tbins)
% spkbin = binspikes(spk,tbins)
% return binned spike counts in bins determined by tbins

dt = diff(tbins(1:2));
spkbin = histcounts(spk,[tbins(1)-dt/2; tbins(:)+dt/2]);