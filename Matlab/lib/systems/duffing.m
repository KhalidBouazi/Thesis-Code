function [odefun,params,x0,xmax,xmin,Nu] = duffing(params, x0)

%% Extract system parameters
if isempty(params)
    params = [1; 1; 0];
elseif length(params) ~= 3
    error('System parameters: Check number of elements.'); 
end

alpha = params(1);
beta = params(2);
delta = params(3);
Nu = 1;

%% Define initial state
if isempty(x0)
    x0 = [0; 0.5];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [5; 5];
xmin = [-5; -5];

%% Define system function
odefun = @(t,x,n,u) [x(2) + n(1);
                   -delta*x(2) + alpha*x(1) - beta*x(1)^3 + u(1) + n(2)];

end
