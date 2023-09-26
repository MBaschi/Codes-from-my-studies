%Exercise session 20201116

%% Exercise 1

clear all
close all
format long

f  = @(x) (1-x(1)).^2 + 4*(x(2)-x(1).^2).^2;
df = @(x) [2*(8*x(1).^3 - 8*x(1)*x(2) + x(1) - 1); 8*(x(2)- x(1).^2)];
ddf = @(x) [-16*(x(2) - x(1).^2)+32*x(1).^2+2, -16*x(1); 
            -16*x(1),                           8];    

% f  = @(x) (1-x(1)).^2 + 100*(x(2)-x(1).^2).^2;
% df = @(x) [2*(200*x(1).^3 - 200*x(1).*x(2) + x(1) - 1); 200*(x(2)- x(1).^2)];
% ddf = @(x) [-800*(x(2) - x(1).^2)+1600*x(1).^2+2, -800*x(1); 
%             -800*x(1),                           400];    
        
        
x_pl = 0:.1:4;
y_pl = 0:.1:4;
x0  = [0;0];
tol=10^(-8);

% (a) Plot

ff  = @(x,y) (1-x).^2 + 100*(y-x.^2).^2;
dffx = @(x,y) 2*(200*x.^3 - 200*x.*y + x - 1);
dffy = @(x,y) 200*(y- x.^2);
[X,Y] = meshgrid(x_pl,y_pl);
 
contourf(X, Y, ff(X,Y))
colorbar

% (b) solve with fminsearch
tic
[xa,fval, exitflag, output]  = fminsearch(f, x0, optimset( 'TolFun', tol, 'Display', 'iter' ))
ta=toc
it_a=output.iterations

% (c) solve with modified gradient method

gamma = .1;
maxit = 100000;

% Basic version, fixed gamma
modified = 1;
tic
[xb, it_b] = my_steepest_descent(x0, f, df, gamma, maxit, tol, modified);
tb=toc
fprintf('Steepest descent method found minimum of f at x =(%f, %f) in %d iterations.\n\n', xb, it_b)

% (d) solve with Newton
tic
[xc, it_c] = my_newton(x0, df, ddf, 1000, tol);
tc=toc
fprintf('Initial guess x0 = (%f,%f), Newton''s method found minimum of f at x=(%f,%f) in %d iterations.\n', x0, xc, it_c)

% (e) solve with BFGS

gamma=0;
tic
[xd, it_d] = my_bfgs(x0, f, df, ddf, maxit, tol, gamma);
td=toc
fprintf('Initial guess x0 = (%f,%f), BFGS''s method found minimum of f at x=(%f,%f) in %d iterations.\n', x0, xd, it_d)


%% Exercise 2 

clear all
close all
format long

f  = @(x) (x(1).^2 + x(2).^2).^2 - 15*(4*x(1).^2+.25*x(2).^2)+20*x(1)+5*x(2);
df = @(x) [4*(x(1).^3+x(1).*(x(2).^2-30)+5); 4*x(2).*(x(1).^2+x(2).^2)-7.5*x(2)+5] ;
ddf = @(x) [ 4*(x(1).^2+x(2).^2)+8*x(1).^2-120,                      8*x(1).*x(2); 
                                  8*x(1).*x(2), 4*(x(1).^2+x(2).^2)+8*x(2).^2-7.5];    

x_pl = -7:.1:7;
y_pl = -7:.1:7;
x0  = [5;0];
tol=10^(-12);


ff  = @(x,y) (x.^2 + y.^2).^2 - 15*(4*x.^2+.25*y.^2)+20*x+5*y;
[X,Y] = meshgrid(x_pl,y_pl);
 
surf(X, Y, ff(X,Y))
colorbar

% (b) solve with fminsearch
tic
[xa,fval, exitflag, output]  = fminsearch(f, x0, optimset( 'TolFun', tol, 'Display', 'iter' ))
ta=toc
it_a=output.iterations

% (b) solve with modified gradient method

gamma = .1;
maxit = 10000;

% Basic version, fixed gamma
modified = 1;
tic
[xb, it_b] = my_steepest_descent(x0, f, df, gamma, maxit, tol, modified);
tb=toc
fprintf('Steepest descent method found minimum of f at x =(%f, %f) in %d iterations.\n\n', xb, it_b)

% (c) solve with Newton
tic
[xc, it_c] = my_newton(x0, df, ddf, maxit, tol);
tc=toc
fprintf('Initial guess x0 = (%f,%f), Newton''s method found minimum of f at x=(%f,%f) in %d iterations.\n', x0, xc, it_c)

% (d) solve with BFGS

gamma=0;
tic
[xd, it_d] = my_bfgs(x0, f, df, ddf, maxit, tol, gamma);
td=toc
fprintf('Initial guess x0 = (%f,%f), BFGS''s method found minimum of f at x=(%f,%f) in %d iterations.\n', x0, xd, it_d)

%% Exercise 3

clear all
close all
format long

n = 100;
d0 = 5* ones( n,1 );
d1 = - ones( n-1,1 );
A = diag(d0) + diag(d1,1) + diag(d1,-1);

f=@(x) A*x - 2*sin(x) + pi*ones(n,1);
j=@(x) A - 2*diag(cos(x));
h=@(x) 2*diag(sin(x));
%g=@(x) 2*sin(x) - pi*ones(n,1);

phi=@(x) norm(f(x)).^2; 
dphi = @(x) 2*j(x)'*f(x);
ddphi = @(x) 2*(j(x)'*j(x) + diag(f(x))*h(x));

% Initial guess
x0 = ones(n,1);

tol = 1e-8;
maxit = 500;


% (b) solve with fminsearch
tic
[xa,fval, exitflag, output]  = fminsearch(phi, x0, optimset( 'TolX', tol))
ta=toc
it_a=output.iterations

% (b) solve with modified gradient method

gamma = .1;
maxit = 10000;

% Basic version, fixed gamma
modified = 1;

tic
[xb, it_b] = my_steepest_descent(x0, phi, dphi, gamma, maxit, tol, modified);
tb=toc
fprintf('Steepest descent method found minimum of phi in %d iterations.\n\n', it_b)

% (c) solve with Newton
tic
[xc, it_c] = my_newton(x0, dphi, ddphi, 1000, tol);
tc=toc
fprintf('Newton''s method found minimum of phi in %d iterations.\n', it_c)

% (d) solve with BFGS

maxit=1000;
gamma=0;
tic
[xd, it_d] = my_bfgs(x0, phi, dphi, ddphi, maxit, tol, gamma);
td=toc
fprintf('BFGS method found minimum of phi in %d iterations.\n', it_d)


