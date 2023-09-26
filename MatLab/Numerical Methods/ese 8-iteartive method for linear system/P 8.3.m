clear all
close all
disp("___________________")

es="a";

if es=="a"
    n=800;
    B=-ones(n,8);
    B(:,1)=12*ones(n,1);
    B(:,8)=ones(n,1);
    d=[0 10 -10 20 -20 80 -80 400];
    A=spdiags(B,d,n,n);
    xex=-ones(n,1);
    b=A*xex;
elseif  es=="d"
    n=800;
    B=-ones(n,8);
    v=1:n;
    B(:,1)=(12*ones(n,1)).*v';
    B(:,8)=ones(n,1);
    d=[0 10 -10 20 -20 80 -80 400];
    A=spdiags(B,d,n,n);
    xex=-ones(n,1);
    b=A*xex;
    clear v
elseif es=="e"
    n=8000;
    B=-ones(n,10);
    v=1:n;
    B(:,1)=(12*ones(n,1)).*v';
    B(:,10)=ones(n,1);
    d=[0 10 -10 20 -20 80 -80 2000 -2000 4000];
    A=spdiags(B,d,n,n);
    xex=-ones(n,1);
    b=A*xex;
    clear v
end 

clear B d
tol=10^(-9);
maxit=300;
tic
[x,flag,relres,iter]=gmres(A,b,maxit,tol,maxit);
rel_er=norm(x-xex)/norm(xex);
t=toc;

P=spdiags(diag(A),0,n,n);
tic
[xp,flagp,relresp,iterp]=gmres(A,b,maxit,tol,maxit,P);
rel_er=norm(xp-xex)/norm(xex);
tp=toc;

[L,U,P]=lu(A);
tic
y=L\(P*b);
x_chol=U\y;
t_chol=toc;
clear y
