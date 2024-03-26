clear all
close all
disp("_______________");
Lx=2;
Ly=2;
f=@(x)15+x(1)+2*x(2)-(80/Lx^2)*((x(1)-Lx/2).^2+(x(2)-Ly/2).^2)+(300/Ly^4)*((x(1)-Lx/2).^4+(x(2)-Ly/2).^4);
x0=[0.5;0.5];
tol=1e-8;
gam=0.001;

%a)
it_a=0;
er_a=5;
xa=x0;
grad_f=@(x) [1-(80/Lx^2)*2*(x(1)-Lx/2)+(300/Ly^4)*4*(x(1)-Lx/2).^3
             2-(80/Lx^2)*2*(x(2)-Ly/2)+(300/Ly^4)*4*(x(2)-Ly/2).^3];
while er_a>tol
    xold=xa;
    xa=xa-gam*grad_f(xa);
    er_a=norm(xa-xold);
    it_a=it_a+1;
    if it_a>1000
        break
    end 
end 

%b)
grad_f_ap=@(x)[ (f(x+[0.01;0])-f(x))/0.01
                (f(x+[0;0.01])-f(x))/0.01];