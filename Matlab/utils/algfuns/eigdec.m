function [W,D] = eigdec(A)

%% Compute eigenvalue decomposition
[W,D] = eig(A);

%% Sort eigenvalues and vectors in descending order
[d,sortIdx] = sort(abs(diag(D)),'descend');
W = W(:,sortIdx);
D = diag(d);

end

