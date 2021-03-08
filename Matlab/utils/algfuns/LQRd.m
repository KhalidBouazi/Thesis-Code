function [t,y,u,u_cost,K,Q,yrefdelay,omega] = LQRd(algresult,qy,qu,s,yref,timelen,dimred,x0)

%% Extract data
dt = algresult.dt;

if dimred
    A = algresult.Atilde_;
    B = algresult.Btilde_;
    HY0 = algresult.y0(:,1);
    U_ = algresult.U_;
else
    A = algresult.A_;
    B = algresult.B_; 
    HY0 = algresult.H(:,1);
    U_ = eye(size(algresult.A));
end

G = algresult.G;
HU = algresult.Hu;
U = algresult.U;

%% Reference value
yrefdelay = repmat(yref,algresult.delays,1); %[yref; zeros((algresult.delays-1)*rows(yref),1)];
zref = observe(yrefdelay,algresult.observables);
zref_ = U_'*zref;
uref = 0*eye(rows(HU)-rows(U),1);

%% Initial state
L = 1:timelen;
u0 = zeros(rows(HU)-rows(U),1);
z0 = U_'*repmat(observe(x0(algresult.measured,:),algresult.observables),algresult.delays,1);
% z0 = U_'*[zeros(rows(HY0)-rows(yref),1);observe(x0(algresult.measured,:),algresult.observables)];
% z0 = HY0;
z0_ = [z0; u0];

%% LQR
%Qybar = blkdiag(zeros(rows(HY)-rows(Yr)),diag(qy)); %%%%%%%%%%%% keine 0 für andere q
% weight = [];
% scale = 2;
% for i = 1:algresult.delays
%     weight = blkdiag(weight,scale^(i-1)*eye(rows(qy')));
% end
Qybar = diag(repmat(qy',algresult.delays,1));
Qz = G'*Qybar*G;
Q_ = U_'*Qz*U_;
Q = blkdiag(Q_,qu*eye(rows(u0))); 

%% LQR
K = dlqr(A,B,Q,diag(s));
% K_ = flipud(K');

% M1 = eye(rows(HY0));
% M2 = zeros(rows(HY0),rows(u0));
% M3_ = zeros(rows(u0));
% M4 = zeros(rows(u0));
% Z = tril(ones(rows(u0)));
% for i = 1:rows(u0)
%     T = Z - tril(ones(rows(u0)),-i);
%     Z = tril(ones(rows(u0)),-i);
%     M3_ = M3_ - K_(rows(HY0) + i)*T;
% end
% M3 = [M3_ zeros(rows(u0),1)];
% 
% Z = tril(ones(rows(u0)),-1);
% for i = 1:rows(u0)-1
%     T = Z - tril(ones(rows(u0)),-(i+1));
%     Z = tril(ones(rows(u0)),-(i+1));
%     M4 = M4 - K_(i)*T;
% end
% 
% M = [M1 M2; M3 M4];
% 
% M_ = eye(size(M));
% for i = 1:algresult.delays-1
%     I = eye(2*algresult.delays - 1 - (i-1));
%     O = zeros(i-1);
%     C = blkdiag(I,O);
%     Mi = C*M;
%     M_ = M_*Mi;
% end
% 
% M_ = M_(:,1:rows(HY0));

%% Create closed loop system and simulate
A_ = A - B*K;
[~,Omega] = eig(A_);
omega = diag(Omega);
B_ = -A_ + eye(rows(A_)); 
C_ = eye(rows(A_));
D_ = 0*B_;
sys = ss(A_,B_,C_,D_,dt);
u = [repmat(zref_',length(L),1), repmat(uref',length(L),1)];
[Y_,t] = lsim(sys,u,dt*(L-1),z0_);
y = G*U_*Y_(:,1:rows(HY0))';

% A_ = M_\(A - B*K)*M_;
% B_ = -A_ + eye(rows(A_)); 
% C_ = eye(rows(A_));
% D_ = 0*B_;
% sys = ss(A_,B_,C_,D_,dt);
% u = repmat(zref_',length(L),1);
% [Y_,t] = lsim(sys,u,dt*(L-1),z0);
% y = G*U_*Y_';
% y = y(end-rows(Yr):end,:);
% u = -K*M_*Y_';

%% Cost of input
u = -K*Y_';
u_cost = cumtrapz(t, sum(u.*u,1));

% u_cost(1) = 0;
% for i = 2:cols(u)
%     u_cost(i) = cumtrapz(t(1:i)', sum(u(:,1:i).*u(:,1:i),1));
% %     u_cost(i) = u_cost(i-1) + u(:,i)'*u(:,i);
% end

end