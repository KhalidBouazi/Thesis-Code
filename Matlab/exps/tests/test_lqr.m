%%
n = 35;
res = hdmdcresult{1,n};

%%
dt = res.dt;
meas = res.measured;
Atilde_ = res.Atilde_;
Btilde_ = res.Btilde_;
HY = res.H;
U_ = res.U_;
y0tilde = res.HY0;

%%
L = 1:100;
u = zeros(length(L),cols(Btilde_));
u0 = zeros(rows(Atilde_)-rows(y0tilde),1);
y0tilde_ = [y0tilde; u0];

%% LQR
Q = eye(rows(HY));
for i = 1:length(meas)
    Q(meas(i),meas(i)) = 10;
end
Qtilde = U_'*Q*U_;
Qtilde_ = blkdiag(Qtilde,eye(rows(u0)));

R = 1*eye(cols(Btilde_));
r = rank(ctrb(Atilde_,Btilde_));
K = lqr(Atilde_,Btilde_,Qtilde_,R);

%% Create system object and simulate
Atilde_ = Atilde - Btilde*K;
C = eye(size(Atilde_,1));
D = 0*Btilde_;
sys = ss(Atilde_,Btilde_,C,D);
[Y_,~] = lsim(sys,u,dt*(L-1),y0tilde_);
u = -K*Y_';
u_cost_t(1) = u(:,1)'*R*u(:,1);
for i = 2:cols(u)
    u_cost_t(i) = u_cost_t(i-1) + u(:,i)'*R*u(:,i);
end
Y = U_*Y_(:,1:rows(y0tilde))';
Y = real(Y);
%%
n = rows(Y);
k = floor(n/16);

subplot(1,3,1);
plot(Y(1,:));
ylabel('$y_1$');
xlabel('Samples');

subplot(1,3,2);
plot(u(1,:));
ylabel('$u$');
xlabel('Samples');

subplot(1,3,3);
plot(u_cost_t);
ylabel('$\sum u^T R u$');
xlabel('Samples');
% for i = 1:16
%     subplot(4,4,i);
%     plot(Y(k*i,:));
%     ylabel(['$y_{' num2str(k*i) '}$']);
% end
