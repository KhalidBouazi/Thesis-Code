function res = duffinglin_lqr(x0,params)

res.dt = 0.05;
delta = params(3);
alpha = params(1);
beta = params(2);
res.A = [0 1; alpha-3*beta*x0(1)^2 -delta];
res.B = [0; 1];
res.Yr = [0;0];
res.delays = 1;
res.measured = [1 2];
res.observe = @(x0) x0;

end