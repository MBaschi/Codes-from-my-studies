clear all
close all
disp("____________")

%2)
A=[10 2 3 4 5
    2 10 2 3 4
    3 2 10 2 3 
    4 3 2 10 2 
    5 4 3 2 10];

L=tril(A);
U=triu(A);

xex=ones(5,1);

bl=L*xex;
bu=U*xex;

xfwsub=fwsub(L,bl);
xbksub=bksub(U,bu);

%40 min