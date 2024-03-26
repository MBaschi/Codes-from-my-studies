function [x,er,iteration] = step_descent(x0,df,tol,y)
er=10;
x=x0;
iteration=0;
while er>tol
    iteration=iteration+1;
    x1=x;
    x=x-y*df(x);
    er=norm(x-x1)/norm(x);  
    if iteration>200
        disp("stepest descent didn't converge");
      return
    end 
end 
end

