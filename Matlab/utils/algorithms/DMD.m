function [self,Phi,omega,b] = DMD(D, dt, rank, delays, spacing)

%% Check function arguments
if nargin < 2
    error('Minimum number of inputs is 2.');
elseif nargin < 3
    rank = [];
    delays = 1;
    spacing = 1;
elseif nargin < 4
    delays = 0;
    spacing = 1;
elseif nargin < 5
    spacing = 1;
end

%% Start algorithm
M = hankmat(D,delays,spacing);

X = M(:,1:end-1);
Y = M(:,2:end);

[U,S,V] = truncsvd(X,rank);
s = diag(S);

Atilde = S\U'*Y*V;

[W,d] = eigdec(Atilde);
D = diag(d);

Phi = Y*V/S*W/D;
Phi = Phi(1:size(D,1),:);

omega = log(d)/dt;

b = (W*D)\(S*V(1,:)');

%% Save in- and output
self.input = struct('D',D,'dt',dt,'rank',rank,'delays',delays,'spacing',spacing);
self.data = struct('M',M,'X',X,'Y',Y);
self.svd = struct('U',U,'s',s,'V',V);
self.dmd = struct('Atilde',Atilde,'W',W,'d',d','Phi',Phi,'omega',omega,'b',b);

end