%%
n = [16];
% n = [4]; %dimred
leg = {};

for i = n
    res = hdmdcresult{1,i};
%     res = dimredres{1,i};

    A = res.Atilde_; %res.Atilde_
    B = res.Btilde_; %res.Btilde_
    dt = res.dt;
    
    %
    [V,D,W] = eig(A);
    d = diag(D);
    xi = [];
    for j = 1:size(W,2)
        w = W(:,j);
        xi(j) = (w'*B*B'*w)/(w'*w);
    end
    [xi_sorted,idx] = sort(xi,'descend');
    d_sorted = d(idx);
    omega_sorted = log(d_sorted)/dt;
    colors = repmat(idx'/max(idx),1,3);
    figure;
    scatter(real(omega_sorted), imag(omega_sorted), 10, colors);
    figure;
    plot(real(xi_sorted));
    
    %%
    C = ctrb(A,B);
    rank(C)

    %%
%     [U,S,V] = svd(C,'econ');

    Wc = dlyap(A,B*B');
    [W,D] = eig(Wc);
    s = diag(D);
    
%     s = diag(S);
    scatter(1:length(s),s);
    hold on;
    set(gca, 'YScale', 'log');
    leg = [leg {num2str(i)}];
end
legend(leg);