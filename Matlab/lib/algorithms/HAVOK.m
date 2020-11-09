function algdata = HAVOK(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Start algorithm
% Compute hankel matrix
H = hankmat(algdata.Y(:,1:end-1),algdata.delays,algdata.spacing);

% Compute svd
[U,S,V] = truncsvd(H,algdata.rank);

% Compute derivative of delay coordinates V
[Vs,dV] = cendiff4(V,algdata.dt);

% Compute regression and split into state transition matrix and forcing
% matrix
Z = (Vs\dV)';
A = Z(1:end-1,1:end-1);
B = Z(1:end-1,end);

%% Reconstruct delay state and calculate rmse
V_ = havokreconstruct(A,B,Vs,algdata.dt); % Reduce timesteps by difforder 
rmseV_ = rmse(Vs(:,1:end-1),V_);

%% Tests
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
algdata.rmseV_ = rmseV_;

end