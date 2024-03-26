clear all
close all
disp ("_______________")
f=@(x)x.^2-x+1-exp(x);
g=@(x)x.^4-x.^3-7*x.^2+x+6;
h=@(x)x.^4-3*x.^3-3*x.^2+11*x-6;

df=@(x) 2*x-1-exp(x);
dg=@(x)4*x.^3-3*x.^2-14*x+1;
dh=@(x)4*x.^3-9*x.^2-6*x+11;

dphi_f=@(x)2.*f(x).*df(x);
dphi_g=@(x)2.*g(x).*dg(x);
dphi_h=@(x)2.*h(x).*dh(x);

x0f=[0.5 ];
x0g=[-2.1 -1.1 1.1 3.1];
x0h=[-2 1 3];

y=[0.1];

tol=10^(-10);
%1)
for i=1:length(x0f)
 for j=1:length(y)
      [xf(i,j),erf(i,j),iterationf(i,j)] = step_descent(x0f(i),dphi_f,tol,y(j));
 end 
end 

for i=1:length(x0g)
 for j=1:length(y)
      [xg(i,j),erg(i,j),iterationg(i,j)] = step_descent(x0g(i),dphi_g,tol,y(j));
 end 
end 

for i=1:length(x0h)
 for j=1:length(y)
      [xh(i,j),erh(i,j),iterationh(i,j)] = step_descent(x0h(i),dphi_h,tol,y(j));
 end 
end 

 