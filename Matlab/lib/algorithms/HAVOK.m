function algdata = HAVOK(algdata)

%% Start algorithm
% Compute hankel matrix of Y
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);

% Compute svd of hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(H,algdata.rank);

% Compute derivative of train delay coordinates V
[Vtrain,dV] = cendiff4(V_(1:end-algdata.horizon,:),algdata.dt);
doff = 2;

% Compute regression and split into linear state transition matrix and 
% forcing matrix
Z = (Vtrain\dV)';
A = Z(1:end-1,1:end-1);
B = Z(1:end-1,end);

%% Reconstruct delay state
Lr = (1:size(Vtrain,1));
Lp = (1:algdata.horizon) + size(Vtrain,1);
u = V_(1+doff:end-(1+doff),end);
v0 = V_(1+doff,1:end-1);
Vi = havokreconstruct(A,B,u,v0,algdata.dt);
Vr = Vi(Lr,:);
Vp = Vi(Lp,:);
tr = algdata.t(Lr);
tp = algdata.t(Lp);

%% Calculate RMSE
Vtrain = Vtrain(:,1:end-1);
Vtest = V_(Lp+doff,1:end-1);
[RMSEVr,rmseVr] = rmse(Vtrain',Vr');
[RMSEVp,rmseVp] = rmse(Vtest',Vp');
[RMSEV,rmseV] = rmse([Vtrain' Vtest'],[Vr' Vp']);

%% Save in algdata
algdata.H = H;
algdata.rank = length(S_);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
algdata.A = A;
algdata.B = B;
algdata.vr = u;

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