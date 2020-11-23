function algdata = CONVCOORD(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Compute hankel matrix
H = hankmat(algdata.Yn,algdata.delays,algdata.spacing);

% Compute svd
[U_,S_,Sn,Sn_,V_] = truncsvd(H,algdata.rank);

% Compute derivative of basis U
[Us,dU] = cendiff4(U_,algdata.dt);
% [Vs,dV] = cendiff4(V_(1:end-algdata.horizon,:),algdata.dt);

% Compute Koopman Operator
A = Us'*dU;
% A = S_\(Vs'*dV)*S_;

% Compute convolutional coordinates
y = hankmat(algdata.Y,size(Us,1),[1,1]);
W = Us'*y;
% W = U_'*H;
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
algdata.rank = size(S_,1);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
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