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
% x0s = algdata.nx0;
% if x0s ~= 1
%     if length(x0s) > 1
%         for i = 1:length(algdata.xmax)
%             dx = (algdata.xmax(i) - algdata.xmin(i))/(x0s(i) - 1);
%             i0(i,:) = algdata.xmin(i):dx:algdata.xmax(i);
%         end
%     else
%         for i = 1:length(algdata.xmax)
%             dx = (algdata.xmax(i) - algdata.xmin(i))/(x0s - 1);
%             i0(i,:) = algdata.xmin(i):dx:algdata.xmax(i);
%         end 
%     end
% else
%     i0 = algdata.x0;
% end

%% combine states
% if length(algdata.xmax) == 2
%     [a, b] = ndgrid(i0(1,:), i0(2,:));
%     initcombs = [a(:), b(:)];
% elseif length(algdata.xmax) == 3
%     [a, b, c] = ndgrid(i0(1,:), i0(2,:), i0(3,:));
%     initcombs = [a(:), b(:), c(:)];
% end
% algdata.x0s = initcombs';

nx0 = length(algdata.x0);

i = 1;
if algdata.nx0 > 1
    if strcmp(system,'doubletank')
        while i <= algdata.nx0^nx0
            i0 = algdata.xmin + diag(rand(nx0,1))*(algdata.xmax-algdata.xmin);
            if i0(1) > i0(2) && i0(1)-i0(2)>0.1
                iv0(:,i) = i0;
                i = i + 1;
            end
        end
    elseif strcmp(system,'trippletank')
        while i <= algdata.nx0^nx0
            i0 = algdata.xmin + diag(rand(nx0,1))*(algdata.xmax-algdata.xmin);
            if i0(1) > i0(2) && i0(3) > i0(2) && i0(1)-i0(2)>0.1 && i0(3)-i0(2)>0.1 
                iv0(:,i) = i0;
                i = i + 1;
            end
        end
    else
        for i = 1:algdata.nx0^nx0
            iv0(:,i) = algdata.xmin + diag(rand(nx0,1))*(algdata.xmax-algdata.xmin);
        end 
    end
else
    iv0 = algdata.x0; 
end
algdata.x0s = iv0;

%% Training data
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,length(algdata.x0)));
t = [];
X = [];
Xp = [];
U = [];
N = [];

