function [t,y,u,u_cost,K,Q,omega] = LQRc(algresult,qy,s,yref,timelen,x0)

dt = algresult.dt;
A = algresult.A;
B = algresult.B;
L = 1:timelen;
z0 = x0;
z0 = algresult.observe(z0);
yref = algresult.observe(yref);
Q = diag(qy);

%% LQR
K = lqr(A,B,Q,diag(s));

%% Create closed loop system and simulate
A_ = A - B*K;
[~,Omega] = eig(A_);
omega = diag(Omega);
B_ = -(A - B*K); 
C_ = eye(rows(A_));
D_ = 0*B_;
sys = ss(A_,B_,C_,D_);
u = repmat(yref',length(L),1);

[Y_,t] = lsim(sys,u,dt*(L-1),z0);
y = Y_';

%% Cost of input
u = -K*Y_';
% u_cost(1) = u(:,1)'*u(:,1);
% for i = 2:cols(u)
%     u_cost(i) = u_cost(i-1) + u(:,i)'*u(:,i);
% end
u_cost = cumtrapz(t, sum(u.*u,1));

% u_cost(1) = 0;
% for i = 2:cols(u)
%     u_cost(i) = cumtrapz(t(1:i)', sum(u(:,1:i).*u(:,1:i),1));
% %     u_cost(i) = u_cost(i-1) + u(:,i)'*u(:,i);
% end

end