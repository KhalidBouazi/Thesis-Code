close all;

%% Load simconfig for consistent plots
simconfig;

%% Set parameters
system = 'lorenz';
dt = 0.01;
timesteps = 10000;
rank = 10;
delays = 50;

%% Simulate lorenz system
[t,X] = simsys(system,dt,timesteps);
[meas,Y] = statemeas(X,1);

%% Compute HAVOK
[havok,V] = HAVOK(Y,dt,rank,delays);

%% Plot results
delayphaseplot(V);

%% Save results in directory
date = datetime('now','TimeZone','local','Format','d-MMM-y');
time = datetime('now','TimeZone','local','Format','HH:mm');

input = struct('date',date,'time',time,'system',system,'timesteps',timesteps);
data = struct('t',t,'measured',meas,'X',X);
results = resultstruct(havok.algorithm,{input,data,havok});
saveresults(results);
