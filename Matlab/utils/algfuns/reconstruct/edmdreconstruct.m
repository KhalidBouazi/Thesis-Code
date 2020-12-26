function Y_ = edmdreconstruct(Phi0, Km, D, timesteps)

%% Reconstruct dynamics
for i = 1:timesteps
    Y_(:,i) = real(Km*diag(Phi0)*D^i);
end

end