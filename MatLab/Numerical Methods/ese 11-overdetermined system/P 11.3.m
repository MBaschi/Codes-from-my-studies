clear all
close all
disp("__________________")

n=20;
m=200;

b_t=ones(n,1);
A_t=diag(2*b_t)+diag(-ones(n-1,1),1)+diag(-ones(n-1,1),-1);

A=zeros(m,n);
for i=0:n:m-n
   A(i+1:i+n,1:20)=A_t;
end

b=ones(m,1);
j=0;
for i=0:n:m-n
    j=j+1;
   b(i+1:i+n)=j*b_t;
end

clear A_t b_t i j 

if rank(A)==n
    disp("the matris is full rank")
else
    disp("the matris is not full rank")
end 

%a)
xa=(A'*A)\(A'*b);

%b)
As=sparse(A);
tic
L=chol(As'*As,'lower');
y=L\(As'*b);
xb=L'\y;
tb=toc;

er_b=norm(xa-xb);
clear y L As

%c)
tic
[Q,R]=qr(A);
R_t=R(1:n,:);
Q_t=Q(:,1:n);
xc=R_t\(Q_t'*b);
tc=toc;

er_c=norm(xa-xc);

clear Q R Q_t R_t

%d)
tic
[U,S,V] = svd(A);
E=zeros(n,m);
E(1:n,1:n)=inv(S(1:n,:));
xd=V*E*U'*b;
td=toc;

er_d=norm(xa-xd);
clear U S V E 

%e)
A_inv=pinv(A);
xe=A_inv*b;

er_e=norm(xa-xe);