function algdata = DMDc(algdata)

%% Start algorithm
% Norm data matrices
[Yn,normValsY] = normdata(algdata.Y);
Yntrain = Yn(:,1:end-algdata.horizon);
Un = normdata(algdata.U);
Untrain = Un(:,1:end-algdata.horizon);

% % Compute hankel matrices
H = hankmat(Yntrain,algdata.delays,algdata.spacing);
udelays = algdata.delays;
if ~algdata.uhasdelays
    udelays = 0;
end
Hu_ = hankmat(Un,udelays,algdata.spacing);
Hu = hankmat(Untrain,udelays,algdata.spacing);

% Transform through observables
H = observe(H,algdata.observables);
d = rows(H);

% Split
Hy = H(:,1:end-1);
Hyp = H(:,2:end);

% Stack prior state and input hankel matrices
Omega = [Hy; Hu(:,1:cols(Hy))];

% Compute svd of Omega
[U1_,S1_,~,~,V1_] = truncsvd(Omega,[]);
rank1 = length(S1_);

% Compute svd of Hyp
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(Hyp,algdata.rank);
rank2 = length(S2_);

% Compute approximation of operators A and B
Up_ = Hyp*V1_/S1_;
G = Up_*U1_';
Atilde_ = G(:,1:d);
Btilde_ = G(:,d+1:end);

% Project matrices to output space
Atilde = U2_'*Atilde_*U2_;
Btilde = U2_'*Btilde_;

% Compute modes of Atilde
[W,D] = eig(Atilde);
Phi = (Atilde_*U2_)*W;
omega = log(diag(D))/algdata.dt;
if rank1 > rank2
    b = (W*D)\(S1_(1:rank2,1:rank2)*V1_(1,1:rank2)');
else
    b = (W*D)\(S2_*V2_(1,:)');
end
A = Phi*D*pinv(Phi);
B = (Atilde_*U2_)*Btilde;

%% Reconstruct states
C = zeros(rows(Yntrain),rows(Phi));
C(1:rows(Yntrain),1:rows(Yntrain)) = eye(rows(Yntrain));
Lr = (1:cols(Hu));
Lp = (1:length(algdata.tp)) + length(Lr);
Zi = dmdcreconstruct(A,B,Hu_,H(:,1));
Yi = (C*Zi) .* normValsY;
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);
tr = algdata.t(Lr);
tp = algdata.t(Lp);

%% Calculate RMSE
Ytrain = algdata.Y(:,Lr);
Ytest = algdata.Y(:,Lp);
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.H = H; 
algdata.Hu = Hu;
algdata.rank = length(S2_);
algdata.U_ = U2_;
algdata.s_ = diag(S2_);
algdata.sn = diag(S2n);
algdata.sn_ = diag(S2n_);
algdata.V_ = V2_;
algdata.Atilde = Atilde;
algdata.Btilde = Btilde;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.b = b;
algdata.omega = omega;
algdata.A = A;
algdata.B = B;

algdata.Ytrain = Ytrain;
algdata.Yr = Yr;
algdata.tr = tr;
algdata.RMSEYr = RMSEYr;
algdata.rmseYr = rmseYr;
algdata.Ytest = Ytest;
algdata.Yp = Yp;
algdata.tp = tp;
algdata.RMSEYp = RMSEYp;
algdata.rmseYp = rmseYp;
algdata.RMSEY = RMSEY;
algdata.rmseY = rmseY;

end