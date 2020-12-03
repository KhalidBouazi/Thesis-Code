function algdata = CONVCOORD(algdata)

%% Start algorithm
% Compute hankel matrix
H = hankmat(algdata.Y,algdata.delays,algdata.spacing);
Htrain = H(:,1:end-algdata.horizon);
Htest = H(:,end-algdata.horizon+1:end);

% Compute svd
[U1_,S1_,S1n,S1n_,V1_] = truncsvd(Htrain,algdata.rank);
[U2_,S2_,S2n,S2n_,V2_] = truncsvd(Htest,algdata.rank);

% Compute derivative of basis U
[Us,dU] = cendiff4(U1_,algdata.dt);
% [Vs,dV] = cendiff4(V_(1:end-algdata.horizon,:),algdata.dt);

% Compute Koopman Operator
A = Us'*dU;
% A = S_\(Vs'*dV)*S_;

% Compute convolutional coordinates
y1 = hankmat(algdata.Y(:,1:end-algdata.horizon),size(Us,1)-1);
Wtrain = Us'*y1;
% W = U_'*H;
% m = size(y,1)/2;
% W = W(:,m:end-m);

% Extract train samples
y2 = hankmat(algdata.Y(:,1:end-algdata.horizon),size(U2_,1)-1);
Wtest = U2_'*y2;

%% Reconstruct convolutional coordinates
Lr = (1:size(Wtrain,2));
Lp = (1:algdata.horizon) + length(Lr);
w0 = Wtrain(:,1);
Wi = convcoordreconstruct(A,w0,algdata.dt,length(Lr)+length(Lp));
Wr = Wi(:,Lr);
plot(Wtrain(1,:));
hold on;
plot(Wr(1,:));

Wp = Wi(:,Lp);
tr = algdata.dt*(Lr-1);
tp = algdata.dt*(Lp-1);

%% Calculate RMSE
[RMSEWr,rmseWr] = rmse(Wtrain,Wr);
[RMSEWp,rmseWp] = rmse(Wtest,Wp);
[RMSEW,rmseW] = rmse([Wtrain Wtest],[Wr Wp]);

%% Save in algstruct(i)
algdata.H = H;
algdata.rank = length(S1_);
algdata.U_ = U1_;
algdata.s_ = diag(S1_);
algdata.sn = diag(S1n);
algdata.sn_ = diag(S1n_);
algdata.V_ = V1_;
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