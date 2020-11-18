function algdata = DMDc(algdata) % TODO

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Create Data matrices for Hankel matrix, training and test
Y = algdata.Y(:,1:end-algdata.horizon);
Ytrain = algdata.Y(:,1:algdata.timesteps);
Ytest = algdata.Y(:,(1:algdata.horizon)+algdata.timesteps);

% Compute hankel matrices
H = hankmat(Y(:,1:end-1),algdata.delays,algdata.spacing);
Hp = hankmat(Y(:,2:end),algdata.delays,algdata.spacing);

% Compute svd
[U,S,Sn,V] = truncsvd(H,algdata.rank);

% Compute transition matrix and its modes
Atilde = S\U'*Hp*V;
[W,D] = eig(Atilde);
Phi = Hp*V/S*W/D;
Phi = Phi(1:size(algdata.Y,1),:);
omega = log(diag(D))/algdata.dt;
b = (W*D)\(S*V(1,:)');

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
algdata.rank = size(S,1);
algdata.U_ = U;
algdata.s_ = diag(S);
algdata.sn_ = diag(Sn);
algdata.V_ = V;
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