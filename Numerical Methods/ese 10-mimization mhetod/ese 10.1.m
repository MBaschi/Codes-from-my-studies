close all
clear all

a=1;
b=4;
gam=0.1;
tol=10^(-8);
phi=@(x)(a-x(1))^2+b*(x(2)-x(1)^2)^2; 


options=optimset('Tolfun',tol);
x0_1=[0;0];
x0_2=[2;2];
x0_3=[1;3];
x0_4=[3;1];

x0=[x0_1 x0_2 x0_3 x0_4];

%(a)
x_a=x0;

for i=1:4
[x_a(:,i),FVAL,EXITFLAG,output(i)]=fminsearch(phi,x0(:,i),options);
end
iteration_a=output.iterations;
 
%(b)
x_b=x0;
Vphi=@(x)[2*(x(1)-a)-4*b*x(1)*(x(2)-(x(1))^2)
          2*b*(x(2)-(x(1))^2)];
iteration_b=zeros(4,1);
for i=1:4
 gam_k=gam;
 er=1;
   while (er>tol)
    prec=x_b(:,i);
   
    m=1;
    while(phi(x_b(:,i)-(gam/(2^m))*Vphi(x_b(:,i)))-phi(x_b(:,i))> -(1/2)*(gam/(2^m))*norm(Vphi(x_b(:,i)))^2);
      m=m+1;
      if(m==10)
        m=11;
      end
    end
    
    gam_k=gam/(2^m);
    x_b(:,i)=x_b(:,i)-gam_k*Vphi(x_b(:,i));  
    
    er=norm(phi(x_b(:,i))-phi(prec));
    
    iteration_b(i)=iteration_b(i)+1;
    end
end

%(c)
x_c=x0;
H=@(x)[2-4*b*(x(2)-3*(x(1))^2) -4*b*x(1)
       -4*b*x(1) 2+b];
 iteration_c=zeros(4,1);
for i=1:4
  delta=0;
  er=1;
  while (er>tol)
     
     prec=x_c(:,i);
     delta=-(H(x_c(:,i)))\Vphi(x_c(:,i));
     x_c(:,i)=x_c(:,i)+delta;
     er=norm(phi(x_c(:,i))-phi(prec))/norm(phi(prec));
     iteration_c(i)=iteration_c(i)+1;
     if iteration_c(i)==10000
         break;
     end
  end
end

%(d)