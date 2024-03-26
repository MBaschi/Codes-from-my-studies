clear all 
close all
disp("_____________")
v=2*ones(100,1);
v(2:2:100)=4;
%a)
A=diag(v);
A=A+diag(ones(99,1),-1)+diag(-ones(99,1),1);
%b)
B=(-3*A+2*A^2)/(eye(100)+4*A-A^4);
%c)
if det(B)~=0
    B_inv=inv(B);
else
    disp("B not invertible");
end 
%d)
d=B*(-ones(100,1));
%e)
x_inv=B_inv*d;
x_1=B^(-1)*d;
x_back=B\d;