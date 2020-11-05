data = HAVOKdata(1);
m = length(data.A);

%% Create initial condition
[U,S,V] = svd(data.x0,'econ');
x0 = data.V(3,1:end-1);

%% Create timespan
tspan = (0:data.dt:data.dt*(data.timesteps-1));

%% Simulate system
sys = ss(data.A,data.B,eye(m),0*data.B);
size(data.V(:,end))
size(tspan)
[X,t] = lsim(sys,data.V(:,end),tspan,data.V(3,1:end-1));

figure;
for i = 1:m
    subplot(ceil(m/2),2,i);
    plot(t,X(:,i));
end
