function [odefun,params,x0,xmax,xmin,Nu] = evaporationplant(params, x0)

%% Extract system parameters
if isempty(params)
    params = [0.00751, 0.00418, 0.05, 0.03755, 0.02091, 0.00315,...
              0.00192, 0.05, 0.00959, 0.1866, 0.14,...
              0.01061, 2.5, 6.84, 2.5531];
elseif length(params) ~= 15
    error('System parameters: Check number of elements.'); 
end

a1 = params(1);
a2 = params(2);
a3 = params(3);
a4 = params(4);
a5 = params(5);
a6 = params(6);
b1 = params(7);
b2 = params(8);
b3 = params(9);
b4 = params(10);
b5 = params(11);
k1 = params(12);
k2 = params(13);
k3 = params(14);
k4 = params(15);
Nu = 3;

%% Define initial state
if isempty(x0)
    x0 = [1; 0.3; 50e3];
elseif length(x0) ~= 3
    error('Initial condition: Check number of elements.'); 
end

%% Define initial state interval
xmax = [1; 1; 100e3];
xmin = [0; 0; 0];

%% Define system function
odefun = @(t,x,n,u) [a1*x(1) + a2*x(2) - b1*u{1}(t) - b2*u{2}(t) - k1 + n{1}(t);
                   -a3*x(2)*u{2}(t) + k2 + n{2}(t);
                   -a4*x(3) - a5*x(2) + b3*u{1}(t) - (a6*x(3) + b4)/(b5*u{3}(t) + k3)*u{3}(t) + k4 + n{3}(t)];

end
