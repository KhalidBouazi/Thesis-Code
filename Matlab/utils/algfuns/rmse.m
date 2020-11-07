function rmse = rmse(X, X_)

%% Check size of signals
if size(X) ~= size(X_)
    error('RMSE: Size of signals does not match.');
end

%% Compute rmse
rmse = sqrt(mean((X - X_).^2,2));

end