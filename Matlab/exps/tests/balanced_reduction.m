%%
n = 7;
res = hdmdcresult{1,n};
A = res.A_;
B = res.B_;
C_ = eye(size(A));
omega = res.omega;
dt = res.dt;
scatter(real(omega),imag(omega));

%%
Wc = dlyap(A,B*B');
Wo = dlyap(A',C_'*C_);

S = chol(Wc,'lower');
R = chol(Wo,'lower');

M = R'*S;
[U,Sigma,V] = svd(M,'econ');
Sigma = diag(Sigma);
scatter(1:length(Sigma),Sigma);
set(gca, 'YScale', 'log');

idx = 1:299;
U = U(:,idx);
Sigma = Sigma(idx,idx);
V = V(:,idx);

%%
M1 = C*V*Sigma^(-1/2);
M2 = Sigma^(-1/2)*U'*O';

A_ = M2*A*M1;
B_ = M2*B;

%%
[W,D] = eig(A_);
omega_ = log(diag(D))/dt;
scatter(real(omega),imag(omega));
hold on;
scatter(real(omega_),imag(omega_));





