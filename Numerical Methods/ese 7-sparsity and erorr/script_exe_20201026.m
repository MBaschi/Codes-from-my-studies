%% Exercise 1

clear all
close all
format long

nn_vec = [ 100 500 2000 ]';


for i=1:size(nn_vec,1)
    n = nn_vec(i);
    fprintf('n=%d\n',n)
    d0 = 10 * ones( n,1 );
    Af = diag( d0 );
    Af( 1, 2:end ) = 1;     % First row
    Af( end, 1:end-1 ) = 1; % Last row
    Af( 2:end, 1 ) = 1;     % First column
    Af( 1:end-1, end ) = 1; % Last column
    Af = Af + diag([0; -ones(floor(.5*n)-2,1); 0], floor(.5*n));
    
    As = sparse( Af );
    b = ones( n,1 );
    b( 2:2:end ) = -1;
    % LU factorization of the original system.
    fprintf( 'Original system, LU:\t ' )
    tic
    [ Ls,Us,Ps ] = lu( As );
    y = Ls \ (Ps * b);
    x = Us \ y;
    toc
    figure
    spy( Ls )
    fig_title = strcat('Spy of matrix L, n=', num2str(n));
    title(fig_title)
    
    figure
    spy( Us )
    fig_title = strcat('Spy of matrix U, n=', num2str(n));
    title(fig_title)
    
    
    
    % Build a sparsity enhancing permutation p of the columns of A.
    fprintf( 'With column permutation:\t ' )
    tic
    p = colamd( As );
    I = speye( n );
    P_ = I(p,:);
    A_ = As * P_';
    
    % LU factorization after column permutation.
    [ Lp,Up,Pp ] = lu( A_ );
    
    zp = Lp \ (Pp * b);
    yp = Up \ zp;
    xp = P_' * yp;
    toc
    
    figure, spy( Ls )
    fig_title=strcat('Original LU sparsity, n=', num2str(n) );
    title(fig_title)
    fprintf( 'Original system:\t nnz = %d\n', nnz( Ls ) )
    figure, spy( Lp )
    fig_title=strcat('After column permutation, n=', num2str(n) );
    title(fig_title)
    fprintf( 'After column permutation:\t nnz = %d\n', nnz( Lp ) )
    
end

%% Exercise 2
%
clear all
close all
format long

nn_vec = [ 100 500 2000 ]';


for i=1:size(nn_vec,1)
    for rcm=0:1
        n=nn_vec(i);
        fprintf('n=%d, rcm=%d\n',n, rcm)
        d0 = 100 * ones( n,1 );
        Af = diag( d0 );
        Af( 1, 2:end ) = 1;     % First row
        Af( end, 1:end-1 ) = 1; % Last row
        Af( 2:end, 1 ) = 1;     % First column
        Af( 1:end-1, end ) = 1; % Last column
        Af = Af ...
            + diag([0; -ones(floor(.5*n)-2,1); 0], floor(.5*n))...
            + diag([0; -ones(floor(.5*n)-2,1); 0], -floor(.5*n));
        
        As = sparse( Af );
        b = ones( n,1 );
        b( 2:2:end ) = -1;
        
        As = sparse(Af);
        
        lambda=eigs(As,1,'smallestabs')
        % Check that A is symmetric and positive definite
        if As == As'
            fprintf('A is symmetric.\n')
            if lambda > 0
                fprintf('A is positive definite.\n')
            else
                fprintf('A is not positive definite.\n')
            end
        else
            fprintf('A is not symmetric.\n')
        end
        fprintf( 'Full storage:\t\t ' )
        tic
        % Cholesky factorization. Full storage form.
        Cf = chol( Af,'lower' );
        
        yf = Cf \ b;
        xf = Cf' \ yf;
        toc
        fprintf( 'Sparse storage:\t ' )
        tic
        % Cholesky factorization. Sparse storage form.
        Cs = chol( As,'lower' );
        
        ys = Cs \ b;
        xs = Cs' \ ys;
        toc
        
        % Build a sparsity enhancing permutation of the rows and columns of A
        fprintf( 'With permutation:\t ' )
        tic
        if rcm
            p = symrcm( As );
        else
            p = symamd( As );
        end
        I = speye( n );
        P_ = I(p,:);
        A_ = P_ * As * P_';
        
        % Cholesky factorization on the permuted matrix.
        
        Cp = chol( A_,'lower' );
        zp = Cp \ (P_ * b);
        yp = Cp' \ zp;
        xp = P_' * yp;
        toc
        
        
        figure, spy( Cs )
        figtitle = strcat('Original Cholesky sparsity, n=',num2str(rcm), num2str(n));
        title( figtitle )
        fprintf( 'Original system:\t nnz = %d\n', nnz( Cs ) )
        figure, spy( Cp )
        figtitle = strcat('After permutation, rcm=',num2str(rcm),', n=', num2str(n));
        title( figtitle )
        fprintf( 'After permutation:\t nnz = %d\n', nnz( Cp ) )
        %
    end
