function [odefun,x0] = pendulum(params, x0)

%% Extract system parameters
if isempty(params)
    params = 1;
elseif length(x0) ~= 1
    error('System parameters: Check number of elements.'); 
end

l = params(1);

%% Define initial state
if isempty(x0)
    x0 = [-pi/4; 0];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define system function
odefun = @(t,x) [x(2);
                 -9.81/l*sin(x(1))];

end
