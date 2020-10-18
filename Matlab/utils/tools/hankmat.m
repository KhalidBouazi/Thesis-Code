function H = hankmat(M, delays, spacing)

%% Create hankel matrix
if delays > 1
    H = [];
    for i = 1:size(M,1)
        c = M(i,1:delays);
        r = M(i,delays:end);
        Hi = hankel(c,r);
        H = [H; Hi];
    end
else
    H = M;
end

end