function algdata = HAVOK__(algdata)

%% Start algorithm
% Compute hankel matrix of Y
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);
Htrain = hankmat(algdata.Y(:,1:end-algdata.horizon),algdata.delays,algdata.spacing);

% Compute svd of hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(Htrain,algdata.rank);
V = H'*U_/S_;
V1 = V_(1:end-1,:)';
V2 = V_(2:end,:)';

% Compute regression and split into linear state transition matrix and 
% forcing matrix
Z = V2*pinv(V1);
A = Z(1:end-1,1:end-1);
B = Z(1:end-1,end);

% eigendecomposition of A for eigenvalues
[~,D] = eig(A);
omega = log(diag(D))/algdata.dt;

%% Reconstruct delay state
Lr = (1:cols(V1));
Lp = []; %(1:algdata.horizon) + rows(Vtrain);
u = V_(1:end-1,end);
u_p = conv(algdata.Y,U_(:,end))'/S_(end:end);
u_p = u_p(rows(U_):end-rows(U_));
v0 = V1(1:end-1,1);
Vi = dmdreconstruct(A,v0,length(Lr)+length(Lp))';
Vr = Vi(Lr,:);
Vp = Vi(Lp,:);
tr = algdata.t(Lr);
tp = algdata.t(Lp);
Y_ = U_*S_*[[Vr' Vp']; u'];

%% Calculate RMSE
Vtrain = V_(1:end-1,1:end-1);
Vtest = V(Lp,1:end-1);
[RMSEVr,rmseVr] = rmse(Vtrain',Vr');
[RMSEVp,rmseVp] = rmse(Vtest',Vp');
[RMSEV,rmseV] = rmse([Vtrain' Vtest'],[Vr' Vp']);

%% Save in algdata
algdata.H = Htrain;
algdata.rank = length(S_);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
algdata.A = A;
algdata.B = B;
algdata.vr = u;
algdata.omega = omega;
algdata.d = diag(D);

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