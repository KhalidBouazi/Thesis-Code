function algdata = HAVOK_(algdata)

%% Start algorithm
% Compute hankel matrix of Y
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);
Htrain = hankmat(algdata.Y(:,1:end-algdata.horizon),algdata.delays,algdata.spacing);

% Compute svd of hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(Htrain,algdata.rank);
V = H'*U_/S_;

% Compute derivative of train delay coordinates V
[Vtrain,dV] = cendiff4(V_,algdata.dt);
doff = 2;

% Compute regression and split into linear state transition matrix and 
% forcing matrix
Z = (Vtrain\dV)';
A = Z;
B = zeros(rows(A),1);

% eigendecomposition of A for eigenvalues
[~,D] = eig(A);
omega = diag(D);

%% Reconstruct delay state
Lr = (1:rows(Vtrain));
Lp = (1:algdata.horizon) + rows(Vtrain);
u_p = conv(algdata.Y,U_(:,end))'/S_(end:end);
u_p = u_p((rows(U_)+2):end-(rows(U_)+2));
u = zeros(length(Lr)+length(Lp),1);
v0 = V_(1+doff,:);
Vi = havokreconstruct(A,B,u,v0,algdata.dt);
Vr = Vi(Lr,:);
Vp = Vi(Lp,:);
tr = algdata.t(Lr);
tp = algdata.t(Lp);
Y_ = U_*S_*[Vr' Vp'];

%% Calculate RMSE
Vtest = V(Lp+doff,:);
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