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
[U,S,Sn,V] = truncsvd(H,algdata.rank);

% Compute derivative of train delay coordinates V
[Vtrain,dV] = cendiff4(V(1:end-algdata.horizon,:),algdata.dt);

% Compute regression and split into state transition matrix and forcing
% matrix
Z = (Vtrain\dV)';
A = Z(1:end-1,1:end-1);
B = Z(1:end-1,end);

%% Reconstruct delay state
u = V(3:end,end);
v0 = V(3,1:end-1);
Vr = havokreconstruct(A,B,u,v0,algdata.dt);

Lr = (1:size(Vtrain,1)) + 2;
Lp = (1:algdata.horizon) + size(Vtrain,1) + 2;
Vtest = V(Lp,:);
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
algdata.rank = size(S,1);
algdata.U = U;
algdata.s = diag(S);
algdata.sn = diag(Sn);
algdata.V = V;
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