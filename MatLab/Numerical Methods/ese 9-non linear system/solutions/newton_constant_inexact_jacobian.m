function [ x, it, t ] = newton_constant_inexact_jacobian( x0, f, delta, maxit, tol )

x = x0;

tic
n = length( x0 );
j_inexact = zeros( n );
I = eye( n );

for i = 1 : n
    j_inexact(:,i) = ( f( x0 + I(:,i)*delta ) - f( x0 ) ) / delta;
end
[L,U,P] = lu( j_inexact );

for it = 1 : maxit
    y = - L \ ( P * f( x ) );
    dx = U \ y;
    % Stop criterium
    if norm( dx, Inf ) < tol
        break;
    end
    x = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Constant Inexact Jacobian did not converge!\n" ), end

end