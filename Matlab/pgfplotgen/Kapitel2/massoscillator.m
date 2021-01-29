%% I. First close all windows and clear workspace
close all;
clear simopt simdata;

%% II. Define simulation params
simopt.system = {'massoscillator'};
simopt.params = {[1,1,0]};
simopt.x0 = {[1,0],[1.5,0],[2,0],[2.5,0],[3,0],[3.5,0]};
simopt.timesteps = {450};
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
    plot(X(1,:),X(2,:),'Color','k'); 
    hold on;
end
ylim([-4 4]);

%% V. Save as tikz
pgfplot(simdata{1,1}.X(1,:),simdata{1,1}.X(2,:),'1',...
    simdata{1,2}.X(1,:),simdata{1,2}.X(2,:),'2',...
    simdata{1,3}.X(1,:),simdata{1,3}.X(2,:),'3',...
    simdata{1,4}.X(1,:),simdata{1,4}.X(2,:),'4',...
    simdata{1,5}.X(1,:),simdata{1,5}.X(2,:),'5',...
    simdata{1,6}.X(1,:),simdata{1,6}.X(2,:),'6',...
    '2_massoscillator_harmosz','C:\Users\bouaz\Desktop\Thesis-Tex\texmf\tex\latex\tuddesign\report\Bilder');