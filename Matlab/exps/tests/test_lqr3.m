%%
clear u_cost_t;
n = 1; %4,6,7,8,9,11,13
res = hdmdcresult{1,n};

%%
dt = res.dt;
meas = res.measured;
nmeas = length(meas);
A = res.Atilde;
B = res.Btilde;
HY = res.H;
HU = res.Hu;
Y = res.Y;
U = res.U;
U_ = res.U_;

%%
L = 1:4000;
u = zeros(length(L),rows(U));
u0_ = zeros(rows(HU)-rows(U),1);
y0 = U_'*HY(:,1);
y0_ = [u0_; y0];

I = zeros(rows(u0_),rows(u0_));
I(1:end-1,2:end) = eye(rows(u0_)-1);
J = zeros(rows(u0_),rows(U));
J(end-rows(U)+1:end,:) = eye(rows(U));
O = zeros(rows(u0_),rows(y0));
A_ = [I O;B(:,1:end-1) A];
B_ = [J; B(:,end)];
C = eye(size(A_,1));
D = 0*B_;

%% LQR
Q = zeros(rows(HY));
for i = 1:length(meas)
    Q(end-nmeas+meas(i),end-nmeas+meas(i)) = 1;
end
Q_ = blkdiag(zeros(rows(u0_)),U_'*Q*U_);
R_ = 1*eye(cols(B_));
r = rank(ctrb(A_,B_));
K = dlqr(A_,B_,Q_,R_);

%% Create closed loop system matrix and simulate
A_ = A_ - B_*K;
B_ = zeros(size(B_)); 
sys = ss(A_,B_,C,D,dt);
[Y_,~] = lsim(sys,u,dt*(L-1),y0_);
Y = U_*Y_(:,rows(I)+1:end)';
u = -K*Y_';
u_cost_t(1) = u(:,1)'*R_*u(:,1);
for i = 2:cols(u)
    u_cost_t(i) = u_cost_t(i-1) + u(:,i)'*R_*u(:,i);
end

%%
figure('Position',[100 100 1000 200]);
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

