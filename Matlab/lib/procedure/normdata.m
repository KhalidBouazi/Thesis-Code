function algdata = normdata(algdata)

%% Get maximum absolute values of time series
Y = algdata.Y;
maxVal = max(Y,[],2);
minVal = min(Y,[],2);

%% Normalize data to range [-1,1]
algdata.normValsY = max(abs(minVal),maxVal);
algdata.Yn = Y./algdata.normValsY;

end