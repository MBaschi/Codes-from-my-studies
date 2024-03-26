clear all
close all
N=10;
v=ones(N,1);
f=@(y)v'*y;
ei=eye(N);
sigma=0.01;


b=ones(2*N-1,1);

for i=1:N
    b(i)=f(ei(:,i))+sigma*randn(1,1);
end
for i=N+1:2*N-1
    b(i)=f(ei(:,i-N)+ei(:,N))+sigma*randn(1,1);
end

A=ones(2*N-1,N);
A(1:N,1:N)=ei;
M=zeros(N-1,N-1);
M(N-1,:)=1;
A(N+1:2*N-1,N+1:2*N-1)=ei+M;
clear M
