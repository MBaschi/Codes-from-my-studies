clear all 
close all

k=20;

A_t=2*diag(ones(k,1))-1*diag(ones(k-1,1),1)-1*diag(ones(k-1,1),-1);
b_t=ones(k,1);

A=zeros(200,20);
for i=1:20:199
    A(i:i+19,:)=A_t;
end
b=ones(200,1);
j=1;
for i=1:20:199
    b(i:i+19)=j*b_t;
    j=j+1;
end

[m,n]=size(A);

if rank(A)==n
    disp('full matrix')
 
else
    disp('not full matrix')
end
clear i
%(a)
tic
x_a=(A'*A)\(A'*b);
t_a=toc;
%(b)
tic
L=chol(A'*A);
L=sparse(L);
y=L'\(A'*b);
x_b=L\y;
re_b_2=norm(x_b-x_a)/norm(x_a);
re_b_inf=norm(x_b-x_a,'inf')/norm(x_a,'inf');
t_b=toc;
clear L y

%(c)
tic
[Q,R]=qr(A);
R_t=R(1:n,:);
Q_t=Q(:,1:n);

x_c=R_t\(Q_t'*b);
re_c_2=norm(x_c-x_a)/norm(x_a);
re_c_inf=norm(x_c-x_a,'inf')/norm(x_a,'inf');
t_c=toc;
clear Q R R_t Q_t
%(d)
tic
[U,S,V] = svd(A);
E=zeros(n,m);
E(:,1:n)=inv(S(1:n,:));
x_d=V*E*U'*b;
re_d_2=norm(x_d-x_a)/norm(x_a);
re_d_inf=norm(x_d-x_a,'inf')/norm(x_a,'inf');
t_d=toc;
clear U S V E
%(e)
tic
A_pinv=pinv(A);
x_e=A_pinv*b;
re_e_2=norm(x_e-x_a)/norm(x_a);
re_e_inf=norm(x_e-x_a,'inf')/norm(x_a,'inf');
t_e=toc;
clear A_pinv

