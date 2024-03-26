clear all
close all

n=10

A=diag(5*ones(n,1));
A=A+diag(-1*ones(n-1,1),1)+diag(-1*ones(n-1,1),-1);
f=@(x)-2sin(x)+pi;