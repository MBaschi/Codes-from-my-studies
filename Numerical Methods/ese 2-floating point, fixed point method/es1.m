clear all 
close all
f=@(h)(exp(h)-1)/h;
x_ex=1;
%1
k=0:1:20;
h=10.^(-k);
result=ones(length(h),1);
for i=1:length(h)
   result(i)=f(h(i));
end

%2
abs_er=ones(length(result),1);
for i=1:length(result)
   abs_er(i)=norm(result(i)-x_ex);
end

semilogy(k,abs_er')

%3 
%if h is to big we dont' have a good approzimation while if it's too small
%or near the machine eps(=e-16) we get wrong reult
%10 min 32 sec