function algdata = HAVOK(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank','delays','spacing'};
optargvals = {[],1,1};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);

[U,S,V] = truncsvd(H,algdata.rank);

% [V,dV] = cendiff4(V,algdata.dt);
% X = V\dV;
% A = X(1:end-1,1:end-1)';
% B = X(end,1:end-1)';

%% Save in algstruct(i)
algdata.H = H;
algdata.U = U;
algdata.s = diag(S);
algdata.V = V;
%algdata.dV = dV;
%algdata.A = A;
%algdata.B = B;

end