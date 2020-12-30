function algdata = HDMDc(algdata)

%% Start algorithm
Y = algdata.Y;
Ytrain = Y(:,1:end-algdata.horizon);
U = algdata.U;
Utrain = U(:,1:end-algdata.horizon);

% Compute hankel matrices
H_ = hankmat(Y,algdata.delays,algdata.spacing);
H = hankmat(Ytrain,algdata.delays,algdata.spacing);
udelays = algdata.delays;
if ~algdata.uhasdelays
    udelays = 0;
end
Hu_ = hankmat(U,udelays,algdata.spacing);
Hu = hankmat(Utrain,udelays,algdata.spacing);

% Transform through observables
H = observe(H,algdata.observables);
d = rows(H);

% Norm data
[Hn,normValsH] = normdata(H);
[Hun,normValsHu] = normdata(Hu);

% Split
Hy = Hn(:,1:end-1);
Hyp = Hn(:,2:end);

% Stack prior state and input hankel matrices
Omega = [Hy; Hun(:,1:cols(Hy))];

% Compute svd of Omega
[U1_,S1_,~,~,V1_] = truncsvd(Omega,[]);
rank1 = length(S1_);

% Compute svd of Hyp
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(Hyp,algdata.rank);
rank2 = length(S2_);

% Compute approximation of operators A and B
G = Hyp*V1_/S1_*U1_';
A = normValsH\G(:,1:d)*normValsH;
B = normValsH\G(:,d+1:end)*normValsHu;

% Project matrices to output space
Atilde = U2_'*A*U2_;
Btilde = U2_'*B;

% Compute modes of Atilde
[W,D] = eig(Atilde);
Phi = (A*U2_)*W;
omega = log(diag(D))/algdata.dt;
if rank1 > rank2
    b = (W*D)\(S1_(1:rank2,1:rank2)*V1_(1,1:rank2)');
else
    b = (W*D)\(S2_*V2_(1,:)');
end

%% Reconstruct states
C = zeros(rows(Ytrain),rows(Phi));
C(1:rows(Ytrain),1:rows(Ytrain)) = eye(rows(Ytrain));
Lr = (1:cols(Hun));
Lp = (1:length(algdata.tp)) + length(Lr);
% Zi = dmdcreconstruct(A,B,Hu_,H(:,1));
% Yi = C*Zi;
Zi = dmdcreconstruct(Atilde,Btilde,Hu_,U2_'*H(:,1));
Yi = C*U2_*Zi;
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);
tr = algdata.t(Lr);
tp = algdata.t(Lp);

%% Calculate RMSE
Ytrain = Y(:,Lr);
Ytest = Y(:,Lp);
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.H = H; 
algdata.H_ = H_; 
algdata.Hu = Hu;
algdata.Hu_ = Hu_;
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