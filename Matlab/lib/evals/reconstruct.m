function Y_ = reconstruct(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Phi','omega','b','t'};
optfunargs = {};
optargvals = {};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);
    
%% Cut off real frequency part
omega_ = imag(algdata.omega)*1j;

%% Compute mode dynamics
dynamics = zeros(size(algdata.Phi,2),length(algdata.t));
for j = 1:length(algdata.t)
    dynamics(:,j) = diag(exp(omega_*algdata.t(j))) * algdata.b;
end

%% Reconstruct signal
Y_ = real(algdata.Phi*dynamics);

end