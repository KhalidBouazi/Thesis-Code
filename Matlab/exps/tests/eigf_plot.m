x = -4:0.5:4;
y = x;
[X,Y] = meshgrid(x,y);
d = -1;
g = -0.1;
l = d/(d-2*g);

Z1 = X;
p1 = [X(:),Y(:),Z1(:)];
Z2 = Y - l*X.^2;
p2 = [X(:),Y(:),Z2(:)];
Z3 = l*Y + X.^2;
p3 = [X(:),Y(:),Z3(:)];

subplot(1,3,1);
surf(X,Y,Z1);
xlabel('x1');
ylabel('x2');
zlabel('phi');
subplot(1,3,2);
surf(X,Y,Z2);
xlabel('x1');
ylabel('x2');
zlabel('phi');
subplot(1,3,3);
surf(X,Y,Z3);
xlabel('x1');
ylabel('x2');
zlabel('phi');

%%
pgfplot3(p1(:,1),p1(:,2),p1(:,3),'3_eigf1','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot3(p2(:,1),p2(:,2),p2(:,3),'3_eigf2','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot3(p3(:,1),p3(:,2),p3(:,3),'3_eigf3','C:\Users\bouaz\Desktop\Thesis\pics');