addpath(genpath('C:\Users\bouaz\Desktop\Thesis-Code\Matlab'));

%% Set parameters
dt = 0.01;
timesteps = 1000;
rank = 3;
delays = 100;

%% Simulate lorenz system
[t,X] = simsys('lorenz',dt,timesteps);

%% Compute DMD
[out,Phi,omega,b] = DMD(X,dt,rank,delays);

%% Reconstruct signal
X_ = reconstruct(Phi,omega,b,t);
