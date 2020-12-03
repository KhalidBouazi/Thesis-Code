function [Yn,normValsY] = normdata(Y)

%% Normalize data
% maxVal = max(Y,[],2);
% minVal = min(Y,[],2);
% normValsY = max(abs(minVal),maxVal); 
normValsY = 3*std(Y,0,2);
Yn = Y./normValsY;

end