function algdata = CONVCOORD(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Compute hankel matrix
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);

% Compute svd
[U,S,Sn,V] = truncsvd(H,algdata.rank);

% Compute derivative of basis U
[Us,dU] = cendiff4(U,algdata.dt);
% [Vs,dV] = cendiff4(V(1:end-algdata.horizon,:),algdata.dt);

% Compute Koopman Operator
A = Us'*dU;
% A = S\(Vs'*dV)*S;

% Compute convolutional coordinates
y = hankmat(algdata.Y,size(Us,1),[1,1]);
W = Us'*y;
% W = U'*H;
% m = size(y,1)/2;
% W = W(:,m:end-m);

% Extract train samples
Wtrain = W(:,1:end-algdata.horizon);

%% Reconstruct convolutional coordinates
w0 = Wtrain(:,1);
Wr = convcoordreconstruct(A,w0,algdata.dt,size(W,2)); 

Lr = (1:size(Wtrain,2));
Lp = (1:algdata.horizon) + length(Lr);
Wtest = W(:,Lp);
tr = algdata.dt*(Lr-1);
tp = algdata.dt*(Lp-1);
Wp = Wr(:,Lp);
Wr = Wr(:,Lr);

%% Calculate RMSE
[RMSEWr,rmseWr] = rmse(Wtrain,Wr);
[RMSEWp,rmseWp] = rmse(Wtest,Wp);
[RMSEW,rmseW] = rmse([Wtrain Wtest],[Wr Wp]);

%% Save in algstruct(i)
algdata.H = H;
algdata.rank = size(S,1);
algdata.U = U;
algdata.s = diag(S);
algdata.sn = diag(Sn);
algdata.V = V;
algdata.A = A;

algdata.Wtrain = Wtrain;
algdata.Wr = Wr;
algdata.tr = tr;
algdata.RMSEWr = RMSEWr;
algdata.rmseWr = rmseWr;
algdata.Wtest = Wtest;
algdata.Wp = Wp;
algdata.tp = tp;
algdata.RMSEWp = RMSEWp;
algdata.rmseWp = rmseWp;
algdata.RMSEW = RMSEW;
algdata.rmseW = rmseW;

end