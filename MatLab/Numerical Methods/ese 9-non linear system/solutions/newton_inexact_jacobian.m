function [ x, it, t ] = newton_inexact_jacobian( x0, f, delta, maxit, tol )

x = x0;
tic
n = length( x0 );
j_inexact = zeros( n );
I = eye( n );

 
for it = 1 : maxit
    % The jacobian is updated at each iteration
    for i = 1 : n
        j_inexact(:,i) = ( f( x + I(:,i)*delta ) - f( x ) ) / delta;
    end
    
    % Instead of computing the LU factorization, i solve directly using \
    dx = - j_inexact \ f( x );
    
    % Stop criterium
    if norm( dx, Inf ) < tol
        break;
    end
    
    x = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Inexact Jacobian did not converge!\n" ), end

end