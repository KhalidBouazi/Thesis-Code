function algdata = kDMDc(algdata)

%% Start algorithm
% Norm data matrix
[Yn,normValsY] = normdata(algdata.Y);
Yntrain = Yn(:,1:end-algdata.horizon);
Un = normdata(algdata.U);
Untrain = Un(:,1:end-algdata.horizon);

% Compute hankel matrices
H = hankmat(Yntrain,algdata.delays,algdata.spacing);
Hu_ = hankmat(Un,0,algdata.spacing);
Hu = hankmat(Untrain,0,algdata.spacing);

% Split
Hy = H(:,1:end-1);
Hyp = H(:,2:end);
Hu = Hu(:,1:cols(Hy));

% Compute inner product matrices (kernel)
Gx = compkernel(algdata.kernel,Hy); 
Gy = compkernel(algdata.kernel,Hyp);
Gu = Hu'*Hu;

% Compute eigendecomposition of G
[U,L] = eigdec(Gx+Gu);
S = L^(1/2);        % Singular values of Psix; Gramian G = Psix*Psix' = U*S^2*U' -> G*U = U*S^2

% Truncate Singular values
Sn = S./sum(diag(S));
idx = diag(S) > 1e-4;
if ~isempty(algdata.rank) && algdata.rank < sum(idx(:)==1)
    r = algdata.rank;
    Sn_ = Sn(1:r,1:r);
    S_ = S(1:r,1:r);
    U_ = U(:,1:r);
else
    Sn_ = Sn(idx,idx);
    S_ = S(idx,idx);
    U_ = U(:,idx);
end

% Compute Koopman operator
K = S_\U_'*Gy*U_/S_;

% Compute eigendecomposition of K
[W,D] = eig(K);
omega = log(diag(D))/algdata.dt;

% Compute eigenfunctions
Phi = U_*S_*W;
Phi = Phi(1,:);      % eigenfunction at t = 0

% Compute Koopman modes
v1 = (S_*W)\U_'*Hy(1:size(Yntrain,1),:)'; 
v2 = (S_*W)\U_'*Hu'; 

%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = kmdreconstruct(Phi,D,v1,length(algdata.t)) .* normValsY;
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
algdata.Hu = Hu; 
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