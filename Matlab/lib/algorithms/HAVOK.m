function algdata = HAVOK(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Compute full hankel matrix (train and test)
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);

% Compute svd of full hankel matrix (train and test)
[U_,S_,Sn,Sn_,V_] = truncsvd(H,algdata.rank);

% Compute derivative of train delay coordinates V
[Vtrain,dV] = cendiff4(V_(1:end-algdata.horizon,:),algdata.dt);

% Compute regression and split into linear state transition matrix and 
% forcing matrix
Z = (Vtrain\dV)';
A = Z(1:end-1,1:end-1);
B = Z(1:end-1,end);

%% Reconstruct delay state
u = V_(3:end,end);
v0 = V_(3,1:end-1);
Vr = havokreconstruct(A,B,u,v0,algdata.dt);

Lr = (1:size(Vtrain,1)) + 2;
Lp = (1:algdata.horizon) + size(Vtrain,1) + 2;
Vtest = V_(Lp,:);
tr = algdata.dt*(Lr-1);
tp = algdata.dt*(Lp-1);
Vp = Vr(Lp,:);
Vr = Vr(Lr,:);

%% Calculate RMSE
[RMSEVr,rmseVr] = rmse(Vtrain(:,1:end-1),Vr);
[RMSEVp,rmseVp] = rmse(Vtest(:,1:end-1),Vp);
[RMSEV,rmseV] = rmse([Vtrain(:,1:end-1); Vtest(:,1:end-1)],[Vr; Vp]);

%% Save in algstruct(i)
algdata.H = H;
algdata.rank = size(S_,1);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
algdata.A = A;
algdata.B = B;

algdata.Vtrain = Vtrain;
algdata.Vr = Vr;
algdata.tr = tr;
algdata.RMSEVr = RMSEVr;
algdata.rmseVr = rmseVr;
algdata.Vtest = Vtest;
algdata.Vp = Vp;
algdata.tp = tp;
algdata.RMSEVp = RMSEVp;
algdata.rmseVp = rmseVp;
algdata.RMSEV = RMSEV;
algdata.rmseV = rmseV;

end