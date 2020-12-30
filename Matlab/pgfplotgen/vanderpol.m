%% I. First close all windows and clear workspace
close all;
clear simopt simdata;

%% II. Define simulation params
simopt.system = {'vanderpol'};
simopt.params = {[]};
simopt.x0 = {[4,-5],[3.5,-5],[3,-5],[2.5,-5],[2,-5],[-3,-5],...
    [-4,5],[-3.5,5],[-3,5],[-2.5,5],[-2,5],[3,5],...
    [0,-0.2],[0,0.2],[2,0]};
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
    simdata{1,7}.X(1,:),simdata{1,7}.X(2,:),'7',...
    simdata{1,8}.X(1,:),simdata{1,8}.X(2,:),'8',...
    simdata{1,9}.X(1,:),simdata{1,9}.X(2,:),'9',...
    simdata{1,10}.X(1,:),simdata{1,10}.X(2,:),'10',...
    simdata{1,11}.X(1,:),simdata{1,11}.X(2,:),'11',...
    simdata{1,12}.X(1,:),simdata{1,12}.X(2,:),'12',...
    simdata{1,13}.X(1,:),simdata{1,13}.X(2,:),'13',...
    simdata{1,14}.X(1,:),simdata{1,14}.X(2,:),'14',...
    simdata{1,15}.X(1,:),simdata{1,15}.X(2,:),'15',...
    '2_vanderpol_grenzzyklus','C:\Users\bouaz\Desktop\Thesis-Tex\texmf\tex\latex\tuddesign\report\Bilder');
