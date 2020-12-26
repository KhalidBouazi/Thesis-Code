function Y_ = dmdreconstruct(Phi,D,Y0,timesteps)

%% ...
A = Phi*D*pinv(Phi);
Y_(:,1) = Y0;

%% Reconstruct dynamics
for i = 2:timesteps
    Y_(:,i) = A*Y_(:,i-1);
end

Y_ = real(Y_);

end