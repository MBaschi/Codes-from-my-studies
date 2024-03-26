clear all
close all
disp("_______________")

N=50;
v=ones(N+1,1);

for i=1:N
    v(i)=(i-1)/N;
end 
A=vander(v);
xex=ones(N+1,1);
b=A*xex;
%a) 
[L,U,P]=lu(A);
y=L\(P*b);
xa=U\y;
er_2= cond(A)*eps;
er_inf= cond(A,inf)*eps;