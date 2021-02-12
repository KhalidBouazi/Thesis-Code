function [odefun,params,x0,xmax,xmin,Nu] = massoscillator(params, x0)

%% Extract system parameters
if isempty(params)
    params = [1; 100; 1];
elseif length(params) ~= 3
    error('System parameters: Check number of elements.'); 
end

m = params(1);
k = params(2);
d = params(3);
Nu = 1;

%% Define initial state
if isempty(x0)
    x0 = [1; 0];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [5; 5];
xmin = [-5; -5];

%% Define system function
odefun = @(t,x,n,u) [x(2) + n{1}(t);
                   -k/m*x(1) - d/m*x(2) + u{1}(t) + n{2}(t)];

end
