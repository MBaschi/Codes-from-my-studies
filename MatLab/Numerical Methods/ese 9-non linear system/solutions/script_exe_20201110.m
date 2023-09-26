%Exercise session 20201110

%% Exercise 01
clear all
close all
format long

f = @(x) [ x(1)^2 + x(2)^2 + x(3)^2 - 9;
           x(3) - x(1)^4 - x(2)^4;
           x(1) - x(2) ];
j = @(x) [ 2*x(1)     2*x(2)   2*x(3);
           -4*x(1)^3 -4*x(2)^3 1;
           1         -1        0 ];
       
       
% Initial guess
x0 = [ 10; 10; 2];

tol = 1e-12;
maxit = 500;

% (a) Solve using fsolve
options = optimset( 'TolX', tol, 'Display', 'iter' );
tic
xa = fsolve( f, x0, options );
ta = toc;

%% (b) Solve using Newton + exact Jacobian
[ xb, ib, tb ] = newton_exact_jacobian( x0, f, j, maxit, tol );

% (c) Solve using Newton + Constant Jacobian
[ xc, ic, tc ] = newton_constant_jacobian( x0, f, j, maxit, tol );

% (d) Solve using Newton + Constant Inexact Jacobian (forward FD)
delta = 1e-2;
[ xd, id, td ] = newton_constant_inexact_jacobian( x0, f, delta, maxit, tol );
% (e) Solve using Newton +  Inexact Jacobian (forward FD)
delta = 1e-2;
[ xe, ie, te ] = newton_inexact_jacobian( x0, f, delta, maxit, tol );
delta = 1e-2;
% (f) Solve using Quasi Newton Broyden  Inexact Jacobian (forward FD)
[ xf, iff, tf ] = quasi_newton_broyden( x0, f, delta, maxit, tol );
% (g) Solve using Quasi Newton Inverse Broyden  Inexact Jacobian (forward FD)
[ xg, ig, tg ] = quasi_newton_inv_broyden( x0, f, delta, maxit, tol );

fprintf( "\nIterations")
fprintf( "\nNewton + Exact Jacobian:          %i", ib )
fprintf( "\nNewton + Constant Jacobian:         %i", ic )
fprintf( "\nNewton + Constant Inexact Jacobian: %i", id )
fprintf( "\nNewton + Inexact Jacobian: %i", ie )
fprintf( "\n Quasi Newton Broyden: %i", iff )
fprintf( "\n Quasi Newton Inverse Broyden: %i", ig )
%fprintf( "\n Fixed point: %i", ig )

% Compare the numerical solutions of Newton wrt fsolve
errb = norm( xb - xa, Inf ) / norm( xa, Inf );
errc = norm( xc - xa, Inf ) / norm( xa, Inf );
errd = norm( xd - xa, Inf ) / norm( xa, Inf );
erre = norm( xe - xa, Inf ) / norm( xa, Inf );
errf = norm( xf - xa, Inf ) / norm( xa, Inf );
errg = norm( xg - xa, Inf ) / norm( xa, Inf );
%errh = norm( xh - xa, Inf ) / norm( xh, Inf );

fprintf( "\n\nRelative error")
fprintf( "\nNewton + Exact Jacobian:          %e", errb )
fprintf( "\nNewton + Constant Jacobian:         %e", errc )
fprintf( "\nNewton + Constant Inexact Jacobian: %e", errd )
fprintf( "\nNewton + Inexact Jacobian: %e", erre )
fprintf( "\nQuasi Newton Broyden: %e", errf )
fprintf( "\nQuasi Newton Inverse Broyden: %e", errg )
%fprintf( "\nFixed point: %e", errh )

% Compare the computational time
fprintf( "\n\nComputational time")
fprintf( "\nfsolve:                           %e", ta )
fprintf( "\nNewton + Exact Jacobian:          %e", tb )
fprintf( "\nNewton + Constant Jacobian:         %e", tc )
fprintf( "\nNewton + Constant Inexact Jacobian: %e", td )
fprintf( "\nNewton + Inexact Jacobian: %e", te )
fprintf( "\nQuasi Newton Broyden: %e", tf )
fprintf( "\nQuasi Newton Inverse Broyden: %e\n", tg )
%fprintf( "\nFixed point: %e\n", th )

