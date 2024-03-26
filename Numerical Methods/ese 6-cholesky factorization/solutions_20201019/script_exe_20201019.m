% Script lecture 20201019

%% Exercise 1
clear all
close all
format long

n = 5;
A = toeplitz(n:-1:1);
xex = (1:n)';
b = A * xex;

% Check that A is symmetric and positive definite
if A == A'
    fprintf('A is symmetric.\n')
    if min(eig(A)) > 0
        fprintf('A is positive definite.\n')
    else
        fprintf('A is not positive definite.\n')
    end
else
    fprintf('A is not symmetric.\n')
end

% (a) LU factorization using \ to solve the triangular systems
[ L,U,P ] = lu( A );
% Check whether pivoting occured
if norm( P - eye(n), Inf ) > 0
    fprintf('Pivoting!\n')
else
    fprintf('No Pivoting.\n')
end
% Solve L * y = P * b
y = L \ (P*b);
% Solve U * x = y
x_lu = U \ y;

% (b) Cholesky using \ to solve the triangular systems
% Check that C is different from L provided by LU
C = chol( A ,'lower' );
% Solve C * y = b
y = C \ b;
% Solve C' * x = y
x_ch = C' \ y;

% (c) Compute the absolute and relative errors, in l2 and linf norm
abserr_l2_lu = norm( x_lu - xex, 2 )
relerr_l2_lu = abserr_l2_lu / norm( xex, 2 )
abserr_l2_ch = norm( x_ch - xex, 2 )
relerr_l2_ch = abserr_l2_ch / norm( xex, 2 )

abserr_linf_lu = norm( x_lu - xex, Inf )
relerr_linf_lu = abserr_linf_lu / norm( xex, Inf )
abserr_linf_ch = norm( x_ch - xex, Inf )
relerr_linf_ch = abserr_linf_ch / norm( xex, Inf )


%% Exercise 2

clear all
close all
format long

n = 13;
A = hilb( n ) %+ eye( n );
xex = - ones( n,1 );
b = A * xex;

% (a) Check that A is symmetric and positive definite
if A == A'
    fprintf('A is symmetric.\n')
    if min(eig(A)) > 0
        fprintf('A is positive definite.\n')
    else
        fprintf('A is not positive definite.\n')
    end
else
    fprintf('A is not symmetric.\n')
end

% (b) LU factorization using \ to solve the triangular systems
[ L,U,Plu ] = lu( A );
% Check whether pivoting occured
if norm( Plu - eye(n), Inf ) > 0
    fprintf('Pivoting!\n')
else
    fprintf('No Pivoting.\n')
end
% Solve L * y = P * b
y = L \ (Plu*b);
% Solve U * x = y
x_lu = U \ y;

% (c) Cholesky using \ to solve the triangular systems
%     Check that C is different from L provided by LU
C = chol( A,'lower' );
% Solve C' * y = b
y = C \ b;
% Solve C * x = y
x_ch = C' \ y;

% (e) Compute the absolute and relative errors, in l2 and linf norm
abserr_l2_lu = norm( x_lu - xex, 2 )
relerr_l2_lu = abserr_l2_lu / norm( xex, 2 )
abserr_l2_ch = norm( x_ch - xex, 2 )
relerr_l2_ch = abserr_l2_ch / norm( xex, 2 )

abserr_linf_lu = norm( x_lu - xex, Inf )
relerr_linf_lu = abserr_linf_lu / norm( xex, Inf )
abserr_linf_ch = norm( x_ch - xex, Inf )
relerr_linf_ch = abserr_linf_ch / norm( xex, Inf )

%% Exercise 3

clear all
close all
disp('Exercise 3\n')
N = [ 50, 500, 5000 ];

sparse_on = 0;

