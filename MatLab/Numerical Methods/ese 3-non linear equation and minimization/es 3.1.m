clear all
close all
disp ("_______________")
 f=@(x) x.^2-x+1-exp(-x);
 
 %a
 v=-2:0.1:1;
 plot(v,f(v)) %2 zero near : -1.8 ; 0
 x0=[-1.5 0.5 -0.5];
 %b
 tol=1e-10;
 tol_res=1e-12;
 
 %options=optimoptions(options, 'OptimalityTolerance',tol_er);
 x_fsolve=fsolve(f,x0);

%c
df=@(x)2*x-1+exp(-x);
er=10;
x_new=x0;
j=0;
while er>tol
    x_new_1=x_new;
    x_new=x_new-(f(x_new)/df(x_new))
  for i=1:length(x0)
      er_1(i)=norm(x_new(i)-x_new_1(i))/norm(x_new(i));
  end 
  er=max(er_1)
  j=j+1;
end
