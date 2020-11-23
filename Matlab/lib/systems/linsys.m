function [odefun,params,x0,Nu] = linsys(params, x0)

%% Extract system parameters
if isempty(params)
    params = [0; 0; 0; 1];
elseif length(params) ~= 4
    error('System parameters: Check number of elements.'); 
end

a11 = params(1);
a12 = params(2);
a21 = params(3);
a22 = params(4);
Nu = 1;

%% Define initial state
if isempty(x0)
    x0 = [0.5; 0.3];
elseif length(x0) ~= 2
    error('Initial condition: Check number of elements.'); 
end

%% Define system function
odefun = @(t,x,u) [a11*x(1) + a12*x(2) + u{1}(t);
                   a21*x(1) + a22*x(2)];

end
