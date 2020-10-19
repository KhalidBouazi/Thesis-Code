function [self,Phi,omega,b] = DMD(Y, dt, rank, delays, spacing)

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
X = H(:,1:end-1);
Xp = H(:,2:end);

[U,S,V] = truncsvd(X,rank);

Atilde = S\U'*Xp*V;
[W,D] = eigdec(Atilde);
Phi = Xp*V/S*W/D;
Phi = Phi(1:size(Y,1),:);
omega = log(diag(D))/dt;
b = (W*D)\(S*V(1,:)');

%% Save in- and output
self = struct('algorithm',"DMD",...
              'Y',Y,'dt',dt,'rank',size(S,1),'delays',delays,'spacing',spacing,...
              'H',H,'U',U,'s',diag(S),'V',V,'Atilde',Atilde,'W',W,'d',diag(D)',...
              'Phi',Phi,'omega',omega,'b',b);

end