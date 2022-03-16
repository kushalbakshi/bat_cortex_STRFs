function [barh lineh] = viewNLhist(NLinctrs,NLoutctrs,NLcounts,NL2in,NL2out)
% [barh lineh] = viewNLhist(NLinctrs,NLoutctrs,NLcounts,NL2in,NL2out)
% view histogram of filtered input values and rate fits
% NL2in and NL2out are optional

hold on
bar(NLinctrs(2:end-1),max(NLoutctrs)*NLcounts/max(NLcounts),1);
lineh = plot(NLinctrs,NLoutctrs);
ylabel('Firing Rate (Hz)/ counts (arb)')
xlabel('Filtered Input (arb)')
if nargin>3
    lineh2 = plot(NL2in,NL2out);
    lineh = [lineh lineh2];
end