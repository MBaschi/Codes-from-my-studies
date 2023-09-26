% Script to compute solution of equation x=x*(2-ax) using 
% the fixed point method

clear all
close all
format long

a = 0.25;
x0 = 2;
tol = 1e-6;

if (abs(1-a*x0)>1/2) 
   disp('Chosen x0, a such that abs(1-a*x)>1/2, may not converge.')
   %return 
end


xnew = x0;
xold = x0+1;
err  = tol + 1;
nit  = 0;

while err > tol
    xnew = xold * ( 2 - a*xold );
    err = abs( xnew - xold ) / xnew ;
    nit = nit + 1;
    xold = xnew;
end

% for nit = 1:maxit
%     xnew = xold * ( 2 - a*xold );
%     err = abs( xnew - xold ) / xnew ;
%     if err < tol
%         break
%     end
%     xold = xnew;
% end

