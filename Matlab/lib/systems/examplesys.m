function [odefun,params,x0,xmax,xmin,Nu] = examplesys(params, x0)

%% Extract system parameters
if isempty(params)
    params = [-0.1 -1];
elseif length(params) ~= 2
    error('System parameters: Check number of elements.'); 
end

gamma = params(1);
delta = params(2);
Nu = 1;

%% Define initial state
if isempty(x0)
    x0 = [2; 1];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [5; 5];
xmin = [-5; -5];

%% Define system function
odefun = @(t,x,n,u) [gamma*x(1) + n(1);
                   delta*(x(2) - x(1)^2) + u(1) + n(2)];
               
end
