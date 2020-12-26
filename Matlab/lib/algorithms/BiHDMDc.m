function algdata = BiHDMDc(algdata)

%% Start algorithm
% Norm data matrices
[Yn,normValsY] = normdata(algdata.Y);
Yntrain = Yn(:,1:end-algdata.horizon);
Un = normdata(algdata.U);
Untrain = Un(:,1:end-algdata.horizon);

% Compute hankel matrices
H = hankmat(Yntrain,algdata.delays,algdata.spacing);
Hy = H(:,1:end-1);
Hyp = H(:,2:end);
Hu = hankmat(Untrain,0,algdata.spacing);
d = rows(Hy);

% Compute bilinear input matrix
UX = Hu(:,1:cols(Hy)).*Hy;

% Stack prior state and input hankel matrices
Omega = [Hy; UX];

% Compute svd of Hxp
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(Hyp,algdata.rank);
rank2 = length(S2_);

% Compute svd of Omega
[U1_,S1_,S1n,S1n_,V1_] = truncsvd(Omega,[]);
rank = length(S1_);

% Compute approximation of operators A and B
Atilde = U2_'*Hyp*V1_/S1_*U1_(1:d,:)'*U2_;
Btilde = U2_'*Hyp*V1_/S1_*U1_(d+1:end,:)';

% Compute modes of Atilde
[W,D] = eig(Atilde);
Phi = Hyp*V1_/S1_*U1_(1:d,:)'*U2_*W;
Phi = Phi(1:rows(Yntrain),:);
omega = log(diag(D))/algdata.dt;
% b = pinv(Phi)*Y(:,1);
if rank > rank2
    b = (W*D)\(S1_(1:rank2,1:rank2)*V1_(1,1:rank2)');
else
    b = (W*D)\(S2_*V2_(1,:)');
end
B = Phi/W*Btilde;
B = B(:,1);

%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = bidmdcreconstruct(D,Phi,b,B,Un) .* normValsY;
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
algdata.rank = length(S2_);
algdata.U_ = U2_;
algdata.s_ = diag(S2_);
algdata.sn = diag(S2n);
algdata.sn_ = diag(S2n_);
algdata.V_ = V2_;
algdata.Atilde = Atilde;
algdata.Btilde = Btilde;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.b = b;
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