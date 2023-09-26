function [ x, it, t ] = fixed_point( x0, A, g, maxit, tol )

x = x0;

tic
for it = 1 : maxit
    xn = A\g(x);
    
    % Stop criterium
    if norm( xn-x, Inf ) < tol
        break;
    end
    
    x = xn;    
end
t = toc;

if it == maxit, fprintf( "Fixed Point did not converge!\n" ), end

end