function [U,S,Sn,V] = truncsvd(X, rank)

%% Compute svd
[U,S,V] = svd(X,'econ');

%% Normalize singular values
Sn = S./sqrt(sum(diag(S).^2));

%% Truncate svd
if ~isempty(rank) && rank < size(S,1)
    U = U(:,1:rank);
    S = S(1:rank,1:rank);
    Sn = Sn(1:rank,1:rank);
    V = V(:,1:rank);
end

end