%% Exercise 3
clear all
close all
format long

f = @(x) [ x(1) - x(2)*0.25;
           x(1)^2 + x(2)^2 + x(3)^2 - 0.5;
           x(3) - x(1)^2 - x(2)^2];
       
j = @(x) [ 1         -0.25      0;
           2*x(1)   2*x(2) 2*x(3);
          -2*x(1)  -2*x(2)     1];

       
g = @(x) [ x(2)*0.25;
         sqrt(0.5- x(1)^2 - x(3)^2); 
          x(1)^2 + x(2)^2];
      
x0 = [ 0.1; 0.3; 0.3];

A=eye(3);

tol = 1e-12;
maxit = 500;
options = optimset( 'TolX', tol, 'Display', 'iter' );
tic
xa = fsolve( f, x0, options )
ta=toc

% (b) Solve using Newton + exact Jacobian
[ xb, ib, tb ] = newton_exact_jacobian( x0, f, j, maxit, tol );

% (c) Solve using Newton + Constant Jacobian
[ xc, ic, tc ] = newton_constant_jacobian( x0, f, j, maxit, tol );

% (d) Solve using Newton + Constant Inexact Jacobian (forward FD)
delta = 1e-2;
[ xd, id, td ] = newton_constant_inexact_jacobian( x0, f, delta, maxit, tol );
% (e) Solve using Newton +  Inexact Jacobian (forward FD)
delta = 1e-2;
[ xe, ie, te ] = newton_inexact_jacobian( x0, f, delta, maxit, tol );
delta = 1e-2;
% (f) Solve using Quasi Newton Broyden  Inexact Jacobian (forward FD)
[ xf, iff, tf ] = quasi_newton_broyden( x0, f, delta, maxit, tol );
% (g) Solve using Quasi Newton Inverse Broyden  Inexact Jacobian (forward FD)
[ xg, ig, tg ] = quasi_newton_inv_broyden( x0, f, delta, maxit, tol );
% (h) Solve using fixed point method
[ xh, ih, th ] = fixed_point( x0, A, g, maxit, tol );

fprintf( "\nIterations")
fprintf( "\nNewton + Exact Jacobian:          %i", ib )
fprintf( "\nNewton + Constant Jacobian:         %i", ic )
fprintf( "\nNewton + Constant Inexact Jacobian: %i", id )
fprintf( "\nNewton + Inexact Jacobian: %i", ie )
fprintf( "\n Quasi Newton Broyden: %i", iff )
fprintf( "\n Quasi Newton Inverse Broyden: %i", ig )
fprintf( "\n Fixed point: %i", ih )

% Compare the numerical solutions of Newton wrt fsolve
errb = norm( xb - xa, Inf ) / norm( xa, Inf );
errc = norm( xc - xa, Inf ) / norm( xa, Inf );
errd = norm( xd - xa, Inf ) / norm( xa, Inf );
erre = norm( xe - xa, Inf ) / norm( xa, Inf );
errf = norm( xf - xa, Inf ) / norm( xa, Inf );
errg = norm( xg - xa, Inf ) / norm( xa, Inf );
errh = norm( xh - xa, Inf ) / norm( xh, Inf );

fprintf( "\n\nRelative error")
fprintf( "\nNewton + Exact Jacobian:          %e", errb )
fprintf( "\nNewton + Constant Jacobian:         %e", errc )
fprintf( "\nNewton + Constant Inexact Jacobian: %e", errd )
fprintf( "\nNewton + Inexact Jacobian: %e", erre )
fprintf( "\nQuasi Newton Broyden: %e", errf )
fprintf( "\nQuasi Newton Inverse Broyden: %e", errg )
fprintf( "\nFixed point: %e", errh )

