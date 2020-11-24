function H = hankmat(M, delays, spacing)

%% ...
spacingx = spacing(1);
spacingy = spacing(2);
[statelen,timelen] = size(M);
delays_ = 1 + spacingy*delays;
Hheight = statelen*(delays+1);
Hwidth = ceil((timelen-delays_+1)/spacingx);

if Hwidth < 1
    error('Hankel matrix: time delay dimension should be smaller than (timesteps - spacingx)/spacingy.'); 
end

%% Create hankel matrix
if delays_ > 1
    H = zeros(Hheight,Hwidth);
    for i = 1:statelen
        c = M(i,1:delays_);
        r = M(i,delays_:end);
        H_ = hankel(c,r);  
        H(i:statelen:i+statelen*delays,:) = H_(1:spacingy:end,1:spacingx:end);
    end
else
    H = M;
end

end