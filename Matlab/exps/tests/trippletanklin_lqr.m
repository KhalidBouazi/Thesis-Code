function res = trippletanklin_lqr(x0)

res.dt = 0.1;
g = 9.81;
Ai = (0.14^2)*pi/4;
A1 = Ai;
A2 = Ai;
A3 = Ai;
q1 = 21.8e-6;
q2 = 41e-6;
q3 = q1;

c1 = g/(sqrt(2*g*(x0(1)-x0(2))));
c2 = g/(sqrt(2*g*(x0(3)-x0(2))));
c3 = g/(sqrt(2*g*x0(2)));

res.A = [-1/A1*q1*c1, 1/A1*q1*c1, 0;
        1/A2*q1*c1, -1/A2*(q1*c1 + q3*c2 + q2*c3), 1/A2*q3*c2;
        0, 1/A3*q3*c2, -1/A3*q3*c2];
res.B = [1/A1 0;0 0;0 1/A3];
res.Yr = [0;0;0];
res.delays = 1;
res.measured = [1 2 3];
res.observe = @(x0) x0;

end