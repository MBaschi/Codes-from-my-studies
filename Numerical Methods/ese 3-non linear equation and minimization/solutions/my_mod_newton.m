function [ x, it, t ] = my_mod_newton( x0, f, inc, maxit, tol )

x = x0;

tic
for it = 1 : maxit
    dx = - inc * f(x) / ( f(x + inc) - f(x) );
    % Stop criterium
    if norm( dx/x, Inf ) < tol
        break;
    end
    x = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Modified Newton did not converge!\n" ), end

end