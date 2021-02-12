function algdata = HDMD(algdata)

%% Start algorithm
Y = algdata.Y;
Ytrain = Y(:,1:end-algdata.horizon);

% Transform through observables
HYtrain = observe(Ytrain,algdata.observables); %% getauscht

% Compute hankel matrices
HYtrain = hankmat(HYtrain,algdata.delays,algdata.spacing);

% Norm data
[HYntrain,normHYtrain] = normdata(HYtrain);
normHYtrain = diag(normHYtrain);

% Split
HYk = HYtrain(:,1:end-1);
HYnk = HYntrain(:,1:end-1);
HYnk_ = HYntrain(:,2:end);

% Compute svd of prior hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(HYnk,algdata.rank);

% Compute transition matrix and its modes
A = normHYtrain\(HYnk_*V_/S_*U_')*normHYtrain;

Atilde = U_'*A*U_;
A_ = S_\Atilde*S_;

[W,D] = eig(Atilde);
Phi = (A*U_)*W;
omega = log(diag(D))/algdata.dt;
b = (W*D)\(S_*V_(1,:)');

%% Reconstruct states
C = zeros(rows(Ytrain),rows(Phi));
C(1:rows(Ytrain),1:rows(Ytrain)) = eye(rows(Ytrain));
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
% Zi = dmdreconstruct(A,HYk(:,1),length(algdata.t));
% Yi = C*Zi;
y0 = U_'*HYk(:,1);
Zi = dmdreconstruct(Atilde,y0,length(algdata.t));
Yi = C*U_*Zi;
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);

%% Calculate RMSE
Ytrain = Y(:,Lr);
Ytest = Y(:,Lp);
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
algdata.A = A;
algdata.y0 = y0;

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