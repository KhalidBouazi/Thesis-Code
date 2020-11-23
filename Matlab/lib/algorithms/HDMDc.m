function algdata = HDMDc(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Create Data matrices for Hankel matrix
Y = algdata.Yn(:,1:end-algdata.horizon);
U = algdata.U(:,1:end-algdata.horizon);

% Compute hankel matrices
Hx = hankmat(Y(:,1:end-1),algdata.delays,algdata.spacing);
Hxp = hankmat(Y(:,2:end),algdata.delays,algdata.spacing);
Hu = hankmat(U(:,1:end-1),1,algdata.spacing);

% Stack hankel matrices
Omega = [Hx; Hu(:,1:size(Hx,2))];

% Compute svd of Omega
[U1_,S1_,S1n,S1n_,V1_] = truncsvd(Omega,2*algdata.rank);

% Compute svd of Hxp
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(Hxp,algdata.rank);

% Compute approximation of operators A and B
Atilde = U2_'*Hxp*V1_/S1_*U1_(1:size(Hx,1),:)'*U2_;
Btilde = U2_'*Hxp*V1_/S1_*U1_(size(Hx,1)+1:end,:)';

% Compute modes of Atilde
[W,D] = eig(Atilde);
Phi = Hxp*V1_/S1_*U1_(1:size(Hx,1),:)'*U2_*W/D;
Phi = Phi(1:size(Y,1),:);
omega = log(diag(D))/algdata.dt;
b = pinv(Phi)*Y(:,1);
B = Phi/W*Btilde;

%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = dmdcreconstruct(D,Phi,b,B,algdata.U) * algdata.normValsY;
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);

%% Calculate RMSE
Ytrain = algdata.Y(:,Lr);
Ytest = algdata.Y(:,Lp);
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.Hx = Hx; 
algdata.Hxp = Hxp;
algdata.Hu = Hu;
algdata.rank = size(S1_,1);
algdata.U_ = U1_;
algdata.s_ = diag(S1_);
algdata.sn = diag(S1n);
algdata.sn_ = diag(S1n_);
algdata.V_ = V1_;
algdata.Atilde = Atilde;
algdata.Btilde = Btilde;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.b = b;
algdata.omega = omega;

algdata.Ytrain = Ytrain;
algdata.Yr = Yr;
algdata.RMSEYr = RMSEYr;
algdata.rmseYr = rmseYr;
algdata.Ytest = Ytest;
algdata.Yp = Yp;
algdata.RMSEYp = RMSEYp;
algdata.rmseYp = rmseYp;
algdata.RMSEY = RMSEY;
algdata.rmseY = rmseY;

end