function H = hankmat(M, delays, spacing, timesteps)

%% Check if spacing is empty
if nargin == 2
    spacing = [1 1];
end

if isempty(timesteps)
    cnt = 1;
else
    l = timesteps + delays - 1;
    cnt = cols(M)/l;
end

%% Compute Hankel Matrix
H = [];
for i = 1:cnt
    Mi = M(:,(1:l)+(i-1)*l);

    % Compute hankel dimension
    spacingx = spacing(1);
    spacingy = spacing(2);
    [statelen,timelen] = size(Mi);
    delays_ = 1 + spacingy*(delays-1);
    Hheight = statelen*delays;
    Hwidth = ceil((timelen-delays_+1)/spacingx);

    % Create hankel matrix
    if delays_ > 1
        Hi = zeros(Hheight,Hwidth);
        for i = 1:statelen
            c = Mi(i,1:delays_);
            r = Mi(i,delays_:end);
            H_ = hankel(c,r);  
            Hi(i:statelen:i+statelen*(delays-1),:) = H_(1:spacingy:end,1:spacingx:end);
        end
    else
        Hi = Mi;
    end
    H = [H Hi];
end

end