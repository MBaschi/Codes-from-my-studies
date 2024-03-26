function [ x, it, t ] = newton_constant_jacobian( x0, f, j, maxit, tol )

x = x0;

tic
j_const = j( x0 );
[L,U,P] = lu( j_const);
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

if it == maxit, fprintf( "Constant Jacobian did not converge!\n" ), end

end