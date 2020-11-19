function algdata = DMDc(algdata) % TODO

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Create Data matrices for Hankel matrix, training and test
Y = algdata.Y(:,1:end-algdata.horizon);
U = algdata.U(:,1:end-algdata.horizon);
Ytrain = algdata.Y(:,1:algdata.timesteps);
Ytest = algdata.Y(:,(1:algdata.horizon)+algdata.timesteps);

% Compute hankel matrices
Hx = hankmat(Y(:,1:end-1),algdata.delays,algdata.spacing);
Hxp = hankmat(Y(:,2:end),algdata.delays,algdata.spacing);
Hu = hankmat(U(:,1:end-1),algdata.delays,algdata.spacing);

% Stack hankel matrices
Omega = [Hx; Hu];

% Compute svd of Omega
[U1_,S1_,S1n,S1n_,V1_] = truncsvd(Omega,2*algdata.rank);

% Compute svd of Hxp
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(Hxp,algdata.rank);

% Compute approximation of operators A and B
Atilde = U2_'*Hxp*V1_/S1_*U1_(1:size(Hx,1),:)'*U2_;
Btilde = U2_'*Hxp*V1_/S1_*U1_(size(Hx,1)+1:end,:)';

Y_ = repmat(Y(:,1),1,algdata.timesteps);
for i = 2:algdata.timesteps
    Y_(:,i) = Atilde*Y(:,i-1) + Btilde*U(:,i-1);
end
plot(Y(1,:));
hold on;
plot(Y_(1,:));

% Compute modes of Atilde
[W,D] = eig(Atilde);
Phi = Hxp*V1_/S_*U1_(1:algdata.delays,:)'*U2_*W/D;
Phi = Phi(1:size(Y,1),:);
omega = log(diag(D))/algdata.dt;
b = (W*D)\(S1_*V1_(:,1)');

%% Reconstruct states
Lr = (1:size(Ytrain,2));
Lp = (1:algdata.horizon) + size(Ytrain,2);
tr = algdata.dt*(Lr-1);
tp = algdata.dt*(Lp-1);
Yr = dmdreconstruct(Phi,omega,b,[tr tp]);
Yp = Yr(:,Lp);
Yr = Yr(:,Lr);

%% Calculate RMSE
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.H = H; 
algdata.Hp = Hp;
algdata.rank = size(S_,1);
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