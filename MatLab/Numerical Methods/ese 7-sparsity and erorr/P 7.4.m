clear all
close all
disp("________________");

n=20;
I=eye(n);
A=10^(-8)*I+hilb(n);
xex=ones(n);
b=A*xex;
apriori=10^(-2);
k=cond(A);
c=(apriori/k)*norm(b);
o=(c/norm(rand(n,1)))^(1/2);



