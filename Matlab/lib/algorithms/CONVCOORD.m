function algdata = CONVCOORD(algdata)

%% Start algorithm
% Compute hankel matrix
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);
Htrain = H(:,1:end-algdata.horizon);
Htest = H(:,end-algdata.horizon+1:end);

% Compute svd
[U_,S_,Sn,Sn_,V_] = truncsvd(Htrain,algdata.rank);

% Compute derivative of basis U
[Us,dU] = cendiff4(U_,algdata.dt);

% Compute Koopman Operator
A = Us'*dU;

% Compute convolutional coordinates
y1 = Htrain(1:rows(Us),:);
Wtrain = Us'*y1;
% W = U_'*H;
% m = rows(y)/2;
% W = W(:,m:end-m);

% Extract train samples
y2 = Htest(1:rows(Us),:);
Wtest = Us'*y2;

%% Reconstruct convolutional coordinates
Lr = (1:cols(Wtrain));
Lp = (1:algdata.horizon) + length(Lr);
w0 = Wtrain(:,1);
Wi = convcoordreconstruct(A,w0,algdata.dt,length(Lr)+length(Lp));
Wr = Wi(:,Lr);
Wp = Wi(:,Lp);
tr = algdata.dt*(Lr-1);
tp = algdata.dt*(Lp-1);

%% Calculate RMSE
[RMSEWr,rmseWr] = rmse(Wtrain,Wr);
[RMSEWp,rmseWp] = rmse(Wtest,Wp);
[RMSEW,rmseW] = rmse([Wtrain Wtest],[Wr Wp]);

%% Save in algstruct(i)
algdata.H = H;
algdata.rank = length(S_);
algdata.U_ = U_;
algdata.s_ = diag(S_);
algdata.sn = diag(Sn);
algdata.sn_ = diag(Sn_);
algdata.V_ = V_;
algdata.A = A;

algdata.Wtrain = Wtrain;
algdata.Wr = Wr;
algdata.tr = tr;
algdata.RMSEWr = RMSEWr;
algdata.rmseWr = rmseWr;
algdata.Wtest = Wtest;
algdata.Wp = Wp;
algdata.tp = tp;
algdata.RMSEWp = RMSEWp;
algdata.rmseWp = rmseWp;
algdata.RMSEW = RMSEW;
algdata.rmseW = rmseW;

end