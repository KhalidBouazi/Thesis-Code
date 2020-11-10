function algdata = HDMD(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Compute hankel matrices
H = hankmat(algdata.Y(:,1:end-1),algdata.delays,algdata.spacing);
Hp = hankmat(algdata.Y(:,2:end),algdata.delays,algdata.spacing);

% Compute svd
[U,S,Sn,V] = truncsvd(H,algdata.rank);

% Compute transition matrix and its modes
Atilde = S\U'*Hp*V;
[W,D] = eig(Atilde);
Phi = U*W;
Phi = Phi(1:size(algdata.Y,1),:);
omega = log(diag(D))/algdata.dt;
b = (W*D)\(S*V(1,:)');

%% Reconstruct states and calculate rmse
t_ = algdata.dt*(0:size(H,2)-1);
Y_ = dmdreconstruct(Phi,omega,b,t_);
[rmseY_,rmseY_] = rmse(algdata.Y(:,1:size(H,2)),Y_);

%% Save in algdata
algdata.H = H;
algdata.Hp = Hp;
algdata.rank = size(S,1);
algdata.U = U;
algdata.s = diag(S);
algdata.sn = diag(Sn);
algdata.V = V;
algdata.Atilde = Atilde;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.b = b;
algdata.omega = omega;
algdata.Y_ = Y_;
algdata.RMSEY_ = RMSEY_;
algdata.rmseY_ = rmseY_;
algdata.t_ = t_;

end