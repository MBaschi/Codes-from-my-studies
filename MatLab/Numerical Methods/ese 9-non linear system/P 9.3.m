clear all
close all
disp("_______________________");
f=@(x)[x(1)-x(2)/4
       x(1)^2+x(2)^2+x(3)^2-1/2
       -x(1)^2-x(2)^2+x(3)];
   
J=@(x)[1 -1/4 0
       2*x(1) 2*x(2) 2*x(3)
       -2*x(1) -2*x(2) 1];
x0=[0.1 0.3 0.3]';
tol=10^(-12);
x_fsolve=fsolve(f,x0);

%a)
xa=x0;
it_a=0;
er_a=10;
tic
while er_a>tol
    it_a=it_a+1;
    xa_=xa;
    
    xa=xa-J(xa)\f(xa);
    er_a=norm(xa-xa_);
end 
t_a=toc;
clear xa_
%b)
sig=0.01;
v1=[sig 0 0]';
v2=[0 sig 0]';
v3=[0 0 sig]';
J_ap=@(f,x) [(f(x+v1)-f(x))/sig (f(x+v2)-f(x))/sig (f(x+v3)-f(x))/sig];

xb=x0;
it_b=0;
er_b=10;
tic
while er_b>tol
    it_b=it_b+1;
    xb_=xb;
    
    xb=xb-J_ap(f,xb)\f(xb);
    er_b=norm(xb-xb_);
end 
t_b=toc;
clear xb_ 
%c)
xc=x0;
it_c=0;
er_c=10;
tic
J0=J_ap(f,xb);
while er_c>tol
    it_c=it_c+1;
    xc_=xc;
    
    xc=xc-J0\f(xc);
    er_c=norm(xc-xc_);
end 
t_c=toc;
clear xc_ J0 

%d)
xd=x0;
it_d=0;
er_d=10;
Jd=J(x0);
tic
while er_d>tol
    it_d=it_d+1;
    xd_=xd;
    
    sig_x=-Jd\f(xd);
    xd=xd+sig_x;
    sig_f=f(xd)-f(xd_);
    Jd=Jd+((sig_f-Jd*sig_x)*(sig_x)')/(sig_x'*sig_x);
    er_d=norm(xd-xd_);
end 
t_d=toc;

clear xd_ sig_f  Jd

%e)
xe=x0;
it_e=0;
er_e=10;
B=inv(J(x0));
tic
while er_e>tol
    it_e=it_e+1;
    xe_=xe;
    
    sig_x=-B*f(xe);
    xe=xe+sig_x;
    u=f(xe)/norm(sig_x);
    v=sig_x/norm(sig_x);
    B=B-((B*u*v'*B)/(1+v'*B*u));
    
    er_e=norm(xe-xe_);
end 
t_e=toc;
clear xe_  sig_x B u v 
clear f J J_ap vi v2 v3 

%fixed point
xf=x0;
it_f=0;
er_f=10;

phi=@(x)[+x(2)/4
         (-x(1)^2-x(3)^2+1/2)^(1/2)
         x(1)^2+x(2)^2];
tic
while er_f>tol
    x_=xf;
    it_f=it_f+1;
    
    xf=phi(xf);
    er_f=norm(xf-x_);
    if it_f>10000
        break
    end 
end
t_f=toc;
