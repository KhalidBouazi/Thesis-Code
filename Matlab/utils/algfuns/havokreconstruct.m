function V_ = havokreconstruct(A, B, u, v0, dt)

%% Create index span
L = 1:size(u,1);

%% Create system object and simulate
C = eye(size(A,1));
D = 0*B;
sys = ss(A,B,C,D);
[V_,~] = lsim(sys,u,dt*(L-1),v0);

end