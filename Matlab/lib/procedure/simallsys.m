function algdata = simallsys(algdata,config)

dispstep('sim');
timer = tic;

%% Define fields relevant for simulation
fields = {'system','dt','timesteps','params','x0','nx0','nx0v','horizon','delays','input','noise','pathtotraindata','pathtovaliddata','algorithm'};

%% Extract combinations relevant for simulation
simcombistruct = {};
for i = 1:length(algdata)
    combi = structbyfields(algdata{i},fields);
    [exists,idx] = structexists(simcombistruct,combi);
    if ~exists
        simcombistruct = [simcombistruct combi];
        algdata{i}.simtype = length(simcombistruct);
    else
        algdata{i}.simtype = idx;
    end
end

%% Extract longest simulation (most delays)
maxspan = 1;
cnt = 1;
for i = 1:length(simcombistruct)
    d = simcombistruct{i}.delays;
    timesteps = simcombistruct{i}.timesteps;
    if d + timesteps > maxspan
        maxspan = d + timesteps;
        cnt = i;
    end
end

%% Simulate longest simulation
simdata{cnt} = simsys(simcombistruct{cnt},config);

%% Reproduce all other simulations
data = simdata{cnt};
Xlen = data.timesteps + 2*data.delays - 1 - 1; %*2 wichtig
Xvlen = data.horizon + 2*data.delays - 1;
for i = 1:length(simcombistruct)
    if i ~= cnt
        input = simcombistruct{i};
        simdata{i} = input;
        timesteps = input.timesteps;
        horizon = input.horizon;
        delays = input.delays;
        Xlen_ = timesteps + 2*delays - 1 - 1;
        Xvlen_ = horizon + 2*delays - 1;
        X = [];
        X_ = [];
        U = [];
        N = [];
        Xv = [];
        Uv = [];
        Nv = [];
        for j = 1:cols(data.x0s)
            X = [X data.X(:,(1:Xlen_)+(j-1)*Xlen)];
            X_ = [X_ data.X_(:,(1:Xlen_)+(j-1)*Xlen)];
            U = [U data.U(:,(1:Xlen_)+(j-1)*Xlen)];
            N = [N data.N(:,(1:Xlen_)+(j-1)*Xlen)];
        end
        for j = 1:cols(data.xv0s)
            Xv = [Xv data.Xv(:,(1:Xvlen_)+(j-1)*Xvlen)];
            Uv = [Uv data.Uv(:,(1:Xvlen_)+(j-1)*Xvlen)];
            Nv = [Nv data.Nv(:,(1:Xvlen_)+(j-1)*Xvlen)];
        end
        simdata{i}.t = data.t(1:cols(data.x0s)*Xlen_);
        simdata{i}.tr = simdata{i}.t;
        simdata{i}.tp = data.t(1:cols(data.xv0s)*Xvlen_);
        simdata{i}.X = X;
        simdata{i}.X_ = X_;
        simdata{i}.Xv = Xv;
        simdata{i}.U = U;
        simdata{i}.Uv = Uv;
        simdata{i}.N = N;
        simdata{i}.Nv = Nv;
        simdata{i}.x0s = data.x0s;
        simdata{i}.xv0s = data.xv0s;
    end
end

%% Simulate all sim combinations
% for i = 1:length(simcombistruct)
%     simdata{i} = simsys(simcombistruct{i},config);
% end

%% Save sim data in different algorithm structs
for i = 1:length(algdata)
    simtype = algdata{i}.simtype;
    algdata{i} = fillstruct(algdata{i},simdata{simtype});
    algdata{i} = rmfield(algdata{i},'simtype');
end

%% Stop timer
timeelapsed = toc(timer);
dispstep('time',timeelapsed);
dispstep('endsim');

end