%% I. First close all windows and clear workspace
close all;
clear simopt simdata;

%% II. Define simulation params
simopt.system = {'massoscillator'};
simopt.params = {[]};
simopt.x0 = {[0.4 0]};
simopt.timesteps = {1000};
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
    plot(X(1,:),X(2,:),'Color','k'); 
    hold on;
end
ylim([-5 5]);

%% V. Save as tikz
pgfplot(simdata{1,1}.X(1,:),simdata{1,1}.X(2,:),'2_massoscillator_damped','C:\Users\bouaz\Desktop\Thesis\pics');