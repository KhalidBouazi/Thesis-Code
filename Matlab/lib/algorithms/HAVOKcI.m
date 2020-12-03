function algdata = HAVOKc(algdata)

%% Start algorithm
% Create Data matrices for hankel matrix
Y = algdata.Yn(:,1:end-algdata.horizon);
U = algdata.Un(:,1:end-algdata.horizon);

% Compute hankel matrices
H = hankmat(Y,algdata.delays,algdata.spacing);
Hu = hankmat(U(:,1:end-1),0,algdata.spacing);

% Compute svd of H
[U_,S_,Sn,Sn_,V_] = truncsvd(H,algdata.rank);

V = V_(1:end-1,:);
Vp = V_(2:end,:);

% Omega = [U_*S_*V'; Hu(:,1:size(V',2))];
Omega = [V, Hu(:,1:size(V,1))'];

% AB = (U_*S_*Vp')/Omega;
AB = (Omega\Vp)';
Atilde = AB(:,1:end-size(Hu,1));
Btilde = AB(:,end-size(Hu,1)+1:end);

Xi = havokreconstruct(Atilde,Btilde,U',V(1,:),algdata.dt);

% Compute modes of Atilde
[W,D] = eig(Atilde);
Phi = U_*S_*Vp'*V1_/S1_*U1_(1:d,:)'*U2_*W;
Phi = Phi(1:size(Y,1),:);
omega = log(diag(D))/algdata.dt;
% b = pinv(Phi)*Y(:,1);
% if rank < rank2
%     b = (W*D)\(S1_(1:rank2,1:rank2)*V1_(1,1:rank2)');
% else
%     b = (W*D)\(S2_*V2_(1,:)');
% end
b = (W*D)\(S1_(1:rank2,1:rank2)*V1_(1,1:rank2)');

B = Phi/W*Btilde;
B = B(:,1);

%% Reconstruct states
Lr = (1:length(algdata.tr));
Lp = (1:length(algdata.tp)) + length(algdata.tr);
Yi = dmdcreconstruct(D,Phi,b,B,algdata.U); % TODO Norm
Yr = Yi(:,Lr);
Yp = Yi(:,Lp);

%% Calculate RMSE
Ytrain = algdata.Y(:,Lr);
Ytest = algdata.Y(:,Lp);
[RMSEYr,rmseYr] = rmse(Ytrain,Yr);
[RMSEYp,rmseYp] = rmse(Ytest,Yp);
[RMSEY,rmseY] = rmse([Ytrain Ytest],[Yr Yp]);

%% Save in algdata
algdata.Hx = Hx; 
algdata.Hxp = Hxp;
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

% TODO
algdata = rmfield(algdata,'normValsY');

end