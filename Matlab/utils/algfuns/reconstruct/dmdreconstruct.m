function Y_ = dmdreconstruct(D, Phi, b, timesteps)

%% Scale discrete eigenvalues to magnitude 1
D_ = D; %D/abs(D);

%% Reconstruct dynamics
for i = 1:timesteps
    Y_(:,i) = real(Phi*(D_^(i-1))*b);
end

end