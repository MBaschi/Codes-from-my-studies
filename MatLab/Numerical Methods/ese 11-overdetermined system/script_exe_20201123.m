%% Exercise 01
clear all
close all
format long

clear
f = @(x,y) 0.1*x^2 + 0.2*y^2 - 1;

A = [ 0.0 0.0 1;
      0.0 0.1 1;
      0.1 0.0 1;
      0.1 0.1 1;
      0.0 0.2 1;
      0.1 0.2 1;
      0.2 0.2 1;
      0.2 0.1 1;
      0.2 0.0 1 ];

if rank( A ) == min( size( A ) )
    fprintf( "A is full rank.\n" )
else
    fprintf( "A is not full rank (rank=%d).\n", rank( A ) )
end

m = size( A,1 );
xm = A( :,1 );
ym = A( :,2 );
b = zeros( m,1 );

for i = 1 : m
    b( i ) = f( xm(i), ym(i) );
end

% (a) Solve the system using \
tic
xa = A \ b;
ta=toc;

% Normal equations
A_n = A' * A;
b_n = A' * b;

% (b) Solve the system by solving the normal equations using Cholesky
tic
L = chol( A_n, 'lower' );
yb = L \ b_n;
xb = L' \ yb;
tb = toc;

% (c) Solve the system using the QR decomposition
tic
[ Q,R ] = qr( A,0 );
xc = R \ ( Q' * b );
tc = toc;

% (d) Solve the system using the SVD decomposition
tic
[ U,S,V ] = svd( A );
IS = S';
IS(1,1) = 1 / S(1,1);
IS(2,2) = 1 / S(2,2);
IS(3,3) = 1 / S(3,3);
xd = V * IS * U' * b;
td = toc;

% (e) Solve the system using pinv
tic
xe = pinv( A ) * b;
te = toc;

% Compare the numerical solutions with xex from point (a) by computing the
% relative error in l2 and linf norms.
err2_b = norm( xb - xa ) / norm( xa );
err2_c = norm( xc - xa ) / norm( xa );
err2_d = norm( xd - xa ) / norm( xa );
err2_e = norm( xe - xa ) / norm( xa );
erri_b = norm( xb - xa, Inf ) / norm( xa, Inf );
erri_c = norm( xc - xa, Inf ) / norm( xa, Inf );
erri_d = norm( xd - xa, Inf ) / norm( xa, Inf );
erri_e = norm( xe - xa, Inf ) / norm( xa, Inf );

fprintf( "\nRelative error (L2):" )
fprintf( "\nNormal equations + Cholesky: %e", err2_b )
fprintf( "\nQR decomposition:            %e", err2_c )
fprintf( "\nSVD decomposition:           %e", err2_d )
fprintf( "\nMatlab pinv:                 %e\n", err2_e )
fprintf( "\nRelative error (Linf):" )
fprintf( "\nNormal equations + Cholesky: %e", erri_b)
fprintf( "\nQR decomposition:            %e", erri_c )
fprintf( "\nSVD decomposition:           %e", erri_d )
fprintf( "\nMatlab pinv:                 %e\n", erri_e )

%% Exercise 02
clear all 
close all
format long

f = @(x,y) 0.1*x^2 + 0.2*y^2 - 1;

A = [ 0.0 0.2 1;
      0.1 0.2 1;
      0.2 0.2 1;
      0.3 0.2 1;
      0.4 0.2 1;
      0.5 0.2 1;
      0.6 0.2 1;
      0.7 0.2 1;
      0.8 0.2 1 ];

if rank( A ) == min( size( A ) )
    fprintf( "A is full rank.\n" )
else
    fprintf( "A is not full rank (rank=%d).\n", rank( A ) )
end
  
n = size( A,1 );
xm = A( :,1 );
ym = A( :,2 );
b = zeros( n,1 );

for i = 1 : n
    b( i ) = f( xm(i), ym(i) );
end

% (a) Solve the system using \
tic
xa = A \ b;
ta = toc;

% (b) Solve the system by solving the normal equations using Cholesky
% A_n = A' * A;
% L = chol( A_n, 'lower' );
% yb = L \ ( A' * b );
% xb = L' \ yb;

% (c) Solve the system using the QR decomposition
[ Q,R ] = qr( A );
[ Q0,R0 ] = qr( A, 0 );
xc = R \ ( Q' * b );
xc0 = R0 \ ( Q0' * b );

% (d) Solve the system using the SVD decomposition
[ U,S,V ] = svd( A );

IS = S';
IS(1,1) = 1 / S(1,1);
IS(2,2) = 1 / S(2,2);
IS(3,3) = 0;
xd = V * IS * U' * b;

% (e) Solve the system using pinv
xe = pinv( A ) * b;

% Compare the numerical solutions with xex from point (a) by computing the
% relative error in l2 and linf norms.
% err2_b = norm( xb - xa ) / norm( xa );
err2_c = norm( xc - xa ) / norm( xa );
err2_d = norm( xd - xa ) / norm( xa );
err2_e = norm( xe - xa ) / norm( xa );
% erri_b = norm( xb - xa, Inf ) / norm( xa, Inf );
erri_c = norm( xc - xa, Inf ) / norm( xa, Inf );
erri_d = norm( xd - xa, Inf ) / norm( xa, Inf );
erri_e = norm( xe - xa, Inf ) / norm( xa, Inf );

fprintf( "\nRelative error (L2):" )
% fprintf( "\nNormal equations + Cholesky: %e", err2_b )
fprintf( "\nQR decomposition:            %e", err2_c )
fprintf( "\nSVD decomposition:           %e", err2_d )
fprintf( "\nMatlab pinv:                 %e\n", err2_e )
fprintf( "\nRelative error (Linf):" )
% fprintf( "\nNormal equations + Cholesky: %e", erri_b)
fprintf( "\nQR decomposition:            %e", erri_c )
fprintf( "\nSVD decomposition:           %e", erri_d )
fprintf( "\nMatlab pinv:                 %e\n", erri_e )

%% Exercise 03
clear all
close all
format long

n = 20;
m = 10;
d0 = 2 * ones( n,1 );
d1 = - ones( n-1,1 );
A = diag(d0) + diag(d1,1) + diag(d1,-1);
A = repmat( A,m,1 );
b = repmat( 1:m,n,1 );
b = reshape( b,n*m,1 );

if rank( A ) == min( size( A ) )
    fprintf( "A is full rank.\n\n" )
else
    fprintf( "A is not full rank (rank=%d).\n", rank( A ) )
end

% (a) Solve the system using \
tic
xa = A \ b;
ta = toc;

% (b) Solve the system by solving the normal equations using Cholesky
%     Represent matrix A'A in sparse format
tic
A_n = sparse( A' * A );
b_n = A' * b;
L = chol( A_n, 'lower' );
yb = L \ ( b_n );
xb = L' \ yb;
tb = toc;

% (c) Solve the system using the QR decomposition
tic
[ Q,R ] = qr( A, 0 );
xc = R \ ( Q' * b );
tc = toc;

% (d) Solve the system using the SVD decomposition
tic
[ U,S,V ] = svd( A );
IS = S';
for i = 1 : n
    IS(i,i) = 1 / S(i,i);
end
xd = V * IS * U' * b;
td = toc;

% (e) Solve the system using pinv
tic
xe = pinv( A ) * b;
te = toc;

% Compare the numerical solutions with xex from point (a) by computing the
% relative error in l2 and linf norms.
err2_b = norm( xb - xa ) / norm( xa );
err2_c = norm( xc - xa ) / norm( xa );
err2_d = norm( xd - xa ) / norm( xa );
err2_e = norm( xe - xa ) / norm( xa );
erri_b = norm( xb - xa, Inf ) / norm( xa, Inf );
erri_c = norm( xc - xa, Inf ) / norm( xa, Inf );
erri_d = norm( xd - xa, Inf ) / norm( xa, Inf );
erri_e = norm( xe - xa, Inf ) / norm( xa, Inf );

fprintf( "\nRelative error (L2):" )
fprintf( "\nNormal equations + Cholesky: %e", err2_b )
fprintf( "\nQR decomposition:            %e", err2_c )
fprintf( "\nSVD decomposition:           %e", err2_d )
fprintf( "\nMatlab pinv:                 %e\n", err2_e )
fprintf( "\nRelative error (Linf):" )
fprintf( "\nNormal equations + Cholesky: %e", erri_b)
fprintf( "\nQR decomposition:            %e", erri_c )
fprintf( "\nSVD decomposition:           %e", erri_d )
fprintf( "\nMatlab pinv:                 %e\n", erri_e )

% Compare the time required to compute the solution by each method.
fprintf( "\nComputational time:" )
fprintf( "\nBackslash:                   %e", ta )
fprintf( "\nNormal equations + Cholesky: %e", tb )
fprintf( "\nQR decomposition:            %e", tc )
fprintf( "\nSVD decomposition:           %e", td )
fprintf( "\nMatlab pinv:                 %e\n", te )

%% Exercise 04
clear all
close all
format long

n = 1000;
m = 10;
d0 = 4 * ones( n,1 );
d1 = - ones( n-1,1 );
A = diag(d0) + diag(d1,1) + diag(d1,-1);
A(1,n) = -0.5;
A(n,1) = -0.5;
A = repmat( A,m,1 );
b = repmat( 1:m,n,1 );
b = reshape( b,n*m,1 );

if rank( A ) == min( size( A ) )
    fprintf( "A is full rank.\n\n" )
else
    fprintf( "A is not full rank (rank=%d).\n", rank( A ) )
end

% (a) Solve the system using \
tic
xa = A \ b;
ta = toc;

% (b) Solve the system using the QR decomposition
tic
[ Q,R ] = qr( A, 0 );
xb = R \ ( Q' * b );
tb = toc;

% (c) Solve the system by solving the normal equations using Cholesky
%     Represent matrix A'A in sparse format
tic
A_n = sparse( A' * A );
b_n = A' * b;
L = chol( A_n, 'lower' );
yc = L \ ( b_n );
xc = L' \ yc;
tc = toc;

res_chol_norm = norm(b_n-A_n*xc);

maxit=1000;
tic
[xc_pcg,flag,relres,iter] = pcg(A_n,b_n,res_chol_norm,maxit, [], [], xa+10*ones(size(xa)));
tc_pcg = toc;


% Compare the numerical solutions with xex from point (a) by computing the
% relative error in l2 and linf norm.
err2_b = norm( xb - xa ) / norm( xa );
err2_c = norm( xc - xa ) / norm( xa );
err2_cpcg = norm( xc_pcg - xa ) / norm( xa );

%
erri_b = norm( xb - xa, Inf ) / norm( xa, Inf );
erri_c = norm( xc - xa, Inf ) / norm( xa, Inf );
erri_cpcg = norm( xc_pcg - xa, Inf ) / norm( xa, Inf );

fprintf( "\nRelative error (L2):" )
fprintf( "\nQR decomposition:            %e", err2_b )
fprintf( "\nNormal equations + Cholesky: %e", err2_c )
fprintf( "\nNormal equations + CG: %e", err2_cpcg )
fprintf( "\nRelative error (Linf):" )
fprintf( "\nQR decomposition:            %e", erri_b )
fprintf( "\nNormal equations + Cholesky: %e", erri_c )
fprintf( "\nNormal equations + CG: %e", erri_cpcg )

% Compare the time required to compute the solution by each method.
fprintf( "\nComputational time:" )
fprintf( "\nBackslash:                   %e", ta )
fprintf( "\nQR decomposition:            %e", tb )
fprintf( "\nNormal equations + Cholesky: %e", tc )
fprintf( "\nNormal equations + CG: %e\n", tc_pcg )

% Solve the system using the SVD decomposition
tic
[ U,S,V ] = svd( A,0 );
% IS = S';
% for i = 1 : n
%     IS(i,i) = 1 / S(i,i);
% end
xe = V * inv(S) * U' * b;
te = toc;

err2_e = norm( xe - xa ) / norm( xa );
erri_e = norm( xe - xa, Inf ) / norm( xa, Inf );

fprintf( "\nRelative error (L2):" )
fprintf( "\nSVD: %e", err2_e )
fprintf( "\nRelative error (LInf):" )
fprintf( "\nSVD: %e", erri_e )

fprintf( "\nComputational time:" )
fprintf( "\nSVD: %e\n", te )
