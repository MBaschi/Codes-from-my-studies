function [ x, it, t ] = quasi_newton_inv_broyden( x0, f, delta, maxit, tol )

x = x0;
tic
% Initial approximation of the jacobian by FD
n = length( x0 );
I = eye( n );
Q = zeros( n );
for i = 1 : n
    Q(:,i) = ( f( x + I(:,i)*delta ) - f( x ) ) / delta;
end
B=inv(Q);

for it = 1 : maxit    
    % Instead of computing the LU factorization, i solve directly using \
    dx = - B*f( x );
    % Stop criterium
    if norm( dx, Inf ) < tol
        break;
    end
    % The approximated inverse jacobian is updated at each iteration
    %df = f( x+dx ) - f( x );
    aleph=1/norm(dx,2);
    vv=dx*aleph;
    uu=f( x+dx )*aleph;
    B = B - ( B*uu*vv'*B) / ( 1+vv' *B*uu ) ;
    
    x = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Broyden did not converge!\n" ), end

end