function [ x, it ] = my_newton( x0, f, j, maxit, tol )

x = x0;

for it = 1 : maxit
    
    dx = - j(x)\f(x);
    % Stopping criterion
    %if norm( dx, Inf )/norm( x, Inf ) < tol
    if norm( f(x+dx)- f(x), Inf ) < tol
        break;
    end
    x = x + dx;    
end

if it == maxit, fprintf( "Exact Jacobian did not converge!\n" ), end

end