clear all 
close all
disp("____________________")
f=@(x)x.^4-x.^3-7*x.^2+x+6;
g=@(x)x.^4-3*x.^3-3*x.^2+11*x-6;
%a)
v=-3:0.1:4;
%plot(v,f(v)); %dal grafico si osservano 4 zeri vicini a -2 -1 1 3
%plot(v,g(v));
%yline(0,'k');
x0_f=[-2.5 -1.5 1.5 3.5];
x0_g=[-2.5 1.1 3.5];

%b)
df=@(x)4*x.^3-3*x.^2-14*x+1;
tol=10^(-10);

for i=1:length(x0_f)
    [x_f(i),er_f(i),iteration_f(i)]=Newton(x0_f(i),f,df,tol);
end
%c)
dg=@(x)4*x.^3-9*x.^2-6*x+11;
for i=1:length(x0_g)
    [x_g(i),er_g(i),iteration_g(i)]=Newton(x0_g(i),g,dg,tol);
end
%d) 
for i=1:length(x0_f)
    xf_fsolve(i)=fsolve(f,x0_f(i));
end

for i=1:length(x0_g)
    xg_fsolve(i)=fsolve(g,x0_g(i));
end
 %30 min