for i = 1 : length(N)
    n = N(i);
    fprintf('N=%d\n', n)
    
    d0 = 5 * ones(n,1);
    d1 = ones(n-1,1);
    d2 = ones(n-2,1);
    A = diag(d0) - diag(d1,1) - diag(d2,2) - diag(d1,-1) - diag(d2,-2);
    
    min(eig(A))
    
    if(sparse_on)
      A=sparse(A);
    end
    xex = ones(n,1);
    b = A * xex;
    
    tic;
    % (a) LU factorization using \ to solve the triangular systems
    [ L,U,P ] = lu( A );
    % Solve L * y = P * b
    y = L \ (P*b);
    % Solve U * x = y
    x_lu = U \ y;
    t_lu(i) = toc;
    
    % Check whether pivoting occured
    if norm( P - eye(n), Inf ) > 0
        fprintf('Pivoting!\n')
    else
        fprintf('No Pivoting.\n')
    end
    
    tic;
    % (b) Cholesky factorization using \ to solve the triangular systems,
    % 
    C = chol( A, 'lower' );
    %C = chol_band(A,2); % Uncomment for exercise 4
    % Solve L * y = b
    y = C \ b;
    % Solve L' * x = y
    x_ch = C' \ y;
    t_ch(i) = toc;
    
    % (d) Compute the absolute and relative errors, in l2 and linf norm
    abserr_l2_lu(i) = norm( x_lu - xex, 2 )
    relerr_l2_lu(i) = abserr_l2_lu(i) / norm( xex, 2 )
    
    abserr_linf_lu(i) = norm( x_lu - xex, Inf )
    relerr_linf_lu(i) = abserr_linf_lu(i) / norm( xex, Inf )
    
    abserr_l2_ch(i) = norm( x_ch - xex, 2 )
    relerr_l2_ch(i) = abserr_l2_ch(i) / norm( xex, 2 )
    
    abserr_linf_ch(i) = norm( x_ch - xex, Inf )
    relerr_linf_ch(i) = abserr_linf_ch(i) / norm( xex, Inf )
    
    
end

sparse_on

t_lu
t_ch

figure
semilogy( N,t_lu, N, t_ch )
legend('LU','Chol')
title('Computational effort')
xlabel('Matrix size')
ylabel('Time (s)')
 
figure
semilogy( N,relerr_l2_lu, N,relerr_l2_ch )
legend('LU','Chol')
title('Error')
xlabel('Matrix size')
ylabel('Relative error (l_2 norm)')


%% Exercises 5/6

clear all
close all
format long

nn_vec=[100 1000 10000]';

sparse_on = 1;

for i=1:size(nn_vec,1)
    nn=nn_vec(i,1); 
    fprintf('nn=%d\n',nn)
   
    e = ones(nn,1);
    
    if(sparse_on)
        A = spdiags([-e 4*e e], -1:1, nn,nn);
    else
        A = diag(4*e)...
            + diag(ones(nn-1,1),1)...
            - diag(ones(nn-1,1),-1);
    end
       
    xex = 2*e;
    
    bb = A*xex;
    %
    disp('Elapsed time, LU band: ')
    tic
    [L,U] = lu_band_t(A);
    
    y = fwsub_band(L,bb,1);
    x = bksub_band(U,y,1);
    tt_lu_band(i)=toc
    errl2=norm(x-xex)/norm(xex)
    
    
    disp('Elapsed time, LU: ')
    tic
    [L,U,P] = lu(A);
 
    %y = fwsub(L,P*bb);
    %x = bksub(U,y);
    y = L \ (P*bb);
    x = U \ y;
    
    tt_lu(i)=toc
    errl2=norm(x-xex)/norm(xex)
            
end

sparse_on

tt_lu_band

tt_lu


%% Exercise 7

clear all
close all
format long

nn_vec = [100 500 2000]';

for i=1:size(nn_vec,1)
    n=nn_vec(i);
    d0 = 10 * ones( n,1 );
    Af = diag( d0 );
    Af( 1, 2:end ) = 1;     % First row
    Af( end, 1:end-1 ) = 1; % Last row
    Af( 2:end, 1 ) = 1;     % First column
    Af( 1:end-1, end ) = 1; % Last column
    Af = Af + diag([0; -ones(floor(.5*n)-2,1); 0], floor(.5*n));
    
    Af = Af + diag([0; -ones(floor(.5*n)-2,1); 0], floor(.5*n));
    
    As = sparse( Af );
    
    b = ones( n,1 );
    b( 2:2:end ) = -1;
    
    fprintf( 'n = %d\n', n)
    % LU factorization. Full storage form.
    fprintf( 'Full storage, LU:\t' )
    tic
    [ Lf,Uf,Pf ] = lu( Af );
    toc
    fprintf( 'Full storage, solve:\t' )
    tic
    yf = Lf \ ( Pf*b );
    xf = Uf \ yf;
    toc
    fprintf( 'Full storage, backslash:\t' )
    tic
    xxf=Af\b;
    toc
    % LU factorization. Sparse storage form.
    fprintf( 'Sparse storage, LU:\t' )
    tic
    [ Ls,Us,Ps ] = lu( As );
    toc
    fprintf( 'Sparse storage, solve:\t' )
    tic
    ys = Ls \ ( Ps*b );
    xs = Us \ ys;
    toc
    fprintf( 'Sparse storage, backslash:\t' )
    tic
    xxs=As\b;
    toc
    fprintf('Full minus sparse=%f\n\n', norm(xf-xs, Inf))
end