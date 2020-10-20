close all;

%% Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% Set parameters
input.system = {'lorenz','lorenz'};
input.dt = {0.01};
input.timesteps = {10000};
input.rank = {10};
input.delays = {20};
input.measured = {1,2};
havok = combineinputs(input);

%% Simulate lorenz system
havok = simsys(havok);
havok = statemeas(havok);

%% Compute HAVOK
havok = HAVOK(havok);

%% Plot results
%delayphaseplot(havok.V);

%% Save results in directory
saveresult(havok,config.archivepath);
