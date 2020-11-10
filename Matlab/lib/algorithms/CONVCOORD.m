function algdata = CONVCOORD(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Compute hankel matrix
H = hankmat(algdata.Y(:,1:end-1),algdata.delays,algdata.spacing);

% Compute svd
[U,S,Sn,V] = truncsvd(H,algdata.rank);

% Compute derivative of basis U
[Us,dU] = cendiff4(U,algdata.dt);

% Compute Koopman Operator
A = Us'*dU;

% Compute convolutional coordinates
y = hankmat(algdata.Y(:,1:end-1),size(Us,1),[1,1]);
W = Us'*y;
% m = size(y,1)/2;
% W = W(:,m:end-m);

%% Reconstruct convolutional coordinates and calculate rmse
t_ = algdata.dt*(0:size(W,2)-1);
W_ = convcoordreconstruct(A,W,algdata.dt); 
[RMSEW_,rmseW_] = rmse(W,W_);

%% Save in algstruct(i)
algdata.H = H;
algdata.rank = size(S,1);
algdata.U = U;
algdata.s = diag(S);
algdata.sn = diag(Sn);
algdata.V = V;
algdata.A = A;
algdata.W = W;
algdata.W_ = W_;
algdata.RMSEW_ = RMSEW_;
algdata.rmseW_ = rmseW_;
algdata.t_ = t_;

end