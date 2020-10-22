function algdata = DMD(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank','delays','spacing'};
optargvals = {[],1,1};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);
X = H(:,1:end-1);
Xp = H(:,2:end);

[U,S,V] = truncsvd(X,algdata.rank);

Atilde = S\U'*Xp*V;
[W,D] = eigdec(Atilde);
Phi = Xp*V/S*W/D;
Phi = Phi(1:size(algdata.Y,1),:);
omega = log(diag(D))/algdata.dt;
b = (W*D)\(S*V(1,:)');

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