function [U,S,V] = truncsvd(X, rank)

%% Compute svd
[U,S,V] = svd(X,0);

%% Truncate svd
if ~isempty(rank) && rank < size(S,1)
    U = U(:,1:rank);
    S = S(1:rank,1:rank);
    V = V(:,1:rank);
end

end