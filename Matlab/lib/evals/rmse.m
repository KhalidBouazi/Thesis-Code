function rmse =  rmse(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','Phi','omega','b','t'};
optfunargs = {};
optargvals = {};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Compute rmse
rmse = sqrt(mean((algdata.Y - algdata.Y_).^2,2));

end