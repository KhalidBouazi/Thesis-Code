function algdata = HDMD(algdata)

%% Start algorithm
Y = algdata.Y;
Yunobs = Y;
Y_ = algdata.Y_;
Yv = algdata.Yv;

% unobserved Hankel Matrix of Y
HYunobs = hankmat(Y,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);

% Transform through observables
Y = observe(Y,algdata.observables);
Y_ = observe(Y_,algdata.observables);
Yv = observe(Yv,algdata.observables);

% Compute hankel matrices
HY = hankmat(Y,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays); %%
HY_ = hankmat(Y_,algdata.delays,algdata.spacing,algdata.timesteps-1+algdata.delays);
HYv = hankmat(Yv,algdata.delays,algdata.spacing,algdata.horizon+algdata.delays);

% Norm data
[HYn,~] = normdata(HY);
[HY_n,normHY_] = normdata(HY_);
normHY_ = diag(normHY_);

% Compute svd of prior hankel matrix
[U_,S_,Sn,Sn_,V_] = truncsvd(HYn,algdata.rank);

% Compute transition matrix and its modes
A = normHY_\(HY_n*V_/S_*U_')*normHY_;

Atilde = U_'*A*U_;
[W,D] = eig(Atilde);
Phi = (A*U_)*W;
omega = log(diag(D))/algdata.dt;
b = (W*D)\(S_*V_(1,:)');

% Y = algdata.Y;
% Ytrain = Y(:,1:end-algdata.horizon);
% 
% Transform through observables
% HYtrain = observe(Ytrain,algdata.observables); %% getauscht
% 
% Compute hankel matrices
% HYtrain = hankmat(HYtrain,algdata.delays,algdata.spacing);
% 
% Norm data
% [HYntrain,normHYtrain] = normdata(HYtrain);
% normHYtrain = diag(normHYtrain);
% 
% Split
% HYk = HYtrain(:,1:end-1);
% HYnk = HYntrain(:,1:end-1);
% HYnk_ = HYntrain(:,2:end);
% 
% Compute svd of prior hankel matrix
% [U_,S_,Sn,Sn_,V_] = truncsvd(HYnk,algdata.rank);
% 
% Compute transition matrix and its modes
% A = normHYtrain\(HYnk_*V_/S_*U_')*normHYtrain;
% 
% Atilde = U_'*A*U_;
% A_ = S_\Atilde*S_;
% 
% [W,D] = eig(Atilde);
% Phi = (A*U_)*W;
% omega = log(diag(D))/algdata.dt;
% b = (W*D)\(S_*V_(1,:)');

%% Reconstruct states
C = zeros(rows(Y),rows(Phi));
C(1:rows(Y),1:rows(Y)) = eye(rows(Y));
Yr = [];
Yr_ = [];
Y_ = [];
for i = 1:cols(algdata.x0s)
    y0_ = U_'*HY(:,1+(algdata.timesteps+algdata.delays-1)*(i-1));
    y0(:,i) = y0_;
    Zi = dmdreconstruct(Atilde,y0_,algdata.timesteps-1+2*algdata.delays-1); %*2 nicht vergessen
    Yr = [Yr C*U_*Zi];
    Yr_ = [Yr_ C*U_*Zi(:,algdata.delays+1:end)];
    Y_ = [Y_ Y(:,(algdata.delays+1:cols(Zi))+cols(Zi)*(i-1))];
end

%% Reconstruct Validation
Yp = [];
Yp_ = [];
Yv_ = [];
for i = 1:cols(algdata.xv0s)
    y0_ = U_'*HYv(:,1+(algdata.horizon+algdata.delays)*(i-1));
    y0v(:,i) = y0_;
    Zi = dmdreconstruct(Atilde,y0_,algdata.horizon+2*algdata.delays-1);
    Yp = [Yp C*U_*Zi];
    Yp_ = [Yp_ C*U_*Zi(:,algdata.delays+1:end)];
    Yv_ = [Yv_ Yv(:,(algdata.delays+1:cols(Zi))+cols(Zi)*(i-1))];
end

% %% Reconstruct states
% C = zeros(rows(Ytrain),rows(Phi));
% C(1:rows(Ytrain),1:rows(Ytrain)) = eye(rows(Ytrain));
% Lr = (1:length(algdata.tr));
% Lp = (1:length(algdata.tp)) + length(algdata.tr);
% % Zi = dmdreconstruct(A,HYk(:,1),length(algdata.t));
% % Yi = C*Zi;
% y0 = U_'*HYk(:,1);
% Zi = dmdreconstruct(Atilde,y0,length(algdata.t));
% Yi = C*U_*Zi;
% Yr = Yi(:,Lr);
% Yp = Yi(:,Lp);

%% Calculate RMSE
% [RMSEYr,rmseYr] = rmse(Y_,Yr_);
% [RMSEYp,rmseYp] = rmse(Yv_,Yp_);
[RMSEYr,rmseYr] = rmse(Y,Yr);
[RMSEYp,rmseYp] = rmse(Yv,Yp);
[RMSEY,rmseY] = rmse([Y Yv],[Yr Yp]);

%% From observables back to states
% if strcmp(algdata.observables{1},'monomial') & algdata.observables{2}(1) ~= 1
%     Yr = Yr(1:rows(Yunobs),:).^(1/algdata.observables{2}(1));
%     Yr = real(Yr);
%     [RMSEYr,rmseYr] = rmse(Yunobs,Yr);
% end

%% Save in algdata
algdata.H = HY;
algdata.rank = length(S_);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
algdata.A = A;
algdata.Atilde = Atilde;
algdata.W = W;
algdata.d = diag(D);
algdata.Phi = Phi;
algdata.b = b;
algdata.omega = omega;

algdata.y0 = y0;
algdata.y0v = y0v;
algdata.Ytrain = Y;
algdata.Yr = Yr;
algdata.RMSEYr = RMSEYr;
algdata.rmseYr = rmseYr;
algdata.Ytest = Yv;
algdata.Yp = Yp;
algdata.RMSEYp = RMSEYp;
algdata.rmseYp = rmseYp;
algdata.RMSEY = RMSEY;
algdata.rmseY = rmseY;

end