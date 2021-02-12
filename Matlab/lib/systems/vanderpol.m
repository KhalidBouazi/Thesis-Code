function [odefun,params,x0,xmax,xmin,Nu] = vanderpol(params, x0)

%% Extract system parameters
if isempty(params)
    params = 1;
elseif length(params) ~= 1
    error('System parameters: Check number of elements.'); 
end

mu = params(1);
Nu = 1;

%% Define initial state
if isempty(x0)
    x0 = [2; 0.1];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [5; 5];
xmin = [-5; -5];

%% Define system function
odefun = @(t,x,n,u) [x(2) + n{1}(t);
                   mu*(1 - x(1)^2)*x(2) - x(1) + u{1}(t) + n{2}(t)];

end