% Compare the computational time
fprintf( "\n\nComputational time")
fprintf( "\nfsolve:                           %e", ta )
fprintf( "\nNewton + Exact Jacobian:          %e", tb )
fprintf( "\nNewton + Constant Jacobian:         %e", tc )
fprintf( "\nNewton + Constant Inexact Jacobian: %e", td )
fprintf( "\nNewton + Inexact Jacobian: %e", te )
fprintf( "\nQuasi Newton Broyden: %e", tf )
fprintf( "\nQuasi Newton Inverse Broyden: %e", tg )
fprintf( "\nFixed point: %e\n", th )


%% Exercise 4

clear all
close all
format long

 n = 10;
 d0 = 5* ones( n,1 );
 d1 = - ones( n-1,1 );
 A = diag(d0) + diag(d1,1) + diag(d1,-1);

f = @(x) A*x  -2*sin(x) +pi*ones(n,1);
j= @(x) A  -2*diag(cos(x));
g=@(x)  2*sin(x) -pi*ones(n,1);

% Initial guess
x0 = ones(n,1);

tol = 1e-8;
maxit = 500;

% (a) Solve using fsolve
options = optimset( 'TolX', tol, 'Display', 'iter' );
tic
xa = fsolve( f, x0, options );
ta = toc

% (b) Solve using Newton + exact Jacobian
[ xb, ib, tb ] = newton_exact_jacobian( x0, f, j, maxit, tol );

% (c) Solve using Newton + Constant Jacobian
[ xc, ic, tc ] = newton_constant_jacobian( x0, f, j, maxit, tol );

% (d) Solve using Newton + Constant Inexact Jacobian (forward FD)
delta = 1e-2;
[ xd, id, td ] = newton_constant_inexact_jacobian( x0, f, delta, maxit, tol );
% (e) Solve using Newton +  Inexact Jacobian (forward FD)
delta = 1e-2;
[ xe, ie, te ] = newton_inexact_jacobian( x0, f, delta, maxit, tol );
delta = 1e-2;
% (f) Solve using Quasi Newton Broyden  Inexact Jacobian (forward FD)
[ xf, iff, tf ] = quasi_newton_broyden( x0, f, delta, maxit, tol );
% (g) Solve using Quasi Newton Inverse Broyden  Inexact Jacobian (forward FD)
[ xg, ig, tg ] = quasi_newton_inv_broyden( x0, f, delta, maxit, tol );
% % (h) Solve using fixed point method
[ xh, ih, th ] = fixed_point( x0, A, g,  maxit, tol );

fprintf( "\nIterations")
fprintf( "\nNewton + Exact Jacobian:          %i", ib )
fprintf( "\nNewton + Constant Jacobian:         %i", ic )
fprintf( "\nNewton + Constant Inexact Jacobian: %i", id )
fprintf( "\nNewton + Inexact Jacobian: %i", ie )
fprintf( "\n Quasi Newton Broyden: %i", iff )
fprintf( "\n Quasi Newton Inverse Broyden: %i", ig )
fprintf( "\n Fixed point: %i", ig )

% Compare the numerical solutions of Newton wrt fsolve
errb = norm( xb - xa, Inf ) / norm( xa, Inf );
errc = norm( xc - xa, Inf ) / norm( xa, Inf );
errd = norm( xd - xa, Inf ) / norm( xa, Inf );
erre = norm( xe - xa, Inf ) / norm( xa, Inf );
errf = norm( xf - xa, Inf ) / norm( xa, Inf );
errg = norm( xg - xa, Inf ) / norm( xa, Inf );
errh = norm( xh - xa, Inf ) / norm( xh, Inf );

fprintf( "\n\nRelative error")
fprintf( "\nNewton + Exact Jacobian:          %e", errb )
fprintf( "\nNewton + Constant Jacobian:         %e", errc )
fprintf( "\nNewton + Constant Inexact Jacobian: %e", errd )
fprintf( "\nNewton + Inexact Jacobian: %e", erre )
fprintf( "\nQuasi Newton Broyden: %e", errf )
fprintf( "\nQuasi Newton Inverse Broyden: %e", errg )
fprintf( "\nFixed point: %e", errh )

