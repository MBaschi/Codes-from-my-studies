clear all
close all
disp("______________")
v=[1 1.1 1.2 1.3 1.4 1.5 100]';
A=vander(v);
xex=[1 -1 1 -1 1 -1 1]';
b=A*xex;

%a) 
[L,U,P]=lu(A);
y=L\(P*b);
x=U\y;

clear U L y P

%b)
abs_2=norm(xex-x);
abs_inf=norm(xex-x,inf);
rel_2=norm(xex-x)/norm(xex);
rel_inf=norm(xex-x,inf)/norm(xex,inf);

%c)
posteriori=cond(A)*(norm(xex-x)/norm(b));
priori=cond(A)*eps;

%d)
P=diag((A(:,1)).^(-1));

%e)
x2=(P*A)\(P*b);

abs_2_2=norm(xex-x2);
abs_inf_2=norm(xex-x2,inf);
rel_2_2=norm(xex-x2)/norm(xex);
rel_inf_2=norm(xex-x2,inf)/norm(xex,inf);

posteriori2=cond(A)*(norm(xex-x2)/norm(b));
priori2=cond(A)*eps;

