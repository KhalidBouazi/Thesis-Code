function algdata = HAVOKc(algdata)

%% Start algorithm
% Compute hankel matrices
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);
Hu = hankmat(algdata.U,0,algdata.spacing);

% Compute svd of H
[U_,S_,Sn,Sn_,V_] = truncsvd(H,algdata.rank);
Vtrain = V_(1:end-algdata.horizon,:);

% Split in prior and posterior matrix
V = Vtrain(1:end-1,:);
Vp = Vtrain(2:end,:);

% Stack V and Hu horizontally
Omega = [V, Hu(:,1:size(V,1))'];

% Do regression and split into system and input matrix
Z = (Omega\Vp)';
A = Z(:,1:size(V,2));
B = Z(:,size(V,2)+1:end);

% Eigen values of A
[~,D] = eig(A);
omega = log(diag(D))/algdata.dt;

%% Reconstruct delay state
Lr = (1:size(Vtrain,1));
Lp = (1:algdata.horizon) + size(Vtrain,1);
Vi = havokcreconstruct(A,B,Hu',V(1,:),algdata.dt);
Vr = Vi(Lr,:);
Vp = Vi(Lp,:);
tr = algdata.dt*(Lr-1);
tp = algdata.dt*(Lp-1);

%% Calculate RMSE
Vtest = V_(Lp,:);
[RMSEVr,rmseVr] = rmse(Vtrain',Vr');
[RMSEVp,rmseVp] = rmse(Vtest',Vp');
[RMSEV,rmseV] = rmse([Vtrain' Vtest'],[Vr' Vp']);

%% Save in algdata
algdata.H = H;
algdata.Hu = Hu;
algdata.rank = length(S_);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
algdata.A = A;
algdata.B = B;
algdata.omega = omega;

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