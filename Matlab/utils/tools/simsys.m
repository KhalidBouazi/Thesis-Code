function [t,X] = simsys(sys,dt,timesteps,params,x0)

%% Check function arguments
if nargin < 3
    error('Minimum number of inputs is 3.');
elseif nargin < 4
    params = [];
    x0 = [];
elseif nargin < 5
    x0 = [];
end
    
%% Extract system function and initial state
switch sys
    case 'lorenz'
        [odefun,x0] = lorenz(params,x0);
    case 'duffing'
        [odefun,x0] = duffing(params,x0);
    case 'roessler'
        [odefun,x0] = roessler(params,x0);
    case 'vanderpol'
        [odefun,x0] = vanderpol(params,x0);
    case 'pendulum'
        [odefun,x0] = pendulum(params,x0);
    case 'doubletank'
        [odefun,x0] = doubletank(params,x0);
    case 'trippletank'
        [odefun,x0] = trippletank(params,x0);
    otherwise
        error('System: No such system available.');
end

%% Create timespan
tspan = (0:dt:dt*timesteps);

%% Simulate system
[t,X] = ode45(odefun,tspan,x0);
t = t';
X = X';

end