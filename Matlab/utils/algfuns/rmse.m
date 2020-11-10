function [RMSE,rmse] = rmse(X, X_)

%% Check size of signals
if all(size(X) ~= size(X_))
    error('RMSE: Size of signals does not match.');
end

%% Check if more rows that columns
if size(X,1) > size(X,2)
    X = X';
    X_ = X_';
end

%% Compute rmse
RMSE = sqrt(mean((X - X_).^2,2));
for i = 1:size(X,2)
    rmse(:,i) = sqrt(mean((X(:,1:i) - X_(:,1:i)).^2,2));
end

end