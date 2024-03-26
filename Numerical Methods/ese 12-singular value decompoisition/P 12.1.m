clear all
close all
disp("_______________")

format long

n = 400;
v = ones( n,1 );
f = @(x) v' * x;

sigma = 0.01;

M = eye( n );
A = zeros( 2*n-1, n );
b = zeros( 2*n-1, 1 );
for i = 1 : n
    e = M(:,i);
    b(i) = f(e) + sigma * randn(1);
    A(i,:) = e';
end

M(n,:) = 1;
for i = 1 : n-1
    e = M(:,i);
    b(n+i) = f(e) + sigma * randn(1);
    A(n+i,:) = e';
end


%a)

L=chol(A'*A,'lower');
y=L\(A'*b);
xa=L'\y;
clear y
er_2a=norm(xa-v)/norm(v);
er_infa=norm(xa-v,inf)/norm(v, inf);

%b)
[U,S,V] = svd(A);
E=zeros(n,2*n-1);
E(1:n,1:n)=inv(S(1:n,1:n));
xb=V*E*U'*b;
er_2b=norm(xb-v)/norm(v);
er_infb=norm(xb-v,inf)/norm(v, inf);