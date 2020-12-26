function algdata = kEDMD(algdata)

%% Start algorithm
% Norm data matrix
[Yn,normValsY] = normdata(algdata.Y);
Yntrain = Yn(:,1:end-algdata.horizon);

% Compute hankel matrices
H = hankmat(Yntrain,algdata.delays,algdata.spacing);
Hy = H(:,1:end-1);
Hyp = H(:,2:end);

% Compute inner product matrices (kernel)
G = compkernel(algdata.kernel,Hy); 
A = compkernel(algdata.kernel,Hy,Hyp);

% Compute eigendecomposition of G
[U,L] = eigdec(G);
S = L^(1/2);        % Singular values of Psix; Gramian G = Psix*Psix' = U*S^2*U' -> G*U = U*S^2

% Truncate Singular values
Sn = S./sum(diag(S));
idx = diag(S) > 1e-10;
Sn_ = Sn(idx,idx);
S_ = S(idx,idx);
U_ = U(:,idx);

% Compute Koopman operator
K = S_\U_'*A*U_/S_;

% Compute eigendecomposition of K
[W,D] = eig(K);
omega = log(diag(D))/algdata.dt;

% Compute eigenfunctions
Phi = U_*S_*W;
Phi = Phi(1,:);      % eigenfunction at t = 0

% Compute Koopman modes
v = (S_*W)\U_'*Hy(1:size(Yntrain,1),:)';  % take first n (n = # of measured states)

%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = dmdreconstruct(D,Phi,v,length(algdata.t)) .* normValsY;
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);

%% Calculate RMSE
Ytrain = algdata.Y(:,Lr);
Ytest = algdata.Y(:,Lp);
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.H = H; 
algdata.rank = length(S_);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.Atilde = K;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.v = v;
algdata.omega = omega;

algdata.Ytrain = Ytrain;
algdata.Yr = Yr;
algdata.RMSEYr = RMSEYr;
algdata.rmseYr = rmseYr;
algdata.Ytest = Ytest;
algdata.Yp = Yp;
algdata.RMSEYp = RMSEYp;
algdata.rmseYp = rmseYp;
algdata.RMSEY = RMSEY;
algdata.rmseY = rmseY;

end