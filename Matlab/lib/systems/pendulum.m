function [odefun,params,x0,xmax,xmin,Nu] = pendulum(params, x0)

%% Extract system parameters
if isempty(params)
    params = 1;
elseif length(params) ~= 1
    error('System parameters: Check number of elements.'); 
end

l = params(1);
Nu = 1;

%% Define initial state
if isempty(x0)
    x0 = [-pi/4; 0];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [pi; 5];
xmin = [-pi; -5];

%% Define system function
odefun = @(t,x,n,u) [x(2) + n(1);
                 -9.81/l*sin(x(1)) + u(1) + n(2)];

end
