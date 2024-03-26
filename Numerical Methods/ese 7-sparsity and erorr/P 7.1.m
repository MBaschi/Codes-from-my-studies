clear all
close all
disp("______________")
n=100;

B=ones(n,2);
B(1:n,1)=10;
B(1:n,2)=-1;
d=[ 0 n/2];

A=spdiags(B,d,n,n);


A(1:n,1)=1; %prima riga tutti uno
A(1:n,n)=1; %ultima riga tutti 1
A(1,1:n)=1; %prima colonna tutti 1
A(n,1:n)=1; % ultima colonna tutti 1

A(1,1)=10; %rimetto gli elementi sulla diagonale uguali a 10 
A(n,n)=10;

Af=full(A);

%a)
%spy(A)

%b)
p=colamd(A);
I=speye(n);
P=I(p,:);

%c)
b=ones(n,1);
b(2:2:n)=-1;
A_=A*P';
[L,U,P]=lu(A_);
figure
spy(L)
title("L with permutation")

[L_,U_]=lu(A);
figure
spy(L_)
title("L with no permutation")

tic
y=L\b;
xp=(U*P)\y;
t_per=toc

tic
y=L_\b;
xnp=U_\y;
t_np=toc;

disp("---------------");