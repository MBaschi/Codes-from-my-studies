function [ x, it, t ] = my_newton( x0, f, j, maxit, tol )

x = x0;

tic
for it = 1 : maxit
    dx = - j(x) \ f(x);
    % Stop criterium
    if norm( dx./x, Inf ) < tol
        break;
    end
    x = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Exact Jacobian did not converge!\n" ), end

end