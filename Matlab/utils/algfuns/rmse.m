function rmse = rmse(X, X_)

%% Check size of signals
if size(X) ~= size(X_)
    error('RMSE: Size of signals does not match.');
end

%% Check if more rows that columns
if size(X,1) > size(X,2)
    X = X';
    X_ = X_';
end
X = X(:,1:size(X_,2));

%% Compute rmse
rmse = sqrt(mean((X - X_).^2,2));

end