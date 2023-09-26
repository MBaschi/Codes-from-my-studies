function [xnew, it] = my_steepest_descent(x0, phi, dphi, gamma, maxit, tol, modified)
% Find minimum of function phi using the steepest descent method
% Modified = 0 uses fixed gamma, modified = 1 uses adaptive gamma

xold = x0;

if(modified)
    
    for it = 1:maxit
        
        %phi(xold)
        
        phiprime = dphi(xold);
        
        m = m_choice(phi, dphi,xold,gamma);
        gamma = (0.5^m)*gamma;
        
        xnew = xold - gamma*phiprime;
        
        %err = norm(xnew-xold)/norm(xnew);
        err = norm(phi(xnew)-phi(xold));
        % For absolute error tolerance uncomment the line below
        if err<tol
            break
        end
        xold=xnew;
    end
    if it==maxit, fprintf('Modified steepest descent method did not converge in %d iterations.\n', maxit), end

else
    
    for it = 1:maxit
        
        
        phiprime = dphi(xold);
                
        xnew = xold - gamma*phiprime;
        
        err = norm(xnew-xold)/norm(xnew);
        if err<tol
            break
        end
        xold=xnew;
    end
    if it==maxit, fprintf('Steepest descent method did not converge in %d iterations.\n', maxit), end
    
end
