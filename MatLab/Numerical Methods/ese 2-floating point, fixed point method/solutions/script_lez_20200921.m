% Script lecture 210920

clear all
close all
format long

%% Exercise 1
a        = zeros(21,1);
abs_err1 = zeros(21,1);
for k = 0:20   
    h=10^(-k);
    a(k+1,1) = (exp(h)-1)/h;
    abs_err1(k+1,1) = abs(a(k+1,1) - 1);
end

figure(1)
semilogy(0:20, abs_err1, 'LineWidth', 3)
xlabel('k')
ylabel('Absolute error')

%% Exercise 2
rel_err21=zeros(21,1);
rel_err22=zeros(21,1);

for k = 0:20
    a(k+1) = ( 1 + 10^(-k) - 1 );
    rel_err21(k+1,1) = abs( ( (1+10^(-k)) -1 ) - 10^(-k) ) / 10^(-k);
    rel_err22(k+1,1) = abs( 1 + 10^(-k) - 10^(-k) -1 ) / 10^(-k);
end

figure(2)
semilogy(0:20, rel_err21)
xlabel('k')
ylabel('Relative error')
rel_err23=zeros(21,1);
rel_err24=zeros(21,1);

for k = 0:20
    for m = 1:10
        a(k+1,m) = ( 10^(m) + 10^(-k) - 10^(m) );
        rel_err23(k+1,m) = abs( ( (10^(m)+10^(-k) ) -10^(m) ) - 10^(-k) ) / 10^(-k);
        rel_err24(k+1,m) = abs( 10^(m) + 10^(-k) -10^(-k) - 10^(m) ) / 10^(-k);
    end
end

figure(3)
semilogy(0:20, rel_err23(:,10))
xlabel('k')
ylabel('Relative error')


%% Exercise 3

%Script fixed_point1

%% Exercise 4

%Script fixed_point2

%% Exercise 5
%See function mysqrt

a_sqrt=mysqrt(.4,1,.00001);


a_sqrt_check=sqrt(.4);

a_sqrt
a_sqrt_check
