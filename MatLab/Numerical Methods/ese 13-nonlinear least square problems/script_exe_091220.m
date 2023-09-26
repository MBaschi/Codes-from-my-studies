%% Exe 1

close all
clear all
format long
Lx=2;
Ly=2;
phi=@(x) 15+x(1)+2*x(2)-80*((x(1)-Lx*0.5).^2 +(x(2)-Ly*0.5).^2)/Lx^2 ...
    +300*((x(1)-Lx*0.5).^4 +(x(2)-Ly*0.5).^4)/Ly^4;
x=[0:0.05:Lx];
y=[0:0.05:Ly];

for i=1:size(x,2)
    for j=1:size(y,2)
        Z(j,i)=phi([x(i), y(j)]);
    end
end

surf(x,y,Z)
colorbar

%% (a) Find minimum of phi with the modified gradient method

dphi = @(x) [1-160/Lx^2*(x(1)-Lx*0.5)+1200/Lx^4*(x(1)-Lx*0.5).^3;
    2-160/Ly^2*(x(2)-Ly*0.5)+1200/Ly^4*(x(2)-Ly*0.5).^3];

x0 = [0.5 0.5]';
tol = 10^(-8);

maxit = 1000;

modif=1;

tic
[x_sd, it_sd] = my_steepest_descent(x0, phi, dphi, maxit, tol, modif)
time=toc

%% (c) Find minimum of phi using Newton's method on dphi with exact Jacobian

x0 = [0.5 0.5]';
tol = 10^(-8);

H_phi = @(x) [-160/Lx^2+3600/Lx^4*(x(1)-Lx*0.5).^2 0;
    0 -160/Ly^2+3600/Ly^4*(x(2)-Ly*0.5).^2];

[x_nt, it_nt, t_nt]     = my_newton( x0, dphi, H_phi, maxit, tol )


%% Exe 2
% (a) Solve the problem with basic algorithm
clear all
close all
format long

x0=[1 1 1]';

sigma=0.5;
h=@(z) z.^3+z.^2-1;
z=[1:0.01:3]';
b=h(z) +sigma*randn(size(z));
phi=@(x) z.^x(1) +z.^x(2) +x(3) -b;
xx_base=lsqnonlin(phi,x0,[],[])
zz=[1:0.002:3]';
ff= zz.^xx_base(1) +zz.^xx_base(2) +xx_base(3);
figure
plot(z,h(z),'k',z,b,'ro',zz,ff,'b','LineWidth',2)
legend('h', 'b', 'f')

%% (b) Solve the problem with Levenberg-Marquardt

options_lm = optimoptions(@lsqnonlin, 'Algorithm','levenberg-marquardt');
xx_lm      = lsqnonlin(phi,x0,[],[],options_lm)
ff_lm      = zz.^xx_lm(1) +zz.^xx_lm(2) +xx_lm(3);
figure
plot(z,h(z),'k',z,b,'ro',zz,ff_lm,'b','LineWidth',2)
legend('h', 'b', 'f')

%% (c) Solve the problem with fsolve on J'_f*(f(x)-b)

x0 = [2.5 1.  1.]';

fun2s1=@(x) g2(x,z,b);
options=optimset('TolX',1e-8, 'Display', 'iter');
[xx_fs,fval] = fsolve(fun2s1, x0,options);

zz=[1:0.002:3]';
ff= zz.^xx_fs(1) +zz.^xx_fs(2) +xx_fs(3);
xx_fs
figure
plot(z,h(z),'k',z,b,'ro',zz,ff,'b','LineWidth',2)
legend('h', 'b', 'f')

%
%% (d) Solve the problem with Newton and finite difference
%     approximate constant Jacobian with delta = 0.01;
%

x0 = [2.8 1.  1.]';

fun2s1=@(x) g2(x,z,b);
delta = 0.01;
maxit=200;
tol=10^(-8);

[xx_nt, it_nt, t_nt] = newton_inexactjacobian( x0, fun2s1, delta, maxit, tol )

ff_nt= zz.^xx_nt(1) +zz.^xx_nt(2) +xx_nt(3);
figure
plot(z,h(z),'k',z,b,'ro',zz,ff_nt,'b','LineWidth',2)
legend('h', 'b', 'f')


%% Exe 3-4

clear all
close all
format long
    
x0=[1 1 1 1 1 1]';

sigma=.5;
h=@(z) cos(pi*z)-2*cos(5*pi*z)+cos(6*pi*z);
z=[0:0.001:2]';
b=h(z)+sigma*randn(size(z));
f=@(x) x(1)*cos(x(2)*pi*z)+x(3)*cos(x(4)*pi*z)+x(5)*cos(x(6)*pi*z)-b;
xx_base=lsqnonlin(f,x0,[],[]);
zz=[0:0.001:2]';
ff= xx_base(1)*cos(xx_base(2)*pi*zz)+xx_base(3)*cos(xx_base(4)*pi*zz)+xx_base(5)*cos(xx_base(6)*pi*zz);
figure
plot(z,h(z),'k',z,b,'ro',zz,ff,'b','LineWidth',2)
legend('h', 'b', 'f')

%% (b) Solve the problem with Levenberg-Marquardt

options_lm=optimoptions(@lsqnonlin, 'Algorithm','levenberg-marquardt');
xx_lm=lsqnonlin(f,x0,[],[],options_lm);
ff_lm= xx_lm(1)*cos(xx_lm(2)*pi*zz)+xx_lm(3)*cos(xx_lm(4)*pi*zz)+xx_lm(5)*cos(xx_lm(6)*pi*zz);
figure
plot(z,h(z),'k',z,b,'ro',zz,ff_lm,'b','LineWidth',2)
legend('h', 'b', 'f')

%% (c) Solve the problem with fsolve on J'_f*(f(x)-b)

fun2s2=@(x) g3(x,z,b);

options_fs=optimset('TolX',10^(-8));
xx_fs = fsolve(fun2s2,  x0, options_fs)

ff_fs= xx_fs(1)*cos(xx_fs(2)*pi*zz)+xx_fs(3)*cos(xx_fs(4)*pi*zz)+xx_fs(5)*cos(xx_fs(6)*pi*zz);
figure
plot(z,h(z),'k',z,b,'ro',zz,ff_fs,'b','LineWidth',2)
legend('h', 'b', 'f')


%% (d) Solve the problem with Newton method- constant approximate Jacobian

delta = 0.001;
maxit=200;
tol=10^(-8);

[xx_nt, it_nt, t_nt] = newton_inexactjacobian( x0, fun2s2, delta, maxit, tol )
figure
ff_nt= xx_nt(1)*cos(xx_nt(2)*pi*zz)+...
    xx_nt(3)*cos(xx_nt(4)*pi*zz)+xx_nt(5)*cos(xx_nt(6)*pi*zz);
plot(z,h(z),'k',z,b,'ro',zz,ff_nt,'b','LineWidth',2)
legend('h', 'b', 'f')

