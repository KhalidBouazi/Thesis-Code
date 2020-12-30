%%
n = 4;

%%
Atilde = hdmdcresult{1,n}.Atilde;
A = hdmdcresult{1,n}.A;
Btilde = hdmdcresult{1,n}.Btilde;
B = hdmdcresult{1,n}.B;
U = hdmdcresult{1,n}.U_;
y0 = hdmdcresult{1,n}.H(:,1);
y0tilde = U'*y0;

%%
dt = 0.1;
L = 1:100;
u = zeros(length(L),cols(Btilde));

%% LQR
Q = eye(size(A));
Q(1,1) = 1;
Qtilde = U'*Q*U;
R = 1*eye(cols(Btilde));
r = rank(ctrb(Atilde,Btilde));
K = lqr(Atilde,Btilde,Qtilde,R);

%% Create system object and simulate
Atilde_ = Atilde - Btilde*K;
C = eye(size(Atilde,1));
D = 0*Btilde;
sys = ss(Atilde_,Btilde,C,D);
[Y_,~] = lsim(sys,u,dt*(L-1),y0tilde);
u = -K*Y_';
u_cost_t(1) = u(:,1)'*R*u(:,1);
for i = 2:cols(u)
    u_cost_t(i) = u_cost_t(i-1) + u(:,i)'*R*u(:,i);
end
Y = U*Y_';
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
