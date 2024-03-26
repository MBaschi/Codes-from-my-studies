% Script to compute solution of equation x=0.5*(x+a/x) using 
% the fixed point method

clear all
close all
format long

a = 0.25;
x0 = 1.5;
tol = 1e-6;

if (abs(1-a/x0^2)>2) 
   disp('Chosen x0, a such that abs(1-a/x0^2)>1/2, may not converge.')
   %return 
end


xnew = x0;
xold = x0 + 1;
err  = tol + 1;
nit  = 0;

while err > tol
    xnew = 0.5 * ( xold + a/xold );
    err  = abs( xnew - xold ) / xnew ;
    nit  = nit + 1;
    xold = xnew; 
end
