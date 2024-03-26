clear all
close all
disp("______________________")

f=@(x) (x(1).^2)/10+(x(2).^2)/5-1;
A=[0 0 1
   0 0.1 1
   0.1 0 1
   0.1 0.1 1
   0 0.2 1
   0.1 0.2 1
   0.2 0.2 1
   0.2 0.1 1
   0.2 0 1];
b=ones(size(A,1),1);
for i=1:size(A,1)
    b(i)=f(A(i,1:2));
end 
clear i
if rank(A)==3
    disp('full rank')
else
   disp('not full rank')
end 

%a)
Ca=(A'*A)\(A'*b);

%b)
L=chol(A'*A,'lower');
y=L\(A'*b);
Cb=L'\y;
clear L y

%c)
[Q,R]=qr(A);
[Q0,R0]=qr(A,0);
Cc=R\(Q'*b);
xc0 = R0 \ ( Q0' * b );
clear Q R R_t Q_t

%d)
[U,S,V]=svd(A);
E=zeros(3,9);
E(:,1:3)=inv(S(1:3,:));

Cd=V*E*U'*b;

%e)
A_inv=pinv(A);
Ce=A_inv*b;