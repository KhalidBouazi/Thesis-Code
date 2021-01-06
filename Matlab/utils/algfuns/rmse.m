function [RMSE,rmse] = rmse(X, X_)

%% Check size of signals
if all(size(X) ~= size(X_))
    error('RMSE: Size of signals does not match.');
end

%% Compute rmse
% RMSE = sqrt(mean(((X - X_)./X).^2,2));
% rmse = zeros(size(X));
% for i = 1:size(X,2)
%     rmse(:,i) = sqrt(mean(((X(:,1:i) - X_(:,1:i))./X(:,1:i)).^2,2));
% end

RMSE = sqrt(sum((X - X_).^2,2)./sum(X.^2,2));
rmse = zeros(size(X));
for i = 1:size(X,2)
    rmse(:,i) = sqrt(sum((X(:,1:i) - X_(:,1:i)).^2,2)./sum(X(:,1:i).^2,2));
end

end