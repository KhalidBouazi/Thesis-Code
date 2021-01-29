function [odefun,params,x0,Nu] = examplesyslin(params, x0)

%% Extract system parameters
if isempty(params)
    params = [-0.1 -1];
elseif length(params) ~= 1
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

%% Define system function
odefun = @(t,x,u) [gamma*x(1);
                   delta*(x(2) - x(1)^2) + u{1}(t)];

end
