clear all
close all
disp("______________")

PD=ones(20,1);
pivoting=ones(20,1);


abs_er_2=ones(20,1);
rel_er_2=ones(20,1);
abs_er_inf=ones(20,1);
rel_er_inf=ones(20,1);

priori=ones(20,1);
posteriori=ones(20,1);

for n=1:20
H=hilb(n);
 %a) 
   if eigs(H)>0
     PD(n)=1;
   else 
     PD(n)=0;
   end 
   
  %b)
   xex=ones(n,1);
   b=H*xex;
    [L,U,P]=lu(H);
    if isequal(P,eye(n))
     pivoting(n)=0;
   else 
     pivoting(n)=1;
    end 
   
    y=L\b;
    x=U\y;
    
    %c)
    abs_er_2(n)=norm(xex-x);
    abs_er_inf(n)=norm(xex-x,inf);
    rel_er_2(n)=norm(xex-x)/norm(xex);
    rel_er_inf(n)=norm(xex-x,inf)/norm(xex,inf);
    
    %d)
    bt=H*x;
    e=b-bt;
    k=cond(H);
    priori(n)=k*(norm(e)/norm(b));
    
    posteriori(n)=k*(norm(xex-x)/norm(b));
    
    
end 
 n=1:20;
figure
semilogy(n, priori)
title("a priori error")

figure
semilogy(n, posteriori)
title("a posteriori error")