end

%% Exercise 3


clear all
close all
format long

nn           = 20;
nn_vec       = 1:nn;


apriori_est  = zeros(nn,1);
apost_est    = zeros(nn,1);
apost_est_bs  = zeros(nn,1);

relerr_l2    = zeros(nn,1);
relerr_l2_bs  = zeros(nn,1);

relerr_linf    = zeros(nn,1);
relerr_linf_bs  = zeros(nn,1);

figure()

for i=1:size(nn_vec,2)
    fprintf('n=%d\n', nn_vec(i))
    A=hilb(i);
    xex=ones(i,1);
    b=A*xex;
    if(eigs(A,1,'smallestabs')<0)
        fprintf('Hilb(%d) cannot be guaranteed to be positive definite\n', i)
    end
    [L,U,P]=lu(A);
    if(norm(P-eye(i), Inf)>0)
        disp('Pivoting')
    else
        disp('No pivoting')
    end
    y=L\(P*b);
    x=U\y;
    
    xbs=A\b;
    
    relerr_l2(i,1)   = norm(x-xex,2)/norm(xex);
    relerr_l2_bs(i,1) = norm(xbs-xex,2)/norm(xex);
    
    relerr_linf(i,1)   = norm(x-xex,inf)/norm(xex, inf);
    relerr_linf_bs(i,1) = norm(xbs-xex,inf)/norm(xex,inf);
    
    residual    = b-A*x;
    residual_bs = b-A*xbs;
    
    apriori_est(i,1)  = cond(A)*eps;
    apost_est(i,1)    = cond(A)*norm(residual,2)/norm(b,2);
    apost_est_bs(i,1) = cond(A)*norm(residual_bs,2)/norm(b,2);
    
    condA = cond(A)
    
end

%
semilogy(nn_vec, relerr_l2, 'bo')
hold on
semilogy(nn_vec, relerr_l2_bs, 'ro')

semilogy(nn_vec, relerr_linf, 'bs')
hold on
semilogy(nn_vec, relerr_linf_bs, 'rs')

semilogy(nn_vec, apriori_est, 'k--')

semilogy(nn_vec, apost_est, 'b-')
semilogy(nn_vec, apost_est_bs, 'r-')
legend('L2err, LU', 'L2err, \\',...
    'Linferr, LU', 'Linferr, \\',...
    'A priori', 'A posteriori, LU', ...
    'A posteriori, \\', 'Location', 'Best', 'FontSize', 10)

%% Exercise 4

clear all
close all
format long

nn=20;

A     = 10^(-8)*eye(nn)+hilb(nn);
xex   = ones(nn,1);
b     = A*xex;


sigma   = 1;
apriori = 1;
rnd_vec = randn(size(b));
while(apriori>0.01)
    sigma   = .99*sigma;
    e       = sigma*rnd_vec;
    apriori = cond(A)*norm(e)/norm(b);
end
fprintf('Sigma=%1.16f, Apriori=%1.16f\n', sigma, apriori)

%% Exercise 5
clear all
close all
format long

%a
disp('Part a')

V   = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 100]';
A   = vander(V);
xex = ones(size(A,1),1);
xex(2:2:end)=-1;

b = A*xex;

[L,U,P]=lu(A);
if(norm(P-eye(size(A)), Inf)>0)
    disp('Pivoting')
else
    disp('No pivoting')
end

y = L\(P*b);
x = U\y;

xbs = A\b;

