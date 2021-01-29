function algdata = simallsys(algdata,config)

dispstep('sim');
timer = tic;

%% Define fields relevant for simulation
fields = {'system','dt','timesteps','delays','params','x0','horizon','input'};

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

%% Simulate all sim combinations
for i = 1:length(simcombistruct)
    simdata{i} = simsys(simcombistruct{i},config);
end

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