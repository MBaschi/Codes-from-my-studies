clear all
close all
%syms x y z;
%sphere=x^2+y^2+z^2;
%paraboloid=x^4+y^4-z;
%plane=x-y;
%f=@(x,y,z)[x^2+y^2+z^2-9
         %  x^4+y^4-z
         %  x-y];
%jacobian([sphere,paraboloid,plane],[x,y,z])


f=@(x)[x(1)^2+x(2)^2+x(3)^2-9
       x(1)^4+x(2)^4-x(3)
       x(1)-x(2)];
J=@(x)[2*x(1) 2*x(2) 2*x(3)
       4*x(1)^3 4*x(2)^3 -1
       1 -1 0];
ex=1;
if ex==1
x0=[1 1 2]';
%format short;
elseif ex==2.1
x0=[2 2 2]';
%format short;
elseif ex==2.2
x0=[10 10 2]';
%format long;
end
   
    
tol=10^(-12);
x_fsolve = fsolve(f,x0);

%(a)
tic;
abs_er_a=1;
x_a=x0;
iteration_a=0;
while abs_er_a>tol
    sigma=J(x_a)\f(x_a);
    x_a=x_a-sigma; 
    abs_er_a=norm(sigma);
    
    iteration_a=iteration_a+1;
end
t_a=toc;

%(b)
dx=@(f,x)(f(x+[0.01;0;0])-f(x))/0.01;
dy=@(f,x)(f(x+[0;0.01;0])-f(x))/0.01;
dz=@(f,x)(f(x+[0;0;0.01])-f(x))/0.01;

J_app=@(f,x,dx,dy,dz)[dx(f,x) dy(f,x) dz(f,x)];

tic;
abs_er_b=1;
x_b=x0;
iteration_b=0;
while abs_er_b>tol
    sigma=J_app(f,x_b,dx,dy,dz)\f(x_b);
    x_b=x_b-sigma; 
    abs_er_b=norm(sigma);
    
    iteration_b=iteration_b+1;
end
t_b=toc;

%(c)
tic;
abs_er_c=1;
x_c=x0;
iteration_c=0;
J_app_0=J_app(f,x_c,dx,dy,dz);
while abs_er_c>tol
    sigma=J_app_0\f(x_c);
    x_c=x_c-sigma; 
    abs_er_c=norm(sigma);
    
    iteration_c=iteration_c+1;
end
t_c=toc;

%(d)

tic;
abs_er_d=1;
x_d=x0;
iteration_d=0;
J_k=J_app(f,x_d,dx,dy,dz);
while abs_er_d>tol
    sigma=-J_k\f(x_d);
    x_d_1=x_d;
    x_d=x_d+sigma; 
    sigma_f=f(x_d)-f(x_d_1);
    J_k=J_k+((sigma_f-J_k*sigma)*sigma')/(sigma'*sigma);
    
    abs_er_d=norm(sigma);
    
    iteration_d=iteration_d+1;
end
t_d=toc;

%(e)

tic;
abs_er_e=1;
x_e=x0;
iteration_e=0;
B=inv(J_app(f,x_e,dx,dy,dz));
while abs_er_e>tol
   
    sigma=-B*f(x_e);
    x_e=x_e+sigma;
    
    u=f(x_e)/norm(sigma);
    v=sigma/norm(sigma);
    
    B=B-((B*u*v'*B)/(1+v'*B*u));
    abs_er_e=norm(sigma);
    
    iteration_e=iteration_e+1;
end
t_e=toc;
