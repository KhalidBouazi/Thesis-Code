function [odefun,params,x0,xmax,xmin,Nu] = lorenz(params, x0)

%% Extract system parameters
if isempty(params)
    params = [10; 28; 8/3];
elseif length(params) ~= 3
    error('System parameters: Check number of elements.'); 
end

sigma = params(1);
rho = params(2);
beta = params(3);
Nu = 1;

%% Define initial state
if isempty(x0)
    x0 = [-8; 7; 27];
elseif length(x0) ~= 3
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [30; 30; 30];
xmin = [-30; -30; -30];

%% Define system function
odefun = @(t,x,n,u) [sigma*(x(2) - x(1)) + n{1}(t);
                 x(1)*(rho - x(3)) - x(2) + n{2}(t);
                 x(1)*x(2) - beta*x(3) + u{1}(t) + n{3}(t)];

end
