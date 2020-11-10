function W_ = convcoordreconstruct(A, W, dt)

%% Extract initial value
w0 = W(:,1);

%% Create system object and simulate
u = zeros(1,size(W,2));
B = zeros(size(A,1),1);
C = eye(size(A,1));
D = 0*B;
sys = ss(A,B,C,D);
[W_,~] = lsim(sys,u,dt*(0:size(W,2)-1),w0);
W_ = W_';

end