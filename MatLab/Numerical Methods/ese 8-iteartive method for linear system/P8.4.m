clear all
close all
disp("___________________")

n=1000;
A=zeros(n);
B=[10 3 4 1 1
    3 30 2 2 2
    4 2 50 3 4
    1 2 3 30 4
    1 2 4 4 10];

for i=1:5:n
    A(i:i+4,i:i+4)=B;
end 

k2=cond(A,2);
kinf=cond(A,inf);

xex=2*ones(n,1);
xex(2:2:n)=-3;

b=A*xex;

A=sparse(A);

%a)
tic
xa=A\b;
ta=toc;
%gli errori balzano

%b) 
L=chol(A,'lower');