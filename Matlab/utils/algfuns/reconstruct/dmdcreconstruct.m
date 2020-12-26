function Y_ = dmdcreconstruct(A,B,U,Y0)

%% Compute A as Operator with modes as eigenvectors
Y_(:,1) = Y0;

%% Reconstruct dynamics
timesteps = size(U,2);
for i = 2:timesteps
    Y_(:,i) = A*Y_(:,i-1) + B*U(:,i-1);
end

Y_ = real(Y_);

end