function algdata = HAVOK__(algdata)

%% Start algorithm
% Compute hankel matrix of Y
Y = algdata.Y;
Yv = algdata.Yv;
Htrain = hankmat(Y,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);
Htrain_ = hankmat(algdata.Y_,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);
Htest = hankmat(Yv,algdata.delays,algdata.spacing,algdata.horizon+algdata.delays);

% Compute svd of hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(Htrain,algdata.rank);
V__ = Htrain_'*U_/S_;
% V = H'*U_/S_;
% V1 = V_(1:end-1,:)';
% V2 = V_(2:end,:)';
V1 = V_';
V2 = V__';
Vtest = Htest'*U_/S_;

% Compute regression and split into linear state transition matrix and 
% forcing matrix
Z = V2*pinv(V1);
A = Z(1:end-1,1:end-1);
B = Z(1:end-1,end);

% eigendecomposition of A for eigenvalues
[~,D] = eig(A);
omega = log(diag(D))/algdata.dt;

%% Reconstruct Training data
% Lr = (1:cols(V1));
% u = V1(end,:)';
% v0 = V1(1:end-1,1);
% Vi = havokreconstruct(A,B,u,v0,algdata.dt,1);
% Vr = Vi(Lr,:);
% tr = algdata.t(Lr);

Vr = [];
u = [];
Vr_ = [];
u_ = [];
V__ = [];
Y_ = [];
Ytrain = [];
for i = 1:cols(algdata.x0s)
    ui = V1(end,(1:algdata.timesteps-1+algdata.delays)+(algdata.timesteps-1+algdata.delays)*(i-1))';
    u = [u; ui];
    v0_ = V1(1:end-1,1+(algdata.timesteps-1+algdata.delays)*(i-1));
    v0(:,i) = v0_;
    Vi = havokreconstruct(A,B,ui,v0_,algdata.dt,1);
    Vr = [Vr; Vi];
    Vr_ = [Vr_; Vi(algdata.delays+1:end,:)];
    u_ = [u_; ui(algdata.delays+1:end)];
    V__ = [V__; V1(1:end-1,(algdata.delays+1:rows(Vi))+rows(Vi)*(i-1))'];
    
    Y_ = [Y_ Htrain(1:rows(Y),(algdata.delays+1:rows(Vi))+rows(Vi)*(i-1))];
    Ytrain = [Ytrain Htrain(1:rows(Y),(1:algdata.timesteps-1+algdata.delays)+(algdata.timesteps-1+algdata.delays)*(i-1))];
end
tr = algdata.tr(1:rows(Vr));

Yr_ = U_*S_*[Vr_'; u_'];
Yr = U_*S_*[Vr'; u'];
Yr_ = Yr_(1:rows(Y),:);
Yr = Yr(1:rows(Y),:);

%% Reconstruct Validation data
Vp = [];
uv = [];
Vp_ = [];
uv_ = [];
Vt = [];
Yv_ = [];
Ytest = [];
for i = 1:cols(algdata.xv0s)
    ui = Vtest((1:algdata.horizon+algdata.delays)+(algdata.horizon+algdata.delays)*(i-1),end);
    uv = [uv; ui];
    v0_ = Vtest(1+(algdata.horizon+algdata.delays)*(i-1),1:end-1)';
    v0v(:,i) = v0_;
    Vi = havokreconstruct(A,B,ui,v0_,algdata.dt,1);
    Vp = [Vp; Vi];
    uv_ = [uv_; ui(algdata.delays+1:end)];
    Vp_ = [Vp_; Vi(algdata.delays+1:end,:)];
    Vt = [Vt; Vtest((algdata.delays+1:rows(Vi))+rows(Vi)*(i-1),1:end-1)];
    
    Yv_ = [Yv_ Htest(1:rows(Yv),(algdata.delays+1:rows(Vi))+rows(Vi)*(i-1))];
    Ytest = [Ytest Htest(1:rows(Yv),(1:algdata.horizon+algdata.delays)+(algdata.horizon+algdata.delays)*(i-1))];
end
tp = algdata.tp(1:rows(Vp));

Yp_ = U_*S_*[Vp_'; uv_'];
Yp = U_*S_*[Vp'; uv'];
Yp_ = Yp_(1:rows(Y),:);
Yp = Yp(1:rows(Y),:);

% Lp = (1:algdata.horizon);
% v0v = Vtest(1,1:end-1);
% uv = Vtest(:,end);
% Vi = havokreconstruct(A,B,uv,v0v,algdata.dt,1);
% Vp = Vi(Lp,:);
% tp = algdata.tp(Lp);

%% Calculate RMSE
% Vtrain = V_(1:end-1,1:end-1);
% Vtest = Vtest(:,1:end-1);
% Vtrain = V1(1:end-1,:)';
% Vtest = Vtest(:,1:end-1);
% [RMSEVr,rmseVr] = rmse(Vtrain',Vr');
% [RMSEVp,rmseVp] = rmse(Vtest',Vp');
% [RMSEVr,rmseVr] = rmse(V__',Vr_');
% [RMSEVp,rmseVp] = rmse(Vt',Vp_');
% [RMSEVr,rmseVr] = rmse(Y_,Yr_);
% [RMSEVp,rmseVp] = rmse(Yv_,Yp_);
[RMSEVr,rmseVr] = rmse(Ytrain,Yr);
[RMSEVp,rmseVp] = rmse(Ytest,Yp);
[RMSEV,rmseV] = rmse([Ytrain Ytest],[Yr Yp]);

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
algdata.vrv = uv;
algdata.omega = omega;
algdata.d = diag(D);

% algdata.Vtrain = Vtrain;
% algdata.Vr = Vr;
algdata.Vtrain = Ytrain';
algdata.Vr = Yr';
algdata.tr = tr;
algdata.RMSEVr = RMSEVr;
algdata.rmseVr = rmseVr;
% algdata.Vtest = Vtest;
% algdata.Vp = Vp;
algdata.Vtest = Ytest';
algdata.Vp = Yp';
algdata.tp = tp;
algdata.RMSEVp = RMSEVp;
algdata.rmseVp = rmseVp;
algdata.RMSEV = RMSEV;
algdata.rmseV = rmseV;

end