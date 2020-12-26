function algdata = EDMD(algdata)

%% Start algorithm
% Norm data matrix
[Yn,normValsY] = normdata(algdata.Y);
Yntrain = Yn(:,1:end-algdata.horizon);

% Compute hankel matrices
H = hankmat(Yntrain,algdata.delays,algdata.spacing);
Hy = H(:,1:end-1);
Hyp = H(:,2:end);

% Compute G and A
G = Hy*Hy';
B = Hy*Hyp';

% Compute svd of prior hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(G,algdata.rank);

% Compute Koopman Operator
A = V_/S_*U_'*B;
[W,D,Z] = eig(A);
Phi = W'*H;
Km = Z(1:size(Yntrain,1),:);
Yi = edmdreconstruct(Phi(:,1),Km,D,length(algdata.t)) .* normValsY;


%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = edmdreconstruct(Phi0, Km, D, timesteps) .* normValsY;
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