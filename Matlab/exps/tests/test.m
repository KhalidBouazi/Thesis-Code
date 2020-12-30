data2 = hdmdcresult{1,1};

A = data.A;
H = data2.H;
H_ = data2.H_;
Hu = data2.Hu;
Hu_ = data2.Hu_;

Hy = H(:,1:end-1);
Hyp = H(:,2:end);
Hu = Hu(:,1:end-1);

B = (Hyp - A*Hy)*pinv(Hu);

Y_(:,1) = H(:,1);
for i = 2:cols(Hu_)
    Y_(:,i) = A*Y_(:,i-1) + B*Hu_(:,i-1);
end

Y_ = real(Y_);

plot(H_(1,:));
hold on;
plot(Y_(1,:));