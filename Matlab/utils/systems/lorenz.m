function [odefun,x0] = lorenz(params,x0)

%% Extract system parameters
if isempty(params)
    params = [10; 28; 8/3];
elseif length(x0) ~= 3
    error('System parameters: Check number of elements.'); 
end

sigma = params(1);
rho = params(2);
beta = params(3);

%% Define initial state
if isempty(x0)
    x0 = [-8; 7; 27];
elseif length(x0) ~= 3
    error('Initial condition: Check number of elements.'); 
end

%% Define system function
odefun = @(t,x) [sigma*(x(2) - x(1));
                 x(1)*(rho - x(3)) - x(2);
                 x(1)*x(2) - beta*x(3)];

end
