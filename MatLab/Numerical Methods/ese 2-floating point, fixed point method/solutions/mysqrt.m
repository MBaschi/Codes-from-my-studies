function a_out = mysqrt(a, x0, tol)
% Function computing square root using fixed point method
%
% Developed by T. Benacchio, 21/09/2020

% Input parameters:
%
% a: real, parameter
% x0: real, initial guess for fixed point algorithm
% tol: real, tolerance on fixed point algorithm error
%
% Output parameters:
% 
% a_out: real, square root of a 
%
if (abs(1-a*x0^2)>2/3) 
   disp('Chosen x0, a such that abs(1-a*x0^2)>2/3, may not converge.')
   %return 
end

xold = x0; 
err = tol + 1;
nit = 0;

while err > tol
    xnew = 0.5 * xold * ( 3 - a * xold^2 );
    err  = abs( xnew - xold ) / abs(xnew);
    nit  = nit + 1;
    xold = xnew;
end

a_out=1/xnew;


end