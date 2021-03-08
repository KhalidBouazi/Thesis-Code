function res = examplesyslin_lqr(x0,params)

res.dt = 0.1;
mu = params(1);
lambda = params(2);
res.A = [mu 0; -2*x0(1)*lambda lambda];
res.B = [0; 1];
res.Yr = [0;0];
res.delays = 1;
res.measured = [1 2];
res.observe = @(x0) x0;

end