%% I. First close all windows and clear workspace
close all;
clear simopt simdata Y_;

%% II. Define simulation params
simopt.system = {'duffing'};
simopt.params = {[]};
simopt.x0 = {[]};
simopt.delays = {1};
simopt.timesteps = {2000};
simopt.horizon = {0};
simopt.dt = {0.01};

simopt = combinedata(simopt);

%% III. Simulate system
for i = 1:length(simopt)
    simdata{i} = simsys(simopt{i},config);
end

%% IV. Simulate Reonstruction
n = 1;
m = 2;
omega = hdmdresult{1,n}.omega;
Phi = hdmdresult{1,n}.Phi;
b = hdmdresult{1,n}.b;
t = 0:simopt{1}.dt:(simopt{1}.timesteps-1)*simopt{1}.dt;
for i = 1:length(t)
    e = diag(exp(omega*t(i)));
    Y_(:,i) = Phi*e*b;
end
Y_ = real(Y_);

%% IV. Plot trajectories
Y = simdata{1,1}.X(m,:);
plot(Y);
hold on;
plot(Y_(1,:));

