%% eigenvalues of A_
n = 7;
res = dimredres{1,n};

A = res.Atilde_;
d = res.d;
B = res.Btilde_;
dt = res.dt;
[W,D] = eig(A);
lambda = diag(D);

omega = log(lambda)/dt;
omega_ = log(d)/dt;
scatter(real(omega),imag(omega),'<');
hold on;
scatter(real(omega_),imag(omega_),'o');
legend('erweitert','original');

%% check for each eigenvalue if controllable
ctrbeigs = [];
unctrbeigs = [];
for i = 1:length(lambda)
    r = rank([A - lambda(i)*eye(size(A)), B]);
    if  r == size(A,1)
        ctrbeigs(end+1) = lambda(i);
    else
        unctrbeigs(end+1) = lambda(i);
    end
    
end

%% to continuous
ctrbeigs_ = log(ctrbeigs)/dt;
unctrbeigs_ = log(unctrbeigs)/dt;

%% plot eigs
figure;
scatter(real(ctrbeigs_),imag(ctrbeigs_),'<');
hold on;
scatter(real(unctrbeigs_),imag(unctrbeigs_),'o');
legend('steuerbar','nicht steuerbar');


