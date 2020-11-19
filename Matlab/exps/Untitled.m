% [phi, dphi]=meshgrid(-5:0.1:5,-5:0.1:5);
% Dphi=dphi;
% DDphi=-9.81/1*sin(phi);
% L=sqrt(1+Dphi.^2);
% quiver(Dphi, DDphi, Dphi*2, DDphi*2, 1)
% axis tight

[x,y] = meshgrid(-4*pi:0.1:4*pi,-10:0.1:10);
dphi = y;
ddphi = -9.81*sin(x);

figure
% quiver(x,y,dphi,ddphi)

startx = pi/2;
starty = 0;
streamline(x,y,dphi,ddphi,startx,starty)