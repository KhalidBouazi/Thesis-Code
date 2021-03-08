%% vanderpol
n = 1000;
t = hdmdresult{1,1}.t(1,1:200);
X = hdmdresult{1,1}.X(1,1:200);
X = repmat(X,n,1);
Xhat = X + 0.3*randn(size(X));

%% svd
[U,S,V] = svd(Xhat,'econ');
keep = 1;
U_ = U(:,1:keep);
S_ = S(1:keep,1:keep);
V_ = V(:,1:keep);
X_ = U_*S_*V_';
Sn = S./sqrt(sum(diag(S).^2));

%%
figure;
subplot(2,1,1);
plot(X(1,:));
hold on;
plot(Xhat(1,:));
plot(X_(1,:));
legend('true','unf','f');

subplot(2,1,2);
plot(V(:,1));
legend('v1','v2');

figure;
k = 10;
scatter(1:10,diag(S(1:k,1:k)));
hold on;
scatter(1:keep,diag(S_));

%%
singvals = [(1:k)' diag(Sn(1:k,1:k))];
mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\2_svd_singvals');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\2_svd_singvals\1.txt', 'singvals', '-ascii', '-double', '-tabs');


%%
pgfplot(t,X(1,:),'1',...
    t,Xhat(1,:),'2',...
    t,X_(1,:),'3','2_svd_signal','C:\Users\bouaz\Desktop\Thesis\pics');

pgfplot(t,V(:,1),'2_svd_rsv','C:\Users\bouaz\Desktop\Thesis\pics');







