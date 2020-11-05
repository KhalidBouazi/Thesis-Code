function [odefun,params,x0] = vanderpol(params, x0)

%% Extract system parameters
if isempty(params)
    params = 5;
elseif length(params) ~= 1
    error('System parameters: Check number of elements.'); 
end

mu = params(1);

%% Define initial state
if isempty(x0)
    x0 = [2; 0];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define system function
odefun = @(t,x) [x(2);
                 mu*(1 - x(1)^2)*x(2) - x(1)];

end
