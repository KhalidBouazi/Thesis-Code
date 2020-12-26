%%
n = 9;

%%
A = hdmdcresult{1,n}.A;
B = hdmdcresult{1,n}.B;
y0 = hdmdcresult{1,n}.H(:,1);

%%
dt = 0.1;
L = 1:500;
u = zeros(length(L),cols(B));

%% LQR
Q = eye(size(A));
R = eye(cols(B));
r = rank(ctrb(A,B));
K = lqr(A,B,Q,R);

%% Create system object and simulate
A = A - B*K;
C = eye(size(A,1));
D = 0*B;
sys = ss(A,B,C,D);
[Y,~] = lsim(sys,u,dt*(L-1),y0);

%%
plot(real(Y(:,1)));
