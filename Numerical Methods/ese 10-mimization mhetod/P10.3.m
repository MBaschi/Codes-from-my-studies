clear all
close all
disp("_________________")
n=10;
A=diag(5*ones(n,1))+diag(-ones(n-1,1),1)+diag(-ones(n-1,1),-1);
g=@(x)(-2*sin(x)+pi*ones(n,1));

f=@(x)A*x - 2*sin(x) + pi*ones(n,1);

phi=@(x)norm(f(x)).^2;

J=@(x)A - 2*diag(cos(x));
Vphi=@(x)2*J(x)'*f(x);
tol=10^(-8);
x0=ones(n,1);

%a)
OPTIONS=optimset('Tolx',tol);
xa = fminsearch(phi,x0,OPTIONS);

%b)
gam=0.1;
xb=x0;
er_b=10;
while er_b>tol
    x_=xb;
    xb=xb-gam*Vphi(xb);
    er_b=norm(xb-x_);
end