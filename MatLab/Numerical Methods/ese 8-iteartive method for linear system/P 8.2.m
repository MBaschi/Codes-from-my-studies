clear all
close all
disp("___________________")

es="e";

if es=="a"
    n=800;
    B=-ones(n,7);
    B(:,1)=12*ones(n,1);
    d=[0 10 -10 20 -20 80 -80];
    A=spdiags(B,d,n,n);
    xex=-ones(n,1);
    b=A*xex;
elseif  es=="d"
    n=800;
    B=-ones(n,7);
    v=1:n;
    B(:,1)=(12*ones(n,1)).*v';
    d=[0 10 -10 20 -20 80 -80];
    A=spdiags(B,d,n,n);
    xex=-ones(n,1);
    b=A*xex;
    clear v
elseif es=="e"
    n=8000;
    B=-ones(n,9);
    v=1:n;
    B(:,1)=(12*ones(n,1)).*v';
    d=[0 10 -10 20 -20 80 -80 2000 -2000];
    A=spdiags(B,d,n,n);
    xex=-ones(n,1);
    b=A*xex;
    clear v
end 

clear B d
tol=10^(-9);
maxit=300;
tic
[x,flag,relres,iter]=pcg(A,b,tol,maxit);
rel_er=norm(x-xex)/norm(xex);
t=toc;

P=spdiags(diag(A),0,n,n);
tic
[xp,flagp,relresp,iterp]=pcg(A,b,tol,maxit,P);
rel_er=norm(xp-xex)/norm(xex);
tp=toc;

L=chol(A,'lower');
tic
y=L\b;
x_chol=L'\y;
t_chol=toc;
clear y