if isempty(algdata.pathtotraindata)
    for i = 1:cols(iv0)
        x0 = iv0(:,i)';

        % tspan
        trainsteps = algdata.timesteps + 2*algdata.delays - 1;
        tspan = (0:trainsteps-1)*algdata.dt;

        % generate input
        if isfield(algdata,'input')
            [algdata.input,Ui] = geninput(algdata.input,tspan,Nu);
        elseif Nu ~= 0
            [algdata.input,Ui] = geninput({},tspan,Nu);
        end

        % generate noise
        if isfield(algdata,'noise')
            [algdata.noise,Ni] = gennoise(algdata.noise,tspan,length(algdata.x0));
        end

        % simulate system
        ti = 0;
        Xi = x0;
        if Nu ~= 0
            for j = 1:length(tspan)-1
                [tj,xj] = ode45(@(t,x) odefun(t,x,Ni(:,j),Ui(:,j)),ti(end)+[0 algdata.dt],Xi(end,:)',options);
                ti(end+1) = tj(end);
                Xi(end+1,:) = xj(end,:);
            end
        else
            for j = 1:length(tspan)-1
                [tj,xj] = ode45(@(t,x) odefun(t,x,Ni(:,j)),ti(end)+[0 algdata.dt],Xi(end,:)',options);
                ti(end+1) = tj(end);
                Xi(end+1,:) = xj(end,:);
            end
        end
        ti = ti(1:end-1) + (i-1)*(algdata.timesteps+2*algdata.delays-1-1)*algdata.dt; %wichtig *2
        X_ = Xi(1:end-1,:);
        Xp_ = Xi(2:end,:);
        t = [t ti];
        X = [X X_'];
        Xp = [Xp Xp_'];
        U = [U Ui(:,1:end-1)];
        N = [N Ni(:,1:end-1)];
    end
    algdata.X = X;
    algdata.X_ = Xp;
    algdata.t = t;
    algdata.tr = t;
    algdata.U = U;
    algdata.N = N;
else
    if strcmp(algdata.algorithm,'HAVOK__')
        var = 'havok__result';
    elseif strcmp(algdata.algorithm,'HDMD')
        var = 'hdmdresult';
    elseif strcmp(algdata.algorithm,'HDMDc')
        var = 'hdmdcresult';
    end
%         var = 'hdmdresult';
    data = load(algdata.pathtotraindata);
    data = data.(var);
    
    for i = 1:length(data)
        if data{1,i}.delays == algdata.delays 
            algdata.X = data{1,i}.X;
            algdata.X_ = data{1,i}.X_;
            algdata.t = data{1,i}.t;
            algdata.tr = data{1,i}.tr;
            algdata.U = data{1,i}.U;
            algdata.N = data{1,i}.N;  
            algdata.x0s = data{1,i}.x0s;  
        end
    end      
end

if isempty(algdata.pathtovaliddata)
    %% Initial conditions for validation
    iv0 = [];
    i = 1;
    if strcmp(system,'doubletank')
        while i <= algdata.nx0v^nx0
            i0 = algdata.xmin + diag(rand(nx0,1))*(algdata.xmax-algdata.xmin);
            if i0(1) > i0(2) && i0(1)-i0(2)>0.1
                iv0(:,i) = i0;
                i = i + 1;
            end
        end
    elseif strcmp(system,'trippletank')
        while i <= algdata.nx0v^nx0
            i0 = algdata.xmin + diag(rand(nx0,1))*(algdata.xmax-algdata.xmin);
            if i0(1) > i0(2) && i0(3) > i0(2) && i0(1)-i0(2)>0.1 && i0(3)-i0(2)>0.1
                iv0(:,i) = i0;
                i = i + 1;
            end
        end
    else
        for i = 1:algdata.nx0v^nx0
            iv0(:,i) = algdata.xmin + diag(rand(nx0,1))*(algdata.xmax-algdata.xmin);
        end 
    end

    %% combine states
    % if length(algdata.xmax) == 2
    %     [a, b] = ndgrid(iv0(1,:), iv0(2,:));
    %     initcombs = [a(:), b(:)];
    % elseif length(algdata.xmax) == 3
    %     [a, b, c] = ndgrid(iv0(1,:), iv0(2,:), iv0(3,:));
    %     initcombs = [a(:), b(:), c(:)];
    % end
    algdata.xv0s = iv0;

    %% Validation data
    tv = [];
    Xv = [];
    Uv = [];
    Nv = [];
    for i = 1:cols(iv0)
        x0 = iv0(:,i);

        % tspan
        validsteps = algdata.horizon + 2*algdata.delays - 1;
        tspan = (0:validsteps-1)*algdata.dt;

        % generate input
        if isfield(algdata,'input')
            [algdata.input,Uvi] = geninput(algdata.input,tspan,Nu);
        elseif Nu ~= 0
            [algdata.input,Uvi] = geninput({},tspan,Nu);
        end

        % generate noise
        if isfield(algdata,'noise')
            [algdata.noise,Nvi] = gennoise(algdata.noise,tspan,length(algdata.x0));
        end

        % simulate system
        ti = 0;
        Xi = x0;
        if Nu ~= 0
            for j = 1:length(tspan)-1
                [tj,xj] = ode45(@(t,x) odefun(t,x,Nvi(:,j),Uvi(:,j)),ti(end)+[0 algdata.dt],Xi(:,end),options);
                ti(end+1) = tj(end);
                Xi(:,end+1) = xj(end,:)';
            end
        else
            for j = 1:length(tspan)-1
                [tj,xj] = ode45(@(t,x) odefun(t,x,Nvi(:,j)),ti(end)+[0 algdata.dt],Xi(:,end),options);
                ti(end+1) = tj(end);
                Xi(:,end+1) = xj(end,:)';
            end
        end
        ti = ti + (i-1)*(algdata.horizon+2*algdata.delays-1)*algdata.dt; %*2 wichtig
        tv = [tv ti];
        Xv = [Xv Xi];
        Uv = [Uv Uvi];
        Nv = [Nv Nvi];
    end
    algdata.Xv = Xv;
    algdata.tp = tv;
    algdata.Uv = Uv;
    algdata.Nv = Nv;
else
    if strcmp(algdata.algorithm,'HAVOK__')
        var = 'havok__result';
    elseif strcmp(algdata.algorithm,'HDMD')
        var = 'hdmdresult';
    elseif strcmp(algdata.algorithm,'HDMDc')
        var = 'hdmdcresult';
    end
%         var = 'hdmdresult';
    data = load(algdata.pathtovaliddata);
    data = data.(var);
    
    for i = 1:length(data)
        if data{1,i}.delays == algdata.delays
            algdata.Xv = data{1,i}.Xv;
            algdata.tp = data{1,i}.tp;
            algdata.Uv = data{1,i}.Uv;
            algdata.Nv = data{1,i}.Nv;  
            algdata.xv0s = data{1,i}.xv0s;  
        end
    end      
end

% %% Create timespan
% % traintimesteps = (algdata.timesteps + 1);
% % testtimesteps = algdata.horizon;
% % timesteps = traintimesteps + testtimesteps;
% simsteps = algdata.timesteps + algdata.delays - 2 + algdata.horizon;
% tspan = (0:simsteps)*algdata.dt;
% algdata.tr = tspan(1:algdata.timesteps);
% algdata.tp = tspan(algdata.timesteps+1:algdata.timesteps + algdata.horizon);
% 
% %% Create input signal
% if isfield(algdata,'input')
%     [algdata.input,algdata.U] = geninput(algdata.input,tspan,Nu);
% elseif Nu ~= 0
%     [algdata.input,algdata.U] = geninput({},tspan,Nu);
% end
% 
% %% Create noise signal
% if isfield(algdata,'noise')
%     [algdata.noise,algdata.N] = gennoise(algdata.noise,tspan,length(algdata.x0));
% end
% 
% %% Simulate system
% options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,length(algdata.x0)));
% if Nu ~= 0
%     t = 0;
%     X = algdata.x0';
%     for i = 1:length(tspan)-1
%         [ti,xi] = ode45(@(t,x) odefun(t,x,algdata.N(:,i),algdata.U(:,i)),t(end)+[0 algdata.dt],X(end,:)',options);
%         t(end+1) = ti(end);
%         X(end+1,:) = xi(end,:);
%     end
% else
%     t = 0;
%     X = algdata.x0';
%     for i = 1:length(tspan)-1
%         [ti,xi] = ode45(@(t,x) odefun(t,x,algdata.N(:,i)),t(end)+[0 algdata.dt],X(end,:)',options);
%         t(end+1) = ti(end);
%         X(end+1,:) = xi(end,:);
%     end
% end
% algdata.t = t;
% algdata.X = X';

end