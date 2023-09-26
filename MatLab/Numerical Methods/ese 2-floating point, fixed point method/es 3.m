clear all
close all
% the function x(2-ax) respect the hypotesis of the thorem of global
% convergence( derivate of modulus of phi less the one) for x that belong
% to [1/4a;3/4a]
disp("____________________")
%2
b=1.5; % 1<b<3
a=5; %a>0
x_ex=1/a;
x0=b/(4*a);
tol=10^(-9);
x_for=x0;
for i=1:30
  
   x_for=x_for*(2-a*x_for);
   er_for=norm(x_for-x_ex)/norm(x_ex);
   if er_for<tol
       break
   end    
end
x_while=x0;
er_while=10;
while er_while>tol
   x_while=x_while*(2-a*x_while);
   er_while=norm(x_while-x_ex)/norm(x_ex);
end 

