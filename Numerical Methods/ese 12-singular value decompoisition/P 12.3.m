clear all
close all
disp("___________")

N=100;
B=diag(2*ones(N,1))+diag(-ones(N-1,1),-1)+diag(-ones(N-1,1),1);
A=expm(-5*B);
[U,S,V]=svd(A);
S_=zeros(N);
S_(1:40,1:40)=S(1:40,1:40);

A_=U*S_*V';
figure
semilogy(diag(A));
title("semilogy singular value");
figure
plot(diag(A));
title("singular value");

F_norm_2=norm(A-A_,'fro')/norm(A-A_,'fro');



