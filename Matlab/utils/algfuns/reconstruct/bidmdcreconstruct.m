function Y_ = bidmdcreconstruct(D, Phi, b, B, U)

%% Scale discrete eigenvalues to magnitude 1
D_ = D; %D/abs(D);

%% Compute A as Operator with modes as eigenvectors
A = Phi*D_*pinv(Phi);

%% Reconstruct dynamics
timesteps = size(U,2);
tempU = zeros(size(Phi,1),size(b,2));
for i = 1:timesteps
    Y_(:,i) = real(Phi*(D_^(i-1))*b + tempU);
    tempU = A*tempU + B*Y_(:,i).*U(:,i);
end

end