function W_ = convcoordreconstruct(A, w0, dt, timesteps)

%% Create system object and simulate
u = zeros(1,timesteps);
B = zeros(size(A,1),1);
C = eye(size(A,1));
D = 0*B;
sys = ss(A,B,C,D);
[W_,~] = lsim(sys,u,dt*(0:timesteps-1),w0);
W_ = W_';

end