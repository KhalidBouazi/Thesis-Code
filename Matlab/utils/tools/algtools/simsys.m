function algstruct = simsys(algstruct)

%% Check obligatory and optional function arguments
oblgfunargs = {'system','dt','timesteps'};
optfunargs = {'params','x0'};
optargvals = {[],[]};
algstruct = checkandfillfunargs(algstruct,oblgfunargs,optfunargs,optargvals);

%% Define systems struct
systems = struct('lorenz',@lorenz,'duffing',@duffing,'roessler',@roessler,...
                 'vanderpol',@vanderpol,'pendulum',@pendulum,'doubletank',@doubletank,...
                 'trippletank',@trippletank);

%% Run for every algorithm combination
for i = 1:length(algstruct)
    
    % Extract system function and initial state
    system = char(algstruct(i).system);
    if isfield(systems,system)
        fun = systems.(system);
        [odefun,params,x0] = fun(algstruct(i).params,algstruct(i).x0);
    else
        error(['System: No system ' system ' available.']);
    end

    % Create timespan
    tspan = (0:algstruct(i).dt:algstruct(i).dt*algstruct(i).timesteps);

    % Simulate system
    options = odeset('RelTol',1e-12);
    [t,X] = ode45(odefun,tspan,x0,options);
    t = t';
    X = X';

    % Save in algstruct(i)
    algstruct(i).params = params;
    algstruct(i).x0 = x0;
    algstruct(i).t = t;
    algstruct(i).X = X;
    
end

end