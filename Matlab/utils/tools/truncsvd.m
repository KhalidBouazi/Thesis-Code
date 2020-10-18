function [U,S,V] = truncsvd(X, rank)

%% Compute svd
[U,S,V] = svd(X,'econ');

%% Truncate svd
if ~isempty(rank)
    U = U(:,1:rank);
    S = S(1:rank,1:rank);
    V = V(:,1:rank);
end

end