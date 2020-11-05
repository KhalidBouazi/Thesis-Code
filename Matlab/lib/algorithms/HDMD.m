function algdata = HDMD(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
H = hankmat(algdata.Y(:,1:end-1),algdata.delays,algdata.spacing);
Hp = hankmat(algdata.Y(:,2:end),algdata.delays,algdata.spacing);

[U,S,V] = truncsvd(X,algdata.rank);

Atilde = S\U'*Xp*V;
[W,D] = eigdec(Atilde);
Phi = U*W; %Xp*V/S*W/D;
Phi = Phi(1:size(algdata.Y,1),:);
b = (W*D)\(S*V(1,:)');
omega = log(diag(D))/algdata.dt;

%% Save in algdata
algdata.H = H;
algdata.U = U;
algdata.s = diag(S);
algdata.V = V;
algdata.Atilde = Atilde;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.omega = omega;
algdata.b = b;

end