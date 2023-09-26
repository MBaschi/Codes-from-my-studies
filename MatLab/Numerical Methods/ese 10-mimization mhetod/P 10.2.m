clear all
close all
disp("________________")
phi=@(x) (x(1)^2+x(2)^2)^2-15*(4*x(1)^2+(x(2)/2)^2)+20*x(1)+5*x(2);
Vphi=@(x) [2*(x(1)-a)-4*b*x(1)*(x(2)-x(1)^2);2*b*(x(2)-x(1)^2)];

fphi=@(x,y) (x.^2+y.^2).^2-15*(4*x.^2+(y/2).^2)+20*x+5*y;
x_mesh=-7:0.1:7;
[X,Y]=meshgrid(x_mesh,x_mesh);
surf(X,Y,fphi(X,Y));
figure
contour(X,Y,fphi(X,Y));
