function DSI = dsiSTRF(MTF)

MTF = abs(MTF);
P1 = sum(MTF(:,1:200).^2);
P2 = sum(MTF(:,202:end).^2);

DSI = (P2 - P1) / (P1 + P2);