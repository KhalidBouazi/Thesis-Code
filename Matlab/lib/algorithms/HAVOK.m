function algdata = HAVOK(algdata)

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

% Compute derivative of delay coordinates V
[Vs,dV] = cendiff4(V,algdata.dt);

% Compute regression and split into state transition matrix and forcing
% matrix
Z = (Vs\dV)';
A = Z(1:end-1,1:end-1);
B = Z(1:end-1,end);

%% Reconstruct delay state and calculate rmse
t_ = algdata.dt*(0:size(Vs,1)-1);
V_ = havokreconstruct(A,B,Vs,algdata.dt);
[RMSEV_,rmseV_] = rmse(Vs(:,1:end-1),V_);

%% Save in algstruct(i)
algdata.H = H;
algdata.rank = size(S,1);
algdata.U = U;
algdata.s = diag(S);
algdata.sn = diag(Sn);
algdata.V = V;
algdata.A = A;
algdata.B = B;
algdata.V_ = V_;
algdata.RMSEV_ = RMSEV_;
algdata.rmseV_ = rmseV_;
algdata.t_ = t_;

end