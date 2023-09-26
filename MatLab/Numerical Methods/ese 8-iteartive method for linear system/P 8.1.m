clear all
close all
disp("_____________")
%a)
n=25;
A=eye(n)+hilb(n);
xex=-ones(n,1);
b=A*xex;
tol=10^(-13);
maxit=100;
[x_a,flag_a,relres_a,iter_a]=pcg(A,b,tol,maxit);

rel_er_a=norm(x_a-xex)/norm(xex);
x0=-0.5*ones(n,1);
[x_my,er,iter_my]=cnj_grad(A,b,x0,tol,maxit);

%b)
P=diag(diag(A));
[x_b,flag_b,relres_b,iter_b]=pcg(A,b,tol,maxit,P);
rel_er_b=norm(x_b-xex)/norm(xex);