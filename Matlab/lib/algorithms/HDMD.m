function algdata = HDMD(algdata)

%% Start algorithm
% Norm data matrix
[Yn,normValsY] = normdata(algdata.Y);
Yntrain = Yn(:,1:end-algdata.horizon);

% Compute hankel matrices
H = hankmat(Yntrain,algdata.delays,algdata.spacing);

% Transform through observables
H = observe(H,algdata.observables);

% Split
Hy = H(:,1:end-1);
Hyp = H(:,2:end);

% Compute svd of prior hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(Hy,algdata.rank);

% Compute transition matrix and its modes
Up_ = Hyp*V_/S_;
Atilde = U_'*Up_;
[W,D] = eig(Atilde);
Phi = Up_*W;
omega = log(diag(D))/algdata.dt;
b = (W*D)\(S_*V_(1,:)');

%% Reconstruct states
C = zeros(rows(Yntrain),rows(Phi));
C(1:rows(Yntrain),1:rows(Yntrain)) = eye(rows(Yntrain));
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Zi = dmdreconstruct(Phi,D,Hy(:,1),length(algdata.t));
Yi = (C*Zi) .* normValsY;
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);

%% Calculate RMSE
Ytrain = algdata.Y(:,Lr);
Ytest = algdata.Y(:,Lp);
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.H = H;
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