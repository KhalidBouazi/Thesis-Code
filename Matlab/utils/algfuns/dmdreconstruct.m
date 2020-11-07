function Y_ = dmdreconstruct(Phi, omega, b, t)

%% Cut off real frequency part
omega_ = imag(omega)*1j;

%% Compute mode dynamics
dynamics = zeros(size(Phi,2),length(t));
for j = 1:length(t)
    dynamics(:,j) = diag(exp(omega_*t(j))) * b;
end

%% Reconstruct signal
Y_ = real(Phi*dynamics);

end