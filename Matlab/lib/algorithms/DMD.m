function algdata = DMD(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
H = hankmat(algdata.Y(:,1:end-1),algdata.delays,algdata.spacing);
Hp = hankmat(algdata.Y(:,2:end),algdata.delays,algdata.spacing);

[U,S,V] = truncsvd(H,algdata.rank);

Atilde = S\U'*Hp*V;
[W,D] = eig(Atilde);
Phi = Hp*V/S*W/D;
Phi = Phi(1:size(algdata.Y,1),:);
b = (W*D)\(S*V(1,:)'); %modeamp(Phi,algdata.Y); 
omega = log(diag(D))/algdata.dt;

%% Save in algdata
algdata.H = H; 
algdata.Hp = Hp;
algdata.rank = size(S,1);
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