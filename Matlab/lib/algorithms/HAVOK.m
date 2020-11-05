function algdata = HAVOK(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);

[U,S,V] = truncsvd(H,algdata.rank);

[Vs,dV] = cendiff4(V,algdata.dt);
X = (Vs\dV)';
A = X(1:end-1,1:end-1);
B = X(1:end-1,end);
% A = X(1:end,1:end);
% B = X(1:end,end);

L = 1:(algdata.timesteps-5);
u = Vs(L,end); %zeros(length(L),1); 
V0 = Vs(1,1:end-1);
% V0 = Vs(1,1:end);

sys = ss(A,B,eye(size(A,1)),0*B);
[V_,~] = lsim(sys,u,algdata.dt*(L-1),V0);

% W = S*pinv(V);
% assignin('base','W',W);

% m = size(U,2);
% K = zeros(m);
% for i = 1:m
%     for j = 1:m
%         dU = diff(U(:,j));
%         K(i,j) = U(:,i)' * [dU;dU(end)] / algdata.dt;
%     end
% end

% s = diag(S);
% m = size(V,2);
% Kv = zeros(m);
% for i = 1:m
%     for j = 1:m
%         dV = diff(V(:,j));
%         Kv(i,j) = s(j)/s(i) * V(:,i)' * [dV;dV(end)] / algdata.dt;
%     end
% end

% assignin('base','K',K);


%% Save in algstruct(i)
algdata.H = H;
algdata.rank = size(S,1);
algdata.U = U;
algdata.s = diag(S);
algdata.V = V;
algdata.A = A;
algdata.B = B;
algdata.V_ = V_;

end