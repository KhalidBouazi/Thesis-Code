function [U_,S_,Sn,Sn_,V_] = truncsvd(X, rank)

%% Compute svd
[U_,S_,V_] = svd(X,'econ');

%% Normalize singular values
Sn_ = S_./sqrt(sum(diag(S_).^2));
Sn = Sn_;

%% Truncate svd
if ~isempty(rank) && rank < size(S_,1)
    U_ = U_(:,1:rank);
    S_ = S_(1:rank,1:rank);
    Sn_ = Sn_(1:rank,1:rank);
    V_ = V_(:,1:rank);
end

end