function alpha = seperability(STA)

[~, S, ~] = svd(STA);
S_int = S(S~=0);
alpha = 1 - (S_int(1)^2)/(sum(S_int(2:end))^2);

