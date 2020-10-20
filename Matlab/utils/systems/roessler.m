function [odefun,params,x0] = roessler(params, x0)

%% Extract system parameters
if isempty(params)
    params = [0.2; 0.2; 5.7];
elseif length(x0) ~= 3
    error('System parameters: Check number of elements.'); 
end

a = params(1);
b = params(2);
c = params(3);

%% Define initial state
if isempty(x0)
    x0 = [0; 10; 0];
elseif length(x0) ~= 3
    error('Initial condition: Check number of elements.'); 
end

%% Define system function
odefun = @(t,x) [-x(2) - x(3);
                 x(1) + a*x(2);
                 b + x(3)*(x(1) - c)];

end
