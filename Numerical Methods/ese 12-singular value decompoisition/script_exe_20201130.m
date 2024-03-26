%% Exercise 1
clear all
close all
format long

n = 400;
v = ones( n,1 );
f = @(x) v' * x;

sigma = 0.01;

M = eye( n );
A = zeros( 2*n-1, n );
b = zeros( 2*n-1, 1 );
for i = 1 : n
    e = M(:,i);
    b(i) = f(e) + sigma * randn(1);
    A(i,:) = e';
end

M(n,:) = 1;
for i = 1 : n-1
    e = M(:,i);
    b(n+i) = f(e) + sigma * randn(1);
    A(n+i,:) = e';
end

% Check that the associated normal equations have a unique solution.
if rank( A ) == min( size( A ) )
    fprintf( "A is full rank.\n" )
else
    fprintf( "A is not full rank (rank=%d).\n", rank( A ) )
end
    
% (a) Solve the system by solving the normal equations using Cholesky
A_n = A' * A;
b_n = A' * b;
fprintf( "The condition number of A' * A is %f\n", cond(A' * A) )
L = chol( A_n, 'lower' );
ya = L \ ( b_n );
xa = L' \ ya;

% (b) Solve the system by using the SVD decomposition
[ U,S,V ] = svd( A, 0 );
IS = S';
for i = 1 : n
    IS(i,i) = 1 / S(i,i);
end
xb = V * inv(S) * U' * b;
% Compare the numerical solutions with the reference solution xex = v
xex = v;
err2_a = norm( xa - xex ) / norm( xex );
err2_b = norm( xb - xex ) / norm( xex );
erri_a = norm( xa - xex, Inf ) / norm( xex, Inf );
erri_b = norm( xb - xex, Inf ) / norm( xex, Inf );

fprintf( "\nRelative error (L2):" )
fprintf( "\nNormal equations + Cholesky: %1.15e", err2_a )
fprintf( "\nSVD decomposition:           %1.15e\n", err2_b )

fprintf( "\nRelative error (Linf):" )
fprintf( "\nNormal equations + Cholesky: %1.15e", erri_a )
fprintf( "\nSVD decomposition:           %1.15e\n", erri_b )

%% Exercise 1
%  Repeat the computation for sigma = 2 and discuss the differences.
%  Get the same errors for Cholesky and SVD

clear all
close all
format long
n = 400;
v = ones( n,1 );
f = @(x) v' * x;

sigma = 2;

M = eye( n );
A = zeros( 2*n-1, n );
b = zeros( 2*n-1, 1 );
for i = 1 : n
    e = M(:,i);
    b(i) = f(e) + sigma * randn(1);
    A(i,:) = e';
end

M(n,:) = 1;
for i = 1 : n-1
    e = M(:,i);
    b(n+i) = f(e) + sigma * randn(1);
    A(n+i,:) = e';
end

% Check that the associated normal equations have a unique solution.
if rank( A ) == min( size( A ) )
    fprintf( "A is full rank.\n" )
else
    fprintf( "A is not full rank (rank=%d).\n", rank( A ) )
end

% (a) Solve the system by solving the normal equations using Cholesky
A_n = A' * A;
b_n = A' * b;
fprintf( "The condition number of A' * A is %f\n", cond(A' * A) )
L = chol( A_n, 'lower' );
ya = L \ ( b_n );
xa = L' \ ya;

% (b) Solve the system by using the SVD decomposition
[ U,S,V ] = svd( A );
IS = S';
for i = 1 : n
    IS(i,i) = 1 / S(i,i);
end
xb = V * IS * U' * b;

% Compare the numerical solutions with the reference solution xex = v
xex = v;
err2_a = norm( xa - xex ) / norm( xex );
err2_b = norm( xb - xex ) / norm( xex );
erri_a = norm( xa - xex, Inf ) / norm( xex, Inf );
erri_b = norm( xb - xex, Inf ) / norm( xex, Inf );

fprintf( "\nRelative error (L2):" )
fprintf( "\nNormal equations + Cholesky: %1.15e", err2_a )
fprintf( "\nSVD decomposition:           %1.15e\n", err2_b )

fprintf( "\nRelative error (Linf):" )
fprintf( "\nNormal equations + Cholesky: %1.15e", erri_a )
fprintf( "\nSVD decomposition:           %1.15e\n", erri_b )

%% Exercise 2
%  Underdetermined system
clear all
close all
format long
n = 400;
v = ones( n,1 );
f = @(x) v' * x;

sigma = 0.01;

M = eye( n );
A = zeros( n/2, n );
b = zeros( n/2, 1 );
for i = 1 : n/2
    e = M(:,i);
    b(i) = f(e) + sigma * randn(1);
    A(i,:) = e';
end

% Check that the associated normal equations have a unique solution.
if rank( A ) == min( size( A ) )
    fprintf( "A is full rank.\n" )
else
    fprintf( "A is not full rank (rank=%d).\n", rank( A ) )
end

% (b) Solve the system by using the SVD decomposition
[ U,S,V ] = svd( A );
IS = S';
for i = 1 : n/2
    IS(i,i) = 1 / S(i,i);
end
xb = V * IS * U' * b;

% Compare the numerical solutions with the reference solution xex = v
xex = v;
err2_b = norm( xb(1:n/2) - xex(1:n/2) ) / norm( xex(1:n/2) );
erri_b = norm( xb(1:n/2) - xex(1:n/2), Inf ) / norm( xex(1:n/2), Inf );

fprintf( "\nRelative error (L2):" )
fprintf( "\nSVD decomposition:           %e\n", err2_b )

fprintf( "\nRelative error (Linf):" )
fprintf( "\nSVD decomposition:           %e\n", erri_b )

%% Exercise 03
clear all 
close all
format long

n = 100;
d0 = 2 * ones( n,1 );
d1 = - ones( n-1,1 );
B = diag(d0) + diag(d1,1) + diag(d1,-1);
A = expm(-5*B);

% Using the SVD of A build an approximation A_hat of rank 40.
[ U,S,V ] = svd( A );
figure, semilogy( diag(S), 'o' )
title( "Singular values of A" )

p = 40;
IS = S;
for i = p+1 : n
    IS(i,i) = 0;
end
A_hat = U * IS * V';

% Compute the relative error in the Frobenius norm.
err = norm( A - A_hat, 'fro' ) / norm( A, 'fro' );
fprintf( "Relative error (Frobenius norm): %e\n", err )

%% Exercise 04
clear all
close all
format long

n = 50;
v = (0:n) / n;
A = vander( v' );

xex = ones( n+1,1 );
b = A * xex;

% (a) Solve the system using the LU factorization with pivoting.
[ L,U,P ] = lu( A );
ya = L \ (P * b);
xa = U \ ya;
    
% (b) Using the SVD of A, build an approximation A_hat of rank p < N + 1.
%     Solve the resulting singular system in the minimum norm least square
%     sense using the SVD of A_hat.
[ U,S,V ] = svd( A );
figure, semilogy( diag(S) )
title( "Singular values of A" )

p=1;
check1 = 1;
check2 = 10^10;

while(check1>10^(-7) || check2>10^7)
    if (p==n+1) 
        break;
    end
    p = p+1;
    IS=S;
    for i = p+1 : n
        IS(i,i) = 0;
    end
    A_hat = U * IS * V';
    check1 = norm( A - A_hat, 'fro' ) / norm( A, 'fro' );
    check2 = IS(1,1) / IS(p,p);
end

if (p==n+1)
    fprintf("\nA_hat does not exist.")
else
    fprintf( "\np=%d, Relative error (Frobenius norm): %e", p, check1 )
    fprintf( "\nSingular values ratio:           %e\n", check2 )
end
xb = pinv( A_hat ) * b;

% Compute the relative error in the l2 norm.
err2_a = norm( xa - xex ) / norm( xex );
err2_b = norm( xb - xex ) / norm( xex );
err2_a_inf = norm( xa - xex, Inf ) / norm( xex, Inf );
err2_b_inf = norm( xb - xex, Inf ) / norm( xex, Inf );
fprintf( "\nRelative error on the solution (L2):" )
fprintf( "\nLU factorization:  %e", err2_a )
fprintf( "\nSVD decomposition: %e", err2_b )
fprintf( "\nRelative error on the solution (Linf):" )
fprintf( "\nLU factorization:  %e", err2_a_inf )
fprintf( "\nSVD decomposition: %e\n", err2_b_inf )

apriori_2   = cond(A)*eps
apriori_inf = cond(A,inf)*eps

%% Exercise 05
clear
n = 50;
v = (0:n) / n;
v(end) = 3;
A = vander( v );

xex = ones( n+1,1 );
b = A * xex;

% (a) Solve the system using the LU factorization with pivoting.
[ L,U,P ] = lu( A );
ya = L \ (P * b);
xa = U \ ya;

% (b) Using the SVD of A, build an approximation A_hat of rank p < N + 1.
%     Solve the resulting singular system in the minimum norm least square
%     sense using the SVD of A_hat.
[ U,S,V ] = svd( A );
figure, semilogy( diag(S), 'o' )
title( "Singular values of A" )

p=1;
check1 = 1;
check2 = 10^8;

while(check1>10^(-7) || check2>10^7)
    if (p==n+1) 
        break;
    end
    p = p+1;
    IS=S;
    for i = p+1 : n
        IS(i,i) = 0;
    end
    A_hat = U * IS * V';
    p
    check1 = norm( A - A_hat, 'fro' ) / norm( A, 'fro' )
    check2 = IS(1,1) / IS(p,p)
end

if (p==n+1)
    fprintf("\nA_hat does not exist.")
else
    fprintf( "\np=%d, Relative error (Frobenius norm): %e", p, check1 )
    fprintf( "\nSingular values ratio:           %e\n", check2 )
end
xb = pinv( A_hat ) * b;

% Compute the relative error in the l2 norm.
err2_a = norm( xa - xex ) / norm( xex );
err2_b = norm( xb - xex ) / norm( xex );
err2_a_inf = norm( xa - xex, Inf ) / norm( xex, Inf );
err2_b_inf = norm( xb - xex, Inf ) / norm( xex, Inf );
fprintf( "\nRelative error on the solution (L2):" )
fprintf( "\nLU factorization:  %e", err2_a )
fprintf( "\nSVD decomposition: %e\n", err2_b )
fprintf( "\nRelative error on the solution (Linf):" )
fprintf( "\nLU factorization:  %e", err2_a_inf )
fprintf( "\nSVD decomposition: %e\n", err2_b_inf )

apriori_2   = cond(A)*eps
apriori_inf = cond(A,inf)*eps


%% Exercise 6
clear all
close all
format long

L=1;
N=100;
dx=L/N;
x=[0:dx:L];
y=[0:dx:L]; 
f=@(x,y) sin(6*pi*(x+y^2)/L);
A=zeros(N+1,N+1);

for j=1:N+1
    for i=1:N+1
    A(i,j)=f(x(i),y(j));
    end
end


figure(1)
contourf(x,y,A)
colorbar

[U,S,V]=svd(A);
ss=diag(S);

figure(2)
semilogy(ss,'r*')
ss(3:end)=0;
Shat=diag(ss);
Ahat=U*Shat*V';

figure(3)
contourf(x,y,Ahat)
colorbar

err_fro=norm(A-Ahat, 'fro')/norm(A, 'fro')
 


