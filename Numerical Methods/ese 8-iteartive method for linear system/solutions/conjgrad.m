function [x,flag,iter,rr_vec]=conjgrad(A,b,x,P,nmax,tol)
% CONJGRAD conjugate gradient method
% [X,ITER,RR_VEC]=CONJGRAD(A,B,X0,P,NMAX,TOL) 
% solves the system A*X=B with the conjugate gradient method. TOL specifies
% the tolerance for the method. NMAX is the maximum number of iterations.
% X0 is the initial vector. P is the preconditioner. RR_VEC contains the history
% of the residual norm. ITER is the iteration at which the solution is computed.
% FLAG is an integer, 1 if the method has not converged, 0 otherwise.
flag=0; iter=0; bnrm2=norm(b);
if bnrm2==0, bnrm2=1; end
r=b-A*x; relres=norm(r)/bnrm2;
if relres<tol, return, end
for iter=1:nmax
    z=P\r; rho=z'*r;
    if iter>1
        beta=rho/rho1;
        p=z+beta*p;
    else
        p=z;
    end
    q=A*p;
    alpha=rho/(p'*q);
    x=x+alpha*p;
    r=r-alpha*q;
    relres=norm(r)/bnrm2;
    rr_vec(iter,1)=relres;
    if relres<=tol,break,end
    rho1=rho;    
end
if relres>tol
    flag=1;
else
    flag=0;
end
return