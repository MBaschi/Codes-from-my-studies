clear all
close all
disp("________________")

a=1;
b=4;
phi=@(x) (a-x(1))^2+b*(x(2)-x(1)^2)^2;
Vphi=@(x) [2*(x(1)-a)-4*b*x(1)*(x(2)-x(1)^2);2*b*(x(2)-x(1)^2)];


in=1;
if in==1
    x0=[0;0];
elseif in==2
    x0=[2;2];
elseif in==3
    x0=[1;3];
elseif in==4
    x0=[3;1];
end

tol=10^(-8);

%a)
options = optimset( 'TolFun', tol );
[xa,fval,exitflag,output]=fminsearch(phi,x0,options);
it_a=output.iterations;
clear fval exitflag output options

%b)
xb=x0;
it_b=0;
er_b=10;


while er_b>tol
    x_=xb;
    gam=0.1;
    m=1;
    while phi(xb-(gam/(2^m))*Vphi(xb))<-(1/2)*(gam/(2^m))norm(Vphi(xb))^2
        m=m+1;
    end 
    gam=gam/(2^m);
    xb=xb-gam*Vphi(xb);
    
    er_b=abs(phi(xb));
    it_b=it_b+1;
    if it_b>7000
        break
    end
    
end 
clear gam m

%c)
H=@(x) [2-4*b*(x(2)-3*x(1)^2) -4*b*x(1)
        -4*b*x(1) 2*b];
xc=x0;
it_c=0;
er_c=10;
while er_c>tol
    dx=-H(xc)\Vphi(xc);
    xc=xc+dx;
    er_c=phi(xc);
    it_c=it_c+1;
end

%d)

xd=x0;
it_d=0;
er_d=10;
Hk=H(xd);
gam=0.1;
while er_d>tol
    x_=xd;
    dx=-Hk\Vphi(xc);
    dk=gam*dx;
    xd=xd+dk;
    ni=Vphi(xd)-Vphi(x_);
    Hk=Hk+((ni*ni')/(ni'*dk))-((Hk*dk*dk'*Hk)/(dk'*Hk*dk));
    er_d=phi(xd);
    it_d=it_d+1;
    
    if it_d>7000
        break
    end
end

