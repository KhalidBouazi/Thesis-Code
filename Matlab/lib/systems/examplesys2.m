function [odefun,params,x0,xmax,xmin,Nu] = examplesys2(params, x0)

%% Extract system parameters
if isempty(params)
    params = [];
elseif length(params) ~= 0
    error('System parameters: Check number of elements.'); 
end

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
odefun = @(t,x,n,u) [x(1)*(x(2) - 1) + n{1}(t);
                   x(2)*(x(1) - 1) + u{1}(t) + n{2}(t)];

end
