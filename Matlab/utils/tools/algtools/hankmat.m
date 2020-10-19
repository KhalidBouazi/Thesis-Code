function H = hankmat(M, delays, spacing)

%% Check delay dimension
timelen = size(M,2);
if delays > timelen
    error('Delay dimension: Must be smaller than time length.');
end

%% Create hankel matrix
statelen = size(M,1);
if delays > 1
    H = zeros(statelen*delays,timelen-delays+1);
    for i = 1:statelen
        c = M(i,1:delays);
        r = M(i,delays:end);
        H(delays*(i-1)+1:delays*i,:) = hankel(c,r);
    end
else
    H = M;
end

end