% Compare the computational time
fprintf( "\n\nComputational time")
fprintf( "\nfsolve:                           %e", ta )
fprintf( "\nNewton + Exact Jacobian:          %e", tb )
fprintf( "\nNewton + Constant Jacobian:         %e", tc )
fprintf( "\nNewton + Constant Inexact Jacobian: %e", td )
fprintf( "\nNewton + Inexact Jacobian: %e", te )
fprintf( "\nQuasi Newton Broyden: %e", tf )
fprintf( "\nQuasi Newton Inverse Broyden: %e", tg )
fprintf( "\nFixed point: %e\n", th )



%% Exercise 6
clear all
close all
format long

n   = 20;
d0  = 10* ones( n,1 );
d1  = - 2*ones( n-1,1 );
d10 = - ones( n-10,1 );
A   = diag(d0) + diag(d1,1) + diag(d1,-1)  + diag(d10,10) + diag(d10,-10);

alpha = 2.5;

f = @(x) A*x -  x / ( norm(x)^alpha ) ; 
g=@(x)  x / ( norm(x)^alpha );


% Initial guess
x0 =  ones(n,1);

tol = 1e-10;
maxit = 500;

% (a) Solve using fsolve
options = optimset( 'TolX', tol, 'Display', 'iter' );
tic
xa = fsolve( f, x0, options );
ta = toc


%
% (d) Solve using Newton + Constant Inexact Jacobian (forward FD)
delta = 1e-2;
[ xd, id, td ] = newton_constant_inexact_jacobian( x0, f, delta, maxit, tol );
% (e) Solve using Newton +  Inexact Jacobian (forward FD)
delta = 1e-2;
[ xe, ie, te ] = newton_inexact_jacobian( x0, f, delta, maxit, tol );
delta = 1e-2;
% (f) Solve using Quasi Newton Broyden  Inexact Jacobian (forward FD)
[ xf, iff, tf ] = quasi_newton_broyden( x0, f, delta, maxit, tol );
% (g) Solve using Quasi Newton Inverse Broyden  Inexact Jacobian (forward FD)
[ xg, ig, tg ] = quasi_newton_inv_broyden( x0, f, delta, maxit, tol );
% % (h) Solve using fixed point method
 [ xh, ih, th ] = fixed_point( x0, A, g,   maxit, tol );

% Checking condition for fixed-point convergence
 
norm(inv(A)*(1-alpha)/(norm(x0)^alpha))
norm(inv(A)*(1-alpha)/(norm(xa)^alpha))

%%
fprintf( "\nIterations")
fprintf( "\nNewton + Constant Inexact Jacobian: %i", id )
fprintf( "\nNewton + Inexact Jacobian: %i", ie )
fprintf( "\n Quasi Newton Broyden: %i", iff )
fprintf( "\n Quasi Newton Inverse Broyden: %i", ig )
fprintf( "\n Fixed point: %i", ih )

% Compare the numerical solutions of Newton wrt fsolve
 
errd = norm( xd - xa, Inf ) / norm( xa, Inf );
erre = norm( xe - xa, Inf ) / norm( xa, Inf );
errf = norm( xf - xa, Inf ) / norm( xa, Inf );
errg = norm( xg - xa, Inf ) / norm( xa, Inf );
errh = norm( xh - xa, Inf ) / norm( xh, Inf );

fprintf( "\n\nRelative error")
 
fprintf( "\nNewton + Constant Inexact Jacobian: %e", errd )
fprintf( "\nNewton + Inexact Jacobian: %e", erre )
fprintf( "\nQuasi Newton Broyden: %e", errf )
fprintf( "\nQuasi Newton Inverse Broyden: %e", errg )
fprintf( "\nFixed point: %e", errh )

% Compare the computational time
fprintf( "\n\nComputational time")
fprintf( "\nfsolve:                           %e", ta )
 
fprintf( "\nNewton + Constant Inexact Jacobian: %e", td )
fprintf( "\nNewton + Inexact Jacobian: %e", te )
fprintf( "\nQuasi Newton Broyden: %e", tf )
fprintf( "\nQuasi Newton Inverse Broyden: %e", tg )
fprintf( "\nFixed point: %e\n", th )
 
