function [odefun,x0] = duffing(params, x0)

%% Extract system parameters
if isempty(params)
    params = [1; 1; 0];
elseif length(x0) ~= 3
    error('System parameters: Check number of elements.'); 
end

alpha = params(1);
beta = params(2);
delta = params(3);

%% Define initial state
if isempty(x0)
    x0 = [1; 0];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define system function
odefun = @(t,x) [x(2);
                 -delta*x(2) - alpha*x(1) - beta*x(1)^3];

end
