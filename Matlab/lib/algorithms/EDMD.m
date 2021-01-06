function algdata = EDMD(algdata)

%% Start algorithm
Y = algdata.Y;
Ytrain = Y(:,1:end-algdata.horizon);

% Compute hankel matrices
HYtrain = hankmat(Ytrain,algdata.delays,algdata.spacing);

% Transform through observables
HYtrain = observe(HYtrain,algdata.observables);

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
Km = Z;

%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = kmdreconstruct(Phi(1,:),D,Km,length(Lr)+length(Lp));
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);

%% Calculate RMSE
Ytrain = HYtrain(:,Lr);
Ytest = HYtrain(:,Lp);
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
algdata.Atilde = Atilde;
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