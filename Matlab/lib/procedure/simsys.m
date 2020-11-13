function algdata = simsys(algdata,config)

dispstep('sim');

%% Check obligatory and optional function arguments
oblgfunargs = {'system','dt','timesteps'};
optfunargs = {'params','x0','delays','spacing'};
optargvals = {[],[],1,[1,1]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Extract system function and initial state
system = algdata.system;
if isfield(config.general.systems,system)
    fun = config.general.systems.(system).fun;
    [odefun,algdata.params,algdata.x0] = fun(algdata.params,algdata.x0);
else
    error(['System: No system ' system ' available.']);
end

%% Create timespan
traintimesteps = (algdata.timesteps + 1) + algdata.spacing(2)*(algdata.delays - 1); % TODO spacingx
testtimesteps = algdata.horizon;
timesteps = traintimesteps + testtimesteps; 
tspan = (0:timesteps)*algdata.dt;

%% Simulate system
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,length(algdata.x0)));
[t,X] = ode45(odefun,tspan,algdata.x0,options);
algdata.t = t';
algdata.X = X';

%% Do measurement
algdata = meassys(algdata);

end