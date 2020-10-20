function [odefun,params,x0] = trippletank(params, x0)

%% Extract system parameters
if isempty(params)
    Ai = (0.14^2)*pi/4;
    params = [Ai; Ai; Ai; 21.8e-6; 41e-6; 21.8e-6];
elseif length(x0) ~= 6
    error('System parameters: Check number of elements.'); 
end

A1 = params(1);
A2 = params(2);
A3 = params(3);
q1 = params(4);
q2 = params(5);
q3 = params(6);

%% Define initial state
if isempty(x0)
    x0 = [0.5; 0.3; 0.6];
elseif length(x0) ~= 3
    error('Initial condition: Check number of elements.'); 
end

%% Define system function
g = 9.81;
u = [0; 0];
odefun = @(t,x) [1/A1*(-q1*sqrt(2*g*(x(1) - x(2))) + u(1));
                 1/A2*(q1*sqrt(2*g*(x(1) - x(2))) + q3*sqrt(2*g*(x(3) - x(2))) - q2*sqrt(2*g*x(2)));
                 1/A3*(-q3*sqrt(2*g*(x(3) - x(2))) + u(2))];

end
