function [W,d] = eigdec(A)

%% Compute eigenvalue decomposition
[W,D] = eig(A);
d = diag(D);

%% Sort eigenvalues and vectors in descending order
[d,sortIdx] = sort(d,'descend');
W = W(:,sortIdx);

end

