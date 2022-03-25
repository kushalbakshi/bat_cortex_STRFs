function IER = strfIER(STA, inSTA)


% Inhibitory-Excitatory Ratio (IER) of the STRF. Computes the power of the
% postitive and negative STRF matricies and finds the ratio. An IER value
% of '0' means the STRF is purely excitatory or inhibitory and an IER of
% '1' means the strength of inhibition is equal to the strength of
% excitation.


STA(STA <= 0) = 0;
if isnan(inSTA)
    inSTA = 0;
else
end

excitePOW = trapz(trapz(STA.^2));
inhibPOW = trapz(trapz(inSTA.^2));

if excitePOW >= inhibPOW
    IER = inhibPOW/excitePOW;
else
    IER = excitePOW/inhibPOW;
end