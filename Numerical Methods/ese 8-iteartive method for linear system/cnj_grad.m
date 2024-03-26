function [x,er,iteration] = cnj_grad(A,b,x0,tol,maxit)
 r=b-A*x0;
 p=r;
 x=x0;
 er=10;
 iteration=0;
 while er>tol
     
     if iteration>maxit
         break
     end 
     r_=r;
     x_=x;
     
     a=(r'*r)/(r'*A*r);
     x=x+a*p;
     r=r-a*A*p;
     beta=(r'*r)/(r_'*r_);
     p=r+beta*p;
     
     er=norm(x-x_);
     iteration=iteration+1;
 end 
 
end

