% Script exercise session 12102020

%% Exercise 1

A = toeplitz([10 2 3 4 5]);

L = tril(A);
U = triu(A);

xex = ones(5,1);
bL  = L * xex;
bU  = U * xex;

xL = fwsub(L,bL);
xU = bksub(U,bU);

%% Exercise 2

[L,U]=lu(A);
det(U)

det(A)

%% Exercise 3.1

% System exe 4.4

n = 100;    
v = ones(n,1);  
v(1:2:end) = 2;
v(2:2:end) = 4;
d1 = ones( n-1,1 );
A = diag(v) - diag(d1,1) + diag(d1,-1);
I = eye(n);
B = ( -3*A + 2*A^2 ) / ( I + 4*A - A^4 ) ;

[ L,U,P ] = lu(B);
xex = -ones(n,1);
b = B * xex;

% fwsub to solve L * y = P * b
y = fwsub( L, P*b );
% bksub to solve U * x1 = y
x1 = bksub( U, y );

% Backslash to solve L * y = P * b
y = L \ (P*b);
% Backslash to solve U * x2 = y
x2 = U \ y;

% Check if pivoting occured
if norm( P - eye(n), Inf ) > 0
    fprintf(' Pivoting\n ')
else
    fprintf(' No Pivoting\n')
end

% Absolute and relative error (l2 and linf)
abserr_l2_x1 = norm( x1 - xex, 2 )
relerr_l2_x1 = abserr_l2_x1 / norm( xex, 2 )
abserr_l2_x2 = norm( x2 - xex, 2 )
relerr_l2_x2 = abserr_l2_x2 / norm( xex, 2 )

abserr_linf_x1 = norm( x1 - xex, Inf )
relerr_linf_x1 = abserr_linf_x1 / norm( xex, Inf )
abserr_linf_x2 = norm( x2 - xex, Inf )
relerr_linf_x2 = abserr_linf_x2 / norm( xex, Inf )

%% Exercise 3.2

% System exe 4.5

n = 7;
A = hilb(n);

[ L,U,P ] = lu(A);
xex = -ones(n,1);
b = A * xex;

% fwsub to solve L * y = P * b
y = fwsub( L, P*b );
% bksub to solve U * x1 = y
x1 = bksub( U, y );

% Backslash to solve L * y = P * b
y = L \ (P*b);
% Backslash to solve U * x2 = y
x2 = U \ y;

% Check if pivoting occured
if norm( P - eye(n), Inf ) > 0
    fprintf(' Pivoting\n ')
else
    fprintf(' No Pivoting\n')
end

% Absolute and relative error (l2 and linf)
abserr_l2_x1 = norm( x1 - xex, 2 )
relerr_l2_x1 = abserr_l2_x1 / norm( xex, 2 )
abserr_l2_x2 = norm( x2 - xex, 2 )
relerr_l2_x2 = abserr_l2_x2 / norm( xex, 2 )

abserr_linf_x1 = norm( x1 - xex, Inf )
relerr_linf_x1 = abserr_linf_x1 / norm( xex, Inf )
abserr_linf_x2 = norm( x2 - xex, Inf )
relerr_linf_x2 = abserr_linf_x2 / norm( xex, Inf )

%% Exercise 3.3

% System 4.6
n = 20;
A = zeros(n);

d0 = 11:30;
d1 = 2*ones(n-1,1);
d2 = pi*ones(n-2,1);
A = A + diag(d0) + diag(d1,-1) + diag(d2,2);

for i = 1 : n
    if ~A(i,10)
        A(i,10) = 5;
    end
end

[ L,U,P ] = lu(A);
xex = -ones(n,1);
b = A * xex;

% fwsub to solve L * y = P * b
y = fwsub( L, P*b );
% bksub to solve U * x1 = y
x1 = bksub( U, y );

% Backslash to solve L * y = P * b
y = L \ (P*b);
% Backslash to solve U * x2 = y
x2 = U \ y;

% Check if pivoting occured
if norm( P - eye(n), Inf ) > 0
    fprintf(' Pivoting\n ')
else
    fprintf(' No Pivoting\n')
end

% Absolute and relative error (l2 and linf)
abserr_l2_x1 = norm( x1 - xex, 2 )
relerr_l2_x1 = abserr_l2_x1 / norm( xex, 2 )
abserr_l2_x2 = norm( x2 - xex, 2 )
relerr_l2_x2 = abserr_l2_x2 / norm( xex, 2 )

abserr_linf_x1 = norm( x1 - xex, Inf )
relerr_linf_x1 = abserr_linf_x1 / norm( xex, Inf )
abserr_linf_x2 = norm( x2 - xex, Inf )
relerr_linf_x2 = abserr_linf_x2 / norm( xex, Inf )

%% Exercise 3.4

% System 4.7
nb = 5;
n = 1000;

B = [ ones(nb,1) 2*ones(nb,1) 3*ones(nb,1) 4*ones(nb,1) 5*ones(nb,1) ];
B(1,2) = 3;
B(1,3) = 4;
B(1,4) = 1;
B(1,5) = -1;
B(1,1) = 10;
B(2,2) = 30;
B(3,3) = 50;
B(4,4) = 30;
B(5,5) = 10;

A = zeros(n);
for i = 1 : n/nb
    b = (i-1)*nb;
    A( b + 1 : b + nb, b + 1 : b + nb ) = B;
end

[ L,U,P ] = lu(A);
xex = -ones(n,1);
b = A * xex;

% fwsub to solve L * y = P * b
y = fwsub( L, P*b );
% bksub to solve U * x1 = y
x1 = bksub( U, y );

% Backslash to solve L * y = P * b
y = L \ (P*b);
% Backslash to solve U * x2 = y
x2 = U \ y;

% Check if pivoting occured
if norm( P - eye(n), Inf ) > 0
    fprintf(' Pivoting\n ')
else
    fprintf(' No Pivoting\n')
end

% Absolute and relative error (l2 and linf)
abserr_l2_x1 = norm( x1 - xex, 2 )
relerr_l2_x1 = abserr_l2_x1 / norm( xex, 2 )
abserr_l2_x2 = norm( x2 - xex, 2 )
relerr_l2_x2 = abserr_l2_x2 / norm( xex, 2 )

abserr_linf_x1 = norm( x1 - xex, Inf )
relerr_linf_x1 = abserr_linf_x1 / norm( xex, Inf )
abserr_linf_x2 = norm( x2 - xex, Inf )
relerr_linf_x2 = abserr_linf_x2 / norm( xex, Inf )
