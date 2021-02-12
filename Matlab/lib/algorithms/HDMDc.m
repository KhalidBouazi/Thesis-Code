function algdata = HDMDc(algdata)

%% Start algorithm
Y = algdata.Y;
Ytrain = Y(:,1:end-algdata.horizon);
U = algdata.U;
Utrain = U(:,1:end-algdata.horizon);

% Transform through observables
Y = observe(Y,algdata.observables);
Ytrain = observe(Ytrain,algdata.observables);

% Compute hankel matrices
HY = hankmat(Y,algdata.delays,algdata.spacing);
HYtrain = hankmat(Ytrain,algdata.delays,algdata.spacing);
HU = hankmat(U,algdata.uhasdelays*algdata.delays,algdata.spacing);
HUtrain = hankmat(Utrain,algdata.uhasdelays*algdata.delays,algdata.spacing);

% Norm data
[HYntrain,normHYtrain] = normdata(HYtrain);
[HUntrain,normHUtrain] = normdata(HUtrain);
normHYtrain = diag(normHYtrain);
normHUtrain = diag(normHUtrain);

% Split
HYnk = HYntrain(:,1:end-1);
HYnk_ = HYntrain(:,2:end);
HUnk = HUntrain(:,1:cols(HYnk));

% Compute svd of Omega
[U1_,S1_,~,~,V1_] = truncsvd([HYnk; HUnk],[]);
rank1 = length(S1_);

% Compute svd of Hyp
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(HYnk_,algdata.rank);
rank2 = length(S2_);

% Compute approximation of operators A and B
G = HYnk_*V1_/S1_*U1_';
A = normHYtrain\G(:,1:rows(G))*normHYtrain;
B = normHYtrain\G(:,rows(G)+1:end)*normHUtrain;

% Project matrices to output space
Atilde = U2_'*A*U2_;
Btilde = U2_'*B;
% isctrb = rank(ctrb(A,B)) == rows(B)

% Change structure for one input
if cols(Btilde) > 1
    O_ = zeros(cols(Btilde)-2*rows(U),rows(U));
    I_ = [O_, eye(rows(O_));
          zeros(rows(U)), zeros(rows(U),rows(O_))];
    B_ = Btilde(:,1:end-rows(U));
    U_ = eye(rows(U),rows(U));
else
    I_ = [];
    B_ = [];
    O_ = [];
    U_ = [];
end
Atilde_ = [Atilde, B_;
           zeros(cols(Btilde)-rows(U),rows(Atilde)), I_];
Btilde_ = [Btilde(:,end-rows(U)+1:end); O_; U_];
% isctrb = rank(ctrb(Atilde_,Btilde_)) == rows(Btilde)

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
C = zeros(rows(Y),rows(Phi));
C(1:rows(Y),1:rows(Y)) = eye(rows(Y));
Lr = (1:cols(HUnk));
Lp = (1:length(algdata.tp)) + length(Lr);
% Zi = dmdcreconstruct(A,B,HU,HY(:,1));
% Yi = C*Zi;
HY0 = U2_'*HY(:,1);
Zi = dmdcreconstruct(Atilde,Btilde,HU,HY0);
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
algdata.H = HY; 
algdata.Hu = HU;
algdata.rank = length(S2_);
algdata.U_ = U2_;
algdata.s_ = diag(S2_);
algdata.sn = diag(S2n);
algdata.sn_ = diag(S2n_);
algdata.V_ = V2_;
algdata.Atilde = Atilde;
algdata.Btilde = Btilde;
algdata.Atilde_ = Atilde_;
algdata.Btilde_ = Btilde_;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.b = b;
algdata.omega = omega;
algdata.A = A;
algdata.B = B;

algdata.HY0 = HY0;
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