function [self,V] = HAVOK(Y, dt, rank, delays, spacing)

%% Check function arguments
if nargin < 2
    error('Arguments: Minimum number of arguments is 2.');
end
if nargin < 5
    spacing = 1;
end
if nargin < 4
    delays = 1;
end
if nargin < 3
    rank = [];
end

%% Start algorithm
H = hankmat(Y,delays,spacing);

[U,S,V] = truncsvd(H,rank);

% [V,dV] = cendiff4(V,dt);
% X = V\dV;
% A = X(1:end-1,1:end-1)';
% B = X(end,1:end-1)';

%% Save in- and output
self = struct('algorithm',"HAVOK",...
              'Y',Y,'dt',dt,'rank',size(S,1),'delays',delays,'spacing',spacing,...
              'H',H,'U',U,'s',diag(S),'V',V);%,'A',A,'B',B);

end