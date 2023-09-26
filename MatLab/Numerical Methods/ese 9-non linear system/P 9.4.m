clear all
close all
disp("_____________");
n=10;

A=diag(5*ones(n,1))+diag(-ones(n-1,1),1)+diag(-ones(n-1,1),-1);
g=@(x)(-2*sin(x)+pi).*ones(n,1);
f=@(x)A*x+g(x);
J=@(x)A-2*cos(x).*ones(n,1);

x0=ones(n,1);
tol=10^(-8);
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


xb=x0;
it_b=0;
er_b=10;
tic
while er_b>tol
    it_b=it_b+1;
    xb_=xb;
   
    J_ap=ones(n);
for i=1:n
    v=zeros(n,1);
    v(i)=sig;
    
    J_ap(:,i)=(f(xb+v)-f(xb))/sig;
    
end 
    
    xb=xb-J_ap\f(xb);
    er_b=norm(xb-xb_);
end 
t_b=toc;
clear xb_ 
%c)
xc=x0;
it_c=0;
er_c=10;
tic

 J0=ones(n);
for i=1:n
    v=zeros(n,1);
    v(i)=sig;
    
    J0(:,i)=(f(xc+v)-f(xc))/sig;
    
end 
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

phi=@(x)-A\g(x);
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

clear A g i n phi sig tol x0 x_