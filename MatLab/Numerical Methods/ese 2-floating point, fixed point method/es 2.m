clear all
close all
disp("______________")
result=zeros(21,1);
rel_er_1=zeros(21,1);
rel_er_2=zeros(21,1);

for i=1:21
    k=i-1;
    result(i)=(1+10^(-k))-1;
    rel_er_1(i)=abs(((1+10^(-k))-1)-10^(-k))/10^(-k);
    rel_er_2(i)=abs(1+10^(-k)-10^(-k)-1)/10^(-k);
end
  x=0:20;
  semilogy(x,rel_er_1)
  hold on
  semilogy(x,rel_er_2)