clear all
close all

z=@(x)(x(1)^2)/10+(x(2)^2)/5-1;
A=[0 0 1
   0 0.1 1
   0.1 0 1
   0.1 0.1 1
   0 0.2 1
   0.1 0.2 1
   0.2 0.2 1
   0.2 0.1 1
   0.2 0 1];
[m,n]=size(A);
b=ones(m,1);;
for i=1:m
    b(i)=z(A(i,1:2));
end

if rank(A)==n
    disp('full rank matrix')
 
else
    disp('not full rank matrix')
    return;
end
clear i
%(a)
x_a=(A'*A)\(A'*b);

%(b)
L=chol(A'*A);
y=L'\(A'*b);
x_b=L\y;
re_b_2=norm(x_b-x_a)/norm(x_a);
re_b_inf=norm(x_b-x_a,'inf')/norm(x_a,'inf');
clear L y

%(c)
[Q,R]=qr(A);
R_t=R(1:n,:);
Q_t=Q(:,1:n);

x_c=R_t\(Q_t'*b);
re_c_2=norm(x_c-x_a)/norm(x_a);
re_c_inf=norm(x_c-x_a,'inf')/norm(x_a,'inf');
clear Q R R_t Q_t
%(d)
[U,S,V] = svd(A);
E=zeros(n,m);
E(:,1:n)=inv(S(1:3,:));
x_d=V*E*U'*b;
re_d_2=norm(x_d-x_a)/norm(x_a);
re_d_inf=norm(x_d-x_a,'inf')/norm(x_a,'inf');
clear U V 
%(e)
A_pinv=pinv(A);
x_e=A_pinv*b;
re_e_2=norm(x_e-x_a)/norm(x_a);
re_e_inf=norm(x_e-x_a,'inf')/norm(x_a,'inf');
clear A_pinv

clear   n m 

[X,Y]=meshgrid(-.5:.01:.5);
Z=(X.^2)/10+(Y.^2)/5-1;
Z_plane=x_a(1).*X+x_a(2).*Y+x_a(3);
mesh(X,Y,Z)
hold
mesh (X,Y,Z_plane)