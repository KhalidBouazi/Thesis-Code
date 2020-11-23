function algdata = normdata(algdata)

Y = algdata.Y;
maxVal = max(Y,[],2);
minVal = min(Y,[],2);

algdata.normValsY = max(abs(minVal),maxVal);
algdata.Yn = Y./algdata.normValsY;

end