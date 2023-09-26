function [ x, it, t ] = newton_exact_jacobian( x0, f, j, maxit, tol )

x = x0;

tic
for it = 1 : maxit
    dx = - j(x) \ f(x);
    % Stop criterium
    if norm( dx, Inf ) < tol
        break;
    end
    x = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Exact Jacobian did not converge!\n" ), end

end