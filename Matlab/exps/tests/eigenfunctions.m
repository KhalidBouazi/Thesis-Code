x = -5:0.05:5;
y = x;
[X,Y] = meshgrid(x);

alpha = (-1/(-1 - 2*(-0.1)));

E = X;
F = Y - alpha*X.^2;
G = alpha*Y + X.^2;

figure;

subplot(1,3,1);
surf(X,Y,E);
xlabel('x_1');
ylabel('x_2');
zlabel('\phi_1(x)'); shading interp
view(2);

subplot(1,3,2);
surf(X,Y,F);
xlabel('x_1');
ylabel('x_2');
zlabel('\phi_2(x)'); shading interp
view(2);

subplot(1,3,3);
surf(X,Y,G)
xlabel('x_1');
ylabel('x_2');
zlabel('\phi_3(x)'); shading interp
view(2);