relerr_l2    = norm(x-xex,2)/norm(xex);
relerr_l2_bs = norm(xbs-xex,2)/norm(xex);

relerr_linf    = norm(x-xex,inf)/norm(xex, inf);
relerr_linf_bs = norm(xbs-xex,inf)/norm(xex,inf);

residual    = b-A*x;
residual_bs = b-A*xbs;

condA = cond(A)
apriori_est  = cond(A)*eps;
apost_est    = cond(A)*norm(residual,2)/norm(b,2);
apost_est_bs = cond(A)*norm(residual_bs,2)/norm(b,2);

nn_vec=1;

figure
subplot(1,2,1)
semilogy(nn_vec, relerr_l2, 'bo')
hold on
semilogy(nn_vec, relerr_l2_bs, 'ro')

semilogy(nn_vec, relerr_linf, 'bs')
hold on
semilogy(nn_vec, relerr_linf_bs, 'rs')

semilogy(nn_vec, apriori_est, 'ko', 'MarkerSize', 12)

semilogy(nn_vec, apost_est, 'bx', 'MarkerSize', 12)
semilogy(nn_vec, apost_est_bs, 'r*', 'MarkerSize', 12)

title('Ax=b')
ylim([10^(-16) 1000])
grid on

%b
disp('Part b')

PP = diag(1./A(:,1));

A = PP*A;
b = PP*b;

[L,U,P]=lu(A);
if(norm(P-eye(size(A)), Inf)>0)
    disp('Pivoting')
else
    disp('No pivoting')
end

y = L\(P*b);
x = U\y;

xbs = A\b;

relerr_l2    = norm(x-xex,2)/norm(xex);
relerr_l2_bs = norm(xbs-xex,2)/norm(xex);

relerr_linf    = norm(x-xex,inf)/norm(xex, inf);
relerr_linf_bs = norm(xbs-xex,inf)/norm(xex,inf);

residual    = b-A*x;
residual_bs = b-A*xbs;

condA = cond(A)
apriori_est  = cond(A)*eps;
apost_est    = cond(A)*norm(residual,2)/norm(b,2);
apost_est_bs = cond(A)*norm(residual_bs,2)/norm(b,2);

nn_vec=1;

subplot(1,2,2)
semilogy(nn_vec, relerr_l2, 'bo')
hold on
semilogy(nn_vec, relerr_l2_bs, 'ro')

semilogy(nn_vec, relerr_linf, 'bs')
hold on
semilogy(nn_vec, relerr_linf_bs, 'rs')

semilogy(nn_vec, apriori_est, 'ko', 'MarkerSize', 12)

semilogy(nn_vec, apost_est, 'bx', 'MarkerSize', 12)
semilogy(nn_vec, apost_est_bs, 'r*', 'MarkerSize', 12)

legend('L2err, LU', 'L2err, \\',...
    'Linferr, LU', 'Linferr, \\',...
    'A priori', 'A posteriori, LU', ...
    'A posteriori, \\', 'Location', 'Best', 'FontSize', 14)
title('PAx=Pb')
ylim([10^(-16) 1000])
grid on

%% Exercise 6

clear all
close all
format long

% a-d

n = 100;
v = [1:n]'.^2;
e = ones(n,1);
A = spdiags([e v -e], -80:80:80,n,n);

xex  = ones(n,1);
b    = A*xex ;

[L,U,P]=lu(A);

if(norm(P-eye(size(A)), Inf)>0)
    disp('Pivoting')
else
    disp('No pivoting')
end

y = L\(P*b);
x = U\y;

rsd = b-A*x;

x_bs = A\b;

rsd_bs = b-A*x_bs;

apriori_A        = condest(A)*eps
condA            = condest(A)

rell2_err_A      = norm(x-xex,2)/norm(xex,2)
rellinf_err_A    = norm(x-xex,Inf)/norm(xex,Inf)
apost_A          = condest(A)*norm(rsd,2)/norm(b,2)

rell2_err_A_bs   = norm(x_bs-xex,2)/norm(xex,2)
rellinf_err_A_bs = norm(x_bs-xex,Inf)/norm(xex,Inf)
apost_A_bs       = condest(A)*norm(rsd_bs,2)/norm(b,2)

