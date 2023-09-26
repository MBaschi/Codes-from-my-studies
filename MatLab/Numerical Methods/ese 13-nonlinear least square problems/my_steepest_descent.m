function [xnew, it] = my_steepest_descent(x0, phi, dphi, maxit, tol, modif)
% Find minimum of function phi using the steepest descent method

xold = x0;

for it = 1:maxit
    
    phiprime = dphi(xold);
    
    if(modif)
        gamma=1;
        m = m_choice(phi, dphi, xold, gamma)
        gamma = (0.5^m)*gamma;
    else
        gamma=0.001;
    end
    
    xnew = xold - gamma*phiprime;
    err = norm(xnew-xold,2)/norm(xnew,2);
    if err<tol
        break
    end
    xold=xnew;
end

if it==maxit, fprintf('Steepest descent method did not converge in %d iterations.\n', maxit), end

