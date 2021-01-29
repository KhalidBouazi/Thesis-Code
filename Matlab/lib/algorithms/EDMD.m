function algdata = EDMD(algdata)

%% Start algorithm
Y = algdata.Y;
Ytrain = Y(:,1:end-algdata.horizon);

% Transform through observables
HY = observe(Y,algdata.observables);
HYtrain = observe(Ytrain,algdata.observables);

% Compute hankel matrices
HY = hankmat(HY,algdata.delays,algdata.spacing);
HYtrain = hankmat(HYtrain,algdata.delays,algdata.spacing);

% Norm data
[HYntrain,normHYtrain] = normdata(HYtrain);

% Split
HYk = HYntrain(:,1:end-1);
HYk_ = HYntrain(:,2:end);

% Compute G and A
G = HYk*HYk';
B = HYk*HYk_';

% Compute svd of prior hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(G,algdata.rank);

% Compute Koopman Operator
A = V_/S_*U_'*B;
[W,D,Z] = eig(A);
Phi = HYk'*W;
omega = log(diag(D))/algdata.dt;
Km = Z;

%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = kmdreconstruct(Phi(1,:),D,Km,length(Lr)+length(Lp));
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);

%% Calculate RMSE
Ytrain = HY(:,Lr);
Ytest = HY(:,Lp);
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.H = HYtrain; 
algdata.rank = length(S_);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
algdata.W = W;
algdata.A = A;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.omega = omega;
algdata.Km = Km;

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