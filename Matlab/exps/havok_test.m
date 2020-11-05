%% I. First close all windows and clear workspace
close all;
clear;

%% II. Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% III. Set HAVOK parameters

input.algorithm = {'HAVOK'};

input.system = {'lorenz'};

input.x0 = {};

input.params = {};

input.dt = {0.005};

input.timesteps = {6000};

input.rank = {15};

input.delays = {15};

input.spacing = {[1,10],[3,10],[5,10]};

input.measured = {1};

havok = combineinputs(input);

%% IV.
havok = havok{:};
data = simsys(havok,config);

H = hankmat(data.Y,data.delays,data.spacing);
X = data.X;

plot3(X(1,:),X(2,:),X(3,:));
hold on;
plot3(H(1,:),H(2,:),H(3,:));

