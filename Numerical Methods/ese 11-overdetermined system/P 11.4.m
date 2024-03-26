clear all
close all
disp("_______________")
N=300;
A_t=diag(4*ones(N,1))+diag(-ones(N-1,1),1)+diag(-ones(N-1,1),-1);
A_t(1,N)=-1/2;
A_t(N,1)=-1/2;

A=zeros(10*N,N);
for i=0:N:10*N-N
    A(i+1:i+N,:)=A_t;
end 

b_t=ones(N,1);
j=0;
b=ones(10*N,1);
for i=0:N:10*N-N
    j=j+1;
    b(i+1:i+N,:)=j*b_t;
end 
clear i j
if rank(A)==N
    full=1;
else
    full=0;
end 

%a)
xa=A\b;
%b)
tic
[Q R]=qr(A);
R_t=R(1:N,:);
Q_t=Q(:,1:N);
xb=R_t\(Q_t'*b);
ta=toc;

er_b=norm(xa-xb);

clear Q R Q_t R_t

%c)
tic
As=sparse(A);
L=chol(As'*As,'lower');
y=L\(As'*b);
xc=L'\y;
tc=toc;

er_c=norm(xa-xc);
clear L y

%d)
tol=norm(As'*As*xc-As'*b);
xd = pcg(As'*As,As'*b,tol,1000);

%e)
[U,S,V] = svd(A);
E=zeros(N,10*N);
E(1:N,1:N)=inv(S(1:N,:));
xe=V*E*U'*b;


