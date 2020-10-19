close all;

%% Run simconfig to set working directory, store archive path and set consistent plot settings
config = simconfig();

%% Set parameters
system = 'lorenz';
dt = 0.05;
timesteps = 1000;
rank = 15;
delays = 30;

%% Simulate lorenz system
[t,X] = simsys(system,dt,timesteps);
[meas,Y] = statemeas(X,1:size(X,1));

%% Compute DMD
[dmd,Phi,omega,b] = DMD(Y,dt,rank,delays);

%% Reconstruct signal
Y_ = reconstruct(Phi,omega,b,t);

%% Calculate rmse
rmseY_ = rmse(Y,Y_);

%% Plot results
eigplot(dmd.d,'discrete');
reconstructplot(t,Y,Y_);
singplot(dmd.s);
%pgfplot(t,Y(1,:),'Ref',t,Y_(1,:),'Pred','lorenz_x1','lorenz_x1.tikz','C:\Users\bouaz\Desktop\Thesis-Tex\content\2_Ergebnisse\Plots');

%% Save result in directory
input = struct('system',system,'timesteps',timesteps);
data = struct('t',t,'measured',meas,'X',X);
reconstruction = struct('Y_',Y_,'rmseY_',rmseY_);
result = resultstruct({input,data,dmd,reconstruction});
saveresult(result,config.archivepath);
