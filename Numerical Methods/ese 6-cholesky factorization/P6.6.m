clear all
close all
disp("______________")
n=100;
B=ones(n,3);
B(1:n,1)=1;
B(1:n,2)=4;
B(1:n,3)=-1;
d=[1 0 -1];

A=spdiags(B,d,n,n);

Af=full(A);

xex=2*ones(n,1);
b=A*xex;
%lu factorization of sparse
tic;
[L,U]=lu(A);
y=L\b;
x_lu=U\y;
t_lu_sp=toc;

%backslash of sparse
tic;
x_back=A\b;
t_back_sp=toc;

%Lu of full
tic;
[Lf,Uf]=lu(Af);
yf=Lf\b;
x_f=Uf\yf;
t_lu_f=toc;
%backslash of sparse
tic;
x_back_f=Af\b;
t_back_f=toc;





