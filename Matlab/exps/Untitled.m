[phi, dphi]=meshgrid(-5:0.1:5,-5:0.1:5);
Dphi=dphi;
DDphi=-9.81/1*sin(phi);
L=sqrt(1+Dphi.^2);
quiver(Dphi, DDphi, Dphi./L, DDphi./L, 1)
axis tight