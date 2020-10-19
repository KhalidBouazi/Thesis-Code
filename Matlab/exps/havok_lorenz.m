close all;

%% Run simconfig to set working directory, store archive path and set consistent plot settings
config = simconfig();

%% Set parameters
system = 'lorenz';
dt = 0.01;
timesteps = 10000;
rank = 10;
delays = 20;

%% Simulate lorenz system
[t,X] = simsys(system,dt,timesteps);
[meas,Y] = statemeas(X,1);

%% Compute HAVOK
[havok,V] = HAVOK(Y,dt,rank,delays);

%% Plot results
delayphaseplot(V);

%% Save results in directory
input = struct('system',system,'timesteps',timesteps);
data = struct('t',t,'measured',meas,'X',X);
result = resultstruct({input,data,havok});
saveresult(result,config.archivepath);
