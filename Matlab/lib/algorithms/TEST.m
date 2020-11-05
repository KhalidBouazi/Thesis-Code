function algdata = TEST(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);

[U,S,V] = truncsvd(H,algdata.rank);

[V_,dV] = cendiff4((S*V'),algdata.dt);
X = dV*pinv(V_);
%A = X(1:end-1,1:end-1)';
A = X(1:end,1:end)';
B = X(end,1:end-1)';

% Atilde = V2*pinv(V1);
% [W,D] = eig(Atilde);
% Phi = W;
% Phi = Phi(1:size(V1,1),:);
% b = (W*D)\(S*V(1,:)');
% omega = log(diag(D))/algdata.dt;

%% Save in algdata
algdata.H = H;
algdata.U = U;
algdata.s = diag(S);
algdata.V = V;
algdata.A = A;
algdata.B = B;

% algdata.Atilde = Atilde;
% algdata.W = W;
% algdata.d = diag(D);
% algdata.Phi = Phi;
% algdata.omega = omega;
% algdata.b = b;

end