close all
clear all

f=@(x)[x(1)-x(2)/4
       x(1)^2+x(2)^2+x(3)^2-1/2
       x(3)-x(1)^2-x(2)^2];

   J=@(x)[1 -1/4 0
          2*x(1) 2*x(2) 2*x(3)
          -2*x(1) -2*x(2) 1];
x0=[0.1 0.3 0.3]';

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
    abs_er_a=abs(max(sigma));
    
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
    abs_er_b=abs(max(sigma));
    
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
    abs_er_c=abs(max(sigma));
    
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
    
    abs_er_d=abs(max(sigma));
    
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
    abs_er_e=abs(max(sigma));
    
    iteration_e=iteration_e+1;
end
t_e=toc;

%fixed point
g=@(x)[x(2)/4
       (-x(1)^2-x(3)^2+1/2)^(1/2)
       x(1)^2+x(2)^2];
   
  x_fp=x0;
  abs_er_fp=1;
  iteration_fp=0;
  tic 
  while abs_er_fp>tol
       x_fp_1=x_fp;
      x_fp=g(x_fp);
      
      abs_er_fp=abs(max(x_fp_1-x_fp));
      iteration_fp=iteration_fp+1;
      
  end
  t_fp=toc;