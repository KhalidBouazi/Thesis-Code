function Y_ = dmdreconstruct(A,Y0,timesteps)

%% ...
Y_(:,1) = Y0;

%% Reconstruct dynamics
for i = 2:timesteps
    Y_(:,i) = A*Y_(:,i-1);
end

Y_ = real(Y_);

end