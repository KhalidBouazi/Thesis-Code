%% I. First close all windows and clear workspace
close all;
clear simopt simdata;

%% II. Define simulation params
simopt.system = {'lorenz'};
simopt.params = {[]};
simopt.x0 = {[]};
simopt.timesteps = {8000};
simopt.horizon = {0};
simopt.dt = {0.01};
simopt.delays = {1};
simopt.noise = {{struct('type','none')}};

simopt = combinedata(simopt);

%% III. Simulate system
for i = 1:length(simopt)
    simdata{i} = simsys(simopt{i},config);
end

%% IV. Plot trajectories
for i = 1:length(simdata)
    X = simdata{1,i}.X;
    plot3(X(1,:),X(2,:),X(3,:),'Color','k'); 
    hold on;
end

%% Reconstruct
delays = 3;
spacing = [1 2]; % 2 and 10
X_ = hankmat(simdata{1,1}.X(1,:),delays,spacing);
X_ = flipud(X_);
plot3(X_(1,:),X_(2,:),X_(3,:),'Color','g'); 

pgfplot3(X_(1,:),X_(2,:),X_(3,:),...
    '2_lorenz_embed_','C:\Users\bouaz\Desktop\Thesis\pics');