function [odefun,params,x0,xmax,xmin,Nu] = roessler(params, x0)

%% Extract system parameters
if isempty(params)
    params = [0.2; 0.2; 5.7];
elseif length(params) ~= 3
    error('System parameters: Check number of elements.'); 
end

a = params(1);
b = params(2);
c = params(3);
Nu = 0;

%% Define initial state
if isempty(x0)
    x0 = [0; 10; 0];
elseif length(x0) ~= 3
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [10; 10; 10];
xmin = [-10; -10; -10];

%% Define system function
odefun = @(t,x,n) [-x(2) - x(3) + n{1}(t);
                 x(1) + a*x(2) + n{2}(t);
                 b + x(3)*(x(1) - c) + n{3}(t)];

end
