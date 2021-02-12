function algdata = simsys(algdata,config)

%% Extract system function and initial state
system = algdata.system;
if isfield(config.general.systems,system)
    fun = config.general.systems.(system).fun;
    [odefun,algdata.params,algdata.x0,algdata.xmax,algdata.xmin,Nu] = fun(algdata.params,algdata.x0);
else
    error(['System: No system ' system ' available.']);
end

%% Create multiple initial states
I = algdata.I;
if I ~= 1
    if length(I) > 1
        for i = 1:length(I)
            dx = (algdata.xmax(i) - algdata.xmin(i))/(I(i) - 1);
            i0(i,:) = algdata.xmin(i):dx:algdata.xmax(i);
        end
    else
        for i = 1:length(algdata.xmax)
            dx = (algdata.xmax(i) - algdata.xmin(i))/(I - 1);
            i0(i,:) = algdata.xmin(i):dx:algdata.xmax(i);
        end 
    end
else
    i0 = algdata.x0;
end

% combine states
if length(algdata.xmax) == 2
    [a, b] = ndgrid(i0(1,:), i0(2,:));
    initcombs = [a(:), b(:)];
elseif length(algdata.xmax) == 3
    [a, b, c] = ndgrid(i0(1,:), i0(2,:), i0(3,:));
    initcombs = [a(:), b(:), c(:)];
end

%% Trainingdata
for i = 1:rows(initcombs)
    x0 = initcombs(i,:);
    
    % tspan
    if i == rows(initcombs)
        trainsteps = algdata.timesteps + algdata.delays;
    else
        trainsteps = algdata.timesteps;
    end
    
    
    
end

%% Create timespan
% traintimesteps = (algdata.timesteps + 1);
% testtimesteps = algdata.horizon;
% timesteps = traintimesteps + testtimesteps;
simsteps = algdata.timesteps + algdata.delays - 2 + algdata.horizon;
tspan = (0:simsteps)*algdata.dt;
algdata.tr = tspan(1:algdata.timesteps);
algdata.tp = tspan(algdata.timesteps+1:algdata.timesteps + algdata.horizon);

%% Create input signal
if isfield(algdata,'input')
    [algdata.input,algdata.U,u] = geninput(algdata.input,tspan,Nu);
elseif Nu ~= 0
    [~,~,u] = geninput({},tspan,Nu);
end

%% Create noise signal
if isfield(algdata,'noise')
    [algdata.noise,algdata.N,n] = gennoise(algdata.noise,tspan,length(algdata.x0));
elseif Nu ~= 0
    [~,~,n] = gennoise({},tspan,length(algdata.x0));
end

%% Simulate system
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,length(algdata.x0)));
if Nu ~= 0
    [t,X] = ode45(@(t,x) odefun(t,x,n,u),tspan,algdata.x0,options);
else
    [t,X] = ode45(@(t,x) odefun(t,x,n),tspan,algdata.x0,options);
end
algdata.t = t';
algdata.X = X';

end