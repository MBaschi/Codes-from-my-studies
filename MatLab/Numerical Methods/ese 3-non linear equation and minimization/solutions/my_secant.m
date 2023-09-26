function [ x, it, t ] = my_secant( x0, x1, f, maxit, tol )

x_old = x0;
x     = x1;

tic

for it = 1 : maxit
    dx = - (x-x_old) * f(x) / (f(x) - f(x_old));
    % Stop criterium
    if norm( dx, Inf ) < tol
        break;
    end
    x_old = x;
    x     = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Secant method did not converge!\n" ), end

end