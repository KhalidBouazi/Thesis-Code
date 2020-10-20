close all;

%% Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% Set parameters
input.system = {'lorenz'};
input.dt = {0.05};
input.timesteps = {1000};
input.rank = {15,20,35};
input.delays = {70};
dmd = combineinputs(input);

%% Simulate lorenz system
dmd = simsys(dmd);
dmd = statemeas(dmd);

%% Compute DMD
dmd = DMD(dmd);

%% Reconstruct signal
dmd = reconstruct(dmd);
%dmd = predict(dmd); % TODO

%% Calculate rmse
dmd = rmse(dmd);

%% Plot results
% eigplot(dmd.d,'discrete');
% reconstructplot(dmd.t,dmd.Y,dmd.Y_);
% singplot(dmd.s);
%pgfplot(t,Y(1,:),'Ref',t,Y_(1,:),'Pred','lorenz_x1','lorenz_x1.tikz','C:\Users\bouaz\Desktop\Thesis-Tex\content\2_Ergebnisse\Plots');

%% Save result in directory
saveresult(dmd,config.archivepath);
