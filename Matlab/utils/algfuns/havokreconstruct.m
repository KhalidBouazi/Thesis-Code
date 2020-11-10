function V_ = havokreconstruct(A, B, Vs, dt)

%% Create index span
L = 1:size(Vs,1);

%% Extract forcing and initial value
u = Vs(L,end);
v0 = Vs(1,1:end-1);

%% Create system object and simulate
C = eye(size(A,1));
D = 0*B;
sys = ss(A,B,C,D);
[V_,~] = lsim(sys,u,dt*(L-1),v0);

end