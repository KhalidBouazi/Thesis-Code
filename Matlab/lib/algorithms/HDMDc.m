function algdata = HDMDc(algdata)

%% Start algorithm
Y = algdata.Y;
Yunobs = Y;
Y_ = algdata.Y_;
Yv = algdata.Yv;
U = algdata.U;
Uv = algdata.Uv;

% unobserved Hankel Matrix of Y
HYunobs = hankmat(Y,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);

% Transform through observables
Y = observe(Y,algdata.observables);
Y_ = observe(Y_,algdata.observables);
Yv = observe(Yv,algdata.observables);

% Compute hankel matrices
HY = hankmat(Y,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);
HY_ = hankmat(Y_,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);
HYv = hankmat(Yv,algdata.delays,algdata.spacing,algdata.horizon+algdata.delays);
if algdata.uhasdelays
    HU = hankmat(U,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);
    HUv = hankmat(Uv,algdata.delays,algdata.spacing,algdata.horizon+algdata.delays);
else
    HU = U;
    HUv = Uv;
end

% Norm data
[HYn,~] = normdata(HY);
[HY_n,normHY_] = normdata(HY_);
[HUn,normHU] = normdata(HU);
normHY_ = diag(normHY_);
normHU = diag(normHU);

% Compute svd of Omega
[U1_,S1_,~,~,V1_] = truncsvd([HYn; HUn(:,1:cols(HYn))],[]);
rank1 = length(S1_);

% Compute svd of Hyp
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(HY_n,algdata.rank);
rank2 = length(S2_);

% Compute best LS backtransformation from Z to Y
if strcmp(algdata.observables{1},'identity')
    G = eye(rows(HY));
else
    G = HYunobs*pinv(HY); %HYunobs/HY; 
end

% Compute approximation of operators A and B
K = HY_n*V1_/S1_*U1_';
A = normHY_\K(:,1:rows(K))*normHY_;
B = normHY_\K(:,rows(K)+1:end)*normHU;

% Project matrices to output space
Atilde = U2_'*A*U2_;
Btilde = U2_'*B;

% Change system structure for one input
[A_,B_] = oneinputsys(A,B,rows(U),algdata.delays);
[Atilde_,Btilde_] = oneinputsys(Atilde,Btilde,rows(U),algdata.delays);

% Compute modes of Atilde
[W,D] = eig(Atilde);
Phi = (A*U2_)*W;
omega = log(diag(D))/algdata.dt;
if rank1 > rank2
    b = (W*D)\(S1_(1:rank2,1:rank2)*V1_(1,1:rank2)');
else
    b = (W*D)\(S2_*V2_(1,:)');
end

% Y = algdata.Y;
% Ytrain = Y(:,1:end-algdata.horizon);
% U = algdata.U;
% Utrain = U(:,1:end-algdata.horizon);
% 
% % Transform through observables
% Y = observe(Y,algdata.observables);
% Ytrain = observe(Ytrain,algdata.observables);
% 
% %
% HYtrain = hankmat(Ytrain,algdata.delays,algdata.spacing); % ...
% HYtrain_ = HYtrain(:,2:end); 
% 
% % Compute hankel matrices
% HY = hankmat(Y,algdata.delays,algdata.spacing);
% HYtrain = hankmat(Ytrain,algdata.delays,algdata.spacing);
% HU = hankmat(U,algdata.uhasdelays*algdata.delays,algdata.spacing);
% HUtrain = hankmat(Utrain,algdata.uhasdelays*algdata.delays,algdata.spacing);
% 
% % Norm data
% [HYntrain,normHYtrain] = normdata(HYtrain);
% [HUntrain,normHUtrain] = normdata(HUtrain);
% normHYtrain = diag(normHYtrain);
% normHUtrain = diag(normHUtrain);
% 
% % Split
% HYnk = HYntrain(:,1:end-1);
% HYnk_ = HYntrain(:,2:end);
% HUnk = HUntrain(:,1:cols(HYnk));
% 
% % Compute svd of Omega
% [U1_,S1_,~,~,V1_] = truncsvd([HYnk; HUnk],[]);
% rank1 = length(S1_);
% 
% % Compute svd of Hyp
% [U2_,S2_,S2n,S2n_,V2_] = truncsvd(HYnk_,algdata.rank);
% rank2 = length(S2_);
% 
% % Compute best LS backtransformation from Z to Y
% G = HYtrain_/HYnk_;
% 
% % Compute approximation of operators A and B
% K = HYnk_*V1_/S1_*U1_';
% A = normHYtrain\K(:,1:rows(K))*normHYtrain;
% B = normHYtrain\K(:,rows(K)+1:end)*normHUtrain;
% 
% % Project matrices to output space
% Atilde = U2_'*A*U2_;
% Btilde = U2_'*B;
% % isctrb = rank(ctrb(A,B)) == rows(B)
% 
% % Change system structure for one input
% [A_,B_] = oneinputsys(A,B,rows(U));
% [Atilde_,Btilde_] = oneinputsys(Atilde,Btilde,rows(U));
% 
% % Compute modes of Atilde
% [W,D] = eig(Atilde);
% Phi = (A*U2_)*W;
% omega = log(diag(D))/algdata.dt;
% if rank1 > rank2
%     b = (W*D)\(S1_(1:rank2,1:rank2)*V1_(1,1:rank2)');
% else
%     b = (W*D)\(S2_*V2_(1,:)');
% end

%% Reconstruct states
C = zeros(rows(Y),rows(Phi));
C(1:rows(Y),1:rows(Y)) = eye(rows(Y));
Yr = [];
Yr_ = [];
Y_ = [];
for i = 1:cols(algdata.x0s)
    u = HU(:,(1:algdata.timesteps+algdata.delays-1)+(algdata.timesteps+algdata.delays-1)*(i-1));
    y0_ = U2_'*HY(:,1+(algdata.timesteps+algdata.delays-1)*(i-1));
%     y0_ = HY(:,1+(algdata.timesteps-1)*(i-1));
    y0(:,i) = y0_;
    Zi = dmdcreconstruct(Atilde,Btilde,u,y0_);
%     Zi = dmdcreconstruct(A,B,u,y0_);
    Yr = [Yr C*U2_*Zi];
%     Yr = [Yr C*Zi];
    Yr_ = [Yr_ C*U2_*Zi(:,algdata.delays+1:end)];
    Y_ = [Y_ C*HY(:,(algdata.delays+1:cols(Zi))+cols(Zi)*(i-1))];
end

%% Reconstruct Validation
Yp = [];
Yp_ = [];
Yv_ = [];
for i = 1:cols(algdata.xv0s)
    u = HUv(:,(1:algdata.horizon+algdata.delays)+(algdata.horizon+algdata.delays)*(i-1));
    y0_ = U2_'*HYv(:,1+(algdata.horizon+algdata.delays)*(i-1));
%     y0_ = HYv(:,1+(algdata.horizon)*(i-1));
    y0v(:,i) = y0_;
    Zi = dmdcreconstruct(Atilde,Btilde,u,y0_);
%     Zi = dmdcreconstruct(A,B,u,y0_);
    Yp = [Yp C*U2_*Zi];
%     Yp = [Yp C*Zi];
    Yp_ = [Yp_ C*U2_*Zi(:,algdata.delays+1:end)];
    Yv_ = [Yv_ C*HYv(:,(algdata.delays+1:cols(Zi))+cols(Zi)*(i-1))];
end


%% Reconstruct states
% C = zeros(rows(Y),rows(Phi));
% C(1:rows(Y),1:rows(Y)) = eye(rows(Y));
% Lr = (1:cols(algdata.tr));
% Lp = (1:length(algdata.tp)) + length(Lr);
% % Zi = dmdcreconstruct(A,B,HU,HY(:,1));
% % Yi = C*Zi;
% HY0tilde = U2_'*HY(:,1);
% Zi = dmdcreconstruct(Atilde,Btilde,HU,HY0tilde);
% Yi = C*U2_*Zi;
% Yr = Yi(:,Lr);
% Yp = Yi(:,Lp);
% tr = algdata.t(Lr);
% tp = algdata.t(Lp);

%% Calculate RMSE
Y = HY(1:rows(Y),:);
Yv = HYv(1:rows(Y),:);
tr = algdata.tr(1:cols(Y));
tp = algdata.tp(1:cols(Yv));
% [RMSEYr,rmseYr] = rmse(Y_,Yr_);
% [RMSEYp,rmseYp] = rmse(Yv_,Yp_);
[RMSEYr,rmseYr] = rmse(Y,Yr);
[RMSEYp,rmseYp] = rmse(Yv,Yp);
[RMSEY,rmseY] = rmse([Y Yv],[Yr Yp]);

%% From observables back to states
% if strcmp(algdata.observables{1},'monomial') & algdata.observables{2}(1) ~= 1
%     Yr = Yr(1:rows(Yunobs),:).^(1/algdata.observables{2}(1));
%     Yr = real(Yr);
%     [RMSEYr,rmseYr] = rmse(HYunobs(1:rows(Yunobs),:),Yr);
% end

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
algdata.A = A;
algdata.B = B;
algdata.A_ = A_;
algdata.B_ = B_;
algdata.G = G;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.b = b;
algdata.omega = omega;

algdata.y0 = y0;
algdata.y0v = y0v;
algdata.Ytrain = Y;
algdata.Yr = Yr;
algdata.tr = tr;
algdata.RMSEYr = RMSEYr;
algdata.rmseYr = rmseYr;
algdata.Ytest = Yv;
algdata.Yp = Yp;
algdata.tp = tp;
algdata.RMSEYp = RMSEYp;
algdata.rmseYp = rmseYp;
algdata.RMSEY = RMSEY;
algdata.rmseY = rmseY;
% algdata.RMSEYrunobs = RMSEYrunobs;
% algdata.rmseYrunobs = rmseYrunobs;

end