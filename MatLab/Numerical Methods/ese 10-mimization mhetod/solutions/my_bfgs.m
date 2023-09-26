function [ x, it ] = my_bfgs( x0, phi, dphi, h, maxit, tol, gamma )

x = x0;

h_app = h(x);

for it = 1 : maxit
    
    dx = - h_app\dphi(x);
    
    gammap = gamma+0.01;
    gammam = gamma;
    while phi(x+gammap*dx) < phi(x+gammam*dx)
        gammam = gammap;
        gammap = gammap+0.01;
    end
    
    delta = gammam*dx;
    
    xnew = x + delta;
    nu = dphi(xnew) - dphi(x);
    
    h_app = h_app + nu*nu'/(nu'*delta) - h_app*delta*delta'*h_app/(delta'*h_app*delta);
        
    % Stopping criterion
    %if norm( delta, Inf )/norm( x, Inf ) < tol
    if norm( phi(xnew) - phi(x) ) < tol
        break;
    end
    x = xnew;
        
end

if it == maxit, fprintf( "BFGS did not converge!\n" ), end

end