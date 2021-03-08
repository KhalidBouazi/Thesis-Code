function res = vanderpollin_lqr(x0,params)

res.dt = 0.1;
mu = params(1);
res.A = [0 1; -2*mu*x0(1)-1 mu];
res.B = [0; 1];
res.Yr = [0;0];
res.delays = 1;
res.measured = [1 2];
res.observe = @(x0) x0;

end