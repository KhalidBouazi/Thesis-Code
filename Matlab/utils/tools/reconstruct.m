function X = reconstruct(Phi, omega, b, t)

%% Cut off real frequency part
omega_ = imag(omega)*1j;

%% Compute mode dynamics
for i = 1:length(t)
    dynamics(:,i) = diag(exp(omega_*t(i)))*b;
end

%% Reconstruct signal
X = real(Phi*dynamics);

end