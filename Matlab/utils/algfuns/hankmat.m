function H = hankmat(M, delays, spacing)

%% Check if spacing is empty
if nargin == 2
    spacing = [1 1];
end

%% Compute hankel dimension
spacingx = spacing(1);
spacingy = spacing(2);
[statelen,timelen] = size(M);
delays_ = 1 + spacingy*delays;
Hheight = statelen*(delays+1);
Hwidth = ceil((timelen-delays_+1)/spacingx);

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