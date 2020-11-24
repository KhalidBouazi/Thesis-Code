function algdata = normdata(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y'};
optfunargs = {};
optargvals = {};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Get maximum absolute values of time series
Y = algdata.Y;
maxVal = max(Y,[],2);
minVal = min(Y,[],2);

%% Normalize data to range [-1,1]
algdata.normValsY = max(abs(minVal),maxVal);
algdata.Yn = Y./algdata.normValsY;

end