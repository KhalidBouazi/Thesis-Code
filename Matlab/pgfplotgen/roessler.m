%% I. First close all windows and clear workspace
close all;
clear simopt simdata;

%% II. Define simulation params
simopt.system = {'roessler'};
simopt.params = {[]};
simopt.x0 = {[]};
simopt.timesteps = {15000};
simopt.horizon = {0};
simopt.dt = {0.02};

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

%% V. Save as tikz
pgfplot3(simdata{1,1}.X(1,:),simdata{1,1}.X(2,:),simdata{1,1}.X(3,:),...
    '2_roessler','C:\Users\bouaz\Desktop\Thesis-Tex\texmf\tex\latex\tuddesign\report\Bilder');