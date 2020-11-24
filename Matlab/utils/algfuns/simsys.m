function algdata = simsys(algdata,config)

%% Check obligatory and optional function arguments
oblgfunargs = {'system','dt','timesteps'};
optfunargs = {'params','x0','horizon'};
optargvals = {[],[],0};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Extract system function and initial state
system = algdata.system;
if isfield(config.general.systems,system)
    fun = config.general.systems.(system).fun;
    [odefun,algdata.params,algdata.x0,Nu] = fun(algdata.params,algdata.x0);
else
    error(['System: No system ' system ' available.']);
end

%% Create timespan
traintimesteps = (algdata.timesteps + 1);
testtimesteps = algdata.horizon;
timesteps = traintimesteps + testtimesteps; 
tspan = (0:timesteps)*algdata.dt;
algdata.tr = tspan(1:end-algdata.horizon);
algdata.tp = tspan(end-algdata.horizon+1:end);

%% Create input signal
if isfield(algdata,'input')
    [algdata.input,algdata.U,u] = geninput(algdata.input,tspan,Nu);
elseif Nu ~= 0
    [~,~,u] = geninput({},tspan,Nu);
end

%% Simulate system
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,length(algdata.x0)));
if Nu ~= 0
    [t,X] = ode45(@(t,x) odefun(t,x,u),tspan,algdata.x0,options);
else
    [t,X] = ode45(odefun,tspan,algdata.x0,options);
end
algdata.t = t';
algdata.X = X';

end