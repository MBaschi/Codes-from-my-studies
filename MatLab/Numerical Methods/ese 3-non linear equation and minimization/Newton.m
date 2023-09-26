function [x,er,iteration] = Newton(x0,f,df,tol)

x=x0;
iteration=0;
er=10;
    while er>tol
        iteration=iteration+1;
        x1=x;
        x=x-(f(x)/df(x));
        er=norm(x-x1)/norm(x);
    end 

end

