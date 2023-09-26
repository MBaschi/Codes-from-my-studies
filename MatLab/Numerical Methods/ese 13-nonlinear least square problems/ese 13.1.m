clear all
close all
disp("////////////////////////////////77")
Lx=2;
Ly=2;
x0=[0.5
    0.5];

tol=10^(-8);
gam=0.001;

f=@(x)15+x(1)+2*x(2)-(80/(Lx^2))*((x(1)-Lx/2)^2+(x(2)-Ly/2)^2)+(300/(Ly^4))*((x(1)-Lx/2)^4+(x(2)-Ly/2)^4);
grad=@(x)[1-(160/(Lx^2))*(x(1)-Lx/2)+(1200/(Ly^4))*(x(1)-Lx/2)^3
          2-(160/(Lx^2))*(x(2)-Ly/2)+(1200/(Ly^4))*(x(2)-Ly/2)^3];
 
%(0)
x_fmin=fminsearch(f,x0);
%(a)
tic
xa=x0;
e=10;
it_a=0
while e>tol
   xa_prec=xa;
   xa=xa-gam*grad(xa);
   e=norm(xa-xa_prec)/norm(xa);
   it_a=it_a+1;
end
clear xa_prec
ta=toc;
%(b)
tic
xb=x0;
eb=10;
gam_m=gam;
it_b=0;
while eb>tol;
    gam_m=gam;
    m=1;
    while f(xb-(gam/(2^m))*grad(xb))-f(xb)>=(gam/(2^(m+1)))*(norm(grad(xb))^2)
      m=m+1;
    end
    xb_prec=xb;
    xb=xb-gam_m*grad(xb);
    eb=norm(xb-xb_prec)/norm(xb);
    it_b=it_b+1;
    if(it_b>1000)
      break
    end
end
clear xb_prec
tb=toc
%(c)
disp("_____________________________________________")