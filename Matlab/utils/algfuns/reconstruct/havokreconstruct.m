function V_ = havokreconstruct(A, B, u, v0, dt, disc)

%% Create index span
L = 1:size(u,1);

%% Create system object and simulate
C = eye(size(A,1));
D = 0*B;
if isempty(disc)
    sys = ss(A,B,C,D);
else
    sys = ss(A,B,C,D,dt);
end
[V_,~] = lsim(sys,u,dt*(L-1),v0);

end