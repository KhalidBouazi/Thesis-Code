function algstruct = reconstruct(algstruct)

%% Check obligatory and optional function arguments
oblgfunargs = {'Phi','omega','b','t'};
optfunargs = {};
optargvals = {};
algstruct = checkandfillfunargs(algstruct,oblgfunargs,optfunargs,optargvals);

%% Run for every algorithm combination
for i = 1:length(algstruct)
    
    % Cut off real frequency part
    omega_ = imag(algstruct(i).omega)*1j;

    % Compute mode dynamics
    dynamics = zeros(size(algstruct(i).Phi,2),length(algstruct(i).t));
    for j = 1:length(algstruct(i).t)
        dynamics(:,i) = diag(exp(omega_*algstruct(i).t(j))) * algstruct(i).b;
    end

    % Reconstruct signal
    Y_ = real(algstruct(i).Phi*dynamics);

    % Save in algstruct
    algstruct(i).Y_ = Y_;
    
end

end