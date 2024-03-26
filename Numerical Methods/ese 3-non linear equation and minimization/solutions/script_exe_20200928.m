% Script lecture 280920


%% Exercise 1
clear all
close all
format long

fprintf('Exercise 1\n\n')

f = @(x) x.^2 - x + 1 - exp(-x);

x_pl = -2:0.01:1; 

% (a) Plot

figure()
plot(x_pl, f(x_pl), 'LineWidth', 3)
grid on
xlabel('x')
ylabel('f(x)')

x0 = -1.7;
tol = 10^(-10);
tolfun = 10^(-12);

% (b) Solve using fsolve

options = optimoptions('fsolve','TolX', tol, 'TolFun', tolfun);
options = optimset('TolX', tol, 'TolFun', tolfun);

tic;
xb = fsolve(f, x0, options);
time_f=toc;

fprintf('Initial guess x0 = %f, fsolve method found zero of function f at x=%f in %f s.\n', x0, xb, time_f)

%% (c) Newton method

x0 = -1.7;

j = @(x) 2.*x - 1 + exp(-x);

[xc, it_n, time_n] = my_newton(x0, f, j, 100, tol);

fprintf('Initial guess x0 = %f, Newton''s method found zero of function f at x=%f in %d iterations and %f s.\n', x0, xc, it_n, time_n)


%% Exercise 2

clear all
close all

fprintf('Exercise 2\n\n')

f = @(x) x.^4 - x.^3 - 7*x.^2 + x + 6; 

g = @(x) x.^4 - 3*x.^3 - 3*x.^2 + 11*x - 6;


x_pl = -3:0.01:4;

% (a) Plot

figure()
plot(x_pl, f(x_pl), 'k--', 'LineWidth', 3)
hold on
plot(x_pl, g(x_pl), 'k-', 'LineWidth', 3)
grid on
legend('f', 'g')
xlabel('x')
ylabel('f(x)')

% (b) Newton's method

x0 = 0.0;
tol = 10^(-10);

jf = @(x) 4*x.^3 - 3*x.^2 -14.*x + 1;

jg = @(x) 4*x.^3 - 9*x.^2 -6.*x + 11;

[xcf, itbf, time_bf] = my_newton(x0, f, jf, 100, tol);

[xcg, itbg, time_bg] = my_newton(x0, g, jg, 100, tol);

fprintf('Initial guess x0 = %f, Newton''s method found zero of function f at x=%f in %d iterations and %f s.\n', x0, xcf, itbf, time_bf)
fprintf('Initial guess x0 = %f, Newton''s method found zero of function g at x=%f in %d iterations and %f s.\n', x0, xcg, itbg, time_bg)

% (d) fsolve

options = optimset('TolX', tol);

tic
xdf = fsolve(f, x0, options);
time_f = toc;

tic
xdg = fsolve(g, x0, options);
time_g = toc;

fprintf('Initial guess x0 = %f, fsolve found zero of function f at x=%f in %f s.\n', x0, xdf, time_f)
fprintf('Initial guess x0 = %f, fsolve found zero of function g at x=%f in %f s.\n', x0, xdg, time_g)

%% Exercise 3.1
clear all
close all

disp('Exercise 3.1\n\n')

f  = @(x) x.^2 - x + 1 - exp(-x);
df = @(x) 2*x - 1 + exp(-x);

x_pl = -2:0.01:1; 

% (a) Plot

figure()
plot(x_pl, f(x_pl), 'LineWidth', 3)
grid on
xlabel('x')
ylabel('f(x)')

x0 = -1.7;
tol = 10^(-8);

gamma = .1;
maxit = 100;

phi  = @(x) abs(f(x)).^2;
dphi = @(x) 2*f(x).*df(x);

% Basic version, fixed gamma
modified = 0;

tic
[x_out, it_grad] = my_steepest_descent(x0, phi, dphi, gamma, maxit, tol, modified);
time=toc;

fprintf('Steepest descent method converged to x =%f in %d iterations and %f s.\n', x_out, it_grad, time)

% Modified version
modified = 1;

tic
[x_out, it_grad] = my_steepest_descent(x0, phi, dphi, gamma, maxit, tol, modified);
time=toc;

fprintf('Modified steepest descent method converged to x =%f in %d iterations and %f s.\n', x_out, it_grad, time)


%% Exercise 3.2
clear all
close all
disp('Exercise 3.2\n\n')

f2  = @(x) x.^4 - x.^3 - 7*x.^2 + x + 6; 
df2 = @(x) 4*x.^3 - 3*x.^2 - 14*x + 1;

g2  = @(x) x.^4 - 3*x.^3 - 3*x.^2 + 11*x - 6;
dg2 = @(x) 4*x.^3 - 9*x.^2 - 6*x + 11;


x_pl = -3:0.01:4;

figure()
plot(x_pl, f2(x_pl), 'k--', 'LineWidth', 3)
hold on
plot(x_pl, g2(x_pl), 'k-', 'LineWidth', 3)
grid on
legend('f', 'g')
xlabel('x')
ylabel('f(x)')

x0 = 0.0;
tol = 10^(-8);

gamma = .01;
maxit = 1000;

phif2 = @(x) abs(f2(x)).^2;
phidf2 = @(x) 2*f2(x)*df2(x);

phig2 = @(x) abs(g2(x)).^2;
phidg2 = @(x) 2*g2(x)*dg2(x);

% Basic version, fixed gamma
modified = 0;

tic;
[xf2, itf2] = my_steepest_descent(x0, phif2, phidf2, gamma, maxit, tol, modified);
tf2=toc;
if(itf2~=maxit), fprintf('Initial guess x0 = %f, steepest descent method found zero of function f2 at x=%f in %d iterations and %f s\n', x0, xf2, itf2, tf2), end

%
tic;
[xg2, itg2] = my_steepest_descent(x0, phig2, phidg2, gamma, maxit, tol, modified);
tg2=toc;
if(itg2~=maxit), fprintf('Initial guess x0 = %f, steepest descent method found zero of function g2 at x=%f in %d iterations and %f s\n', x0, xg2, itg2, tg2), end

%%
% Modified version, adaptive gamma
modified = 1;

tic;
[xf2, itf2] = my_steepest_descent(x0, phif2, phidf2, gamma, maxit, tol, modified);
tf2=toc;
if(itf2~=maxit), fprintf('Initial guess x0 = %f, modified steepest descent method found zero of function f2 at x=%f in %d iterations and %f s\n', x0, xf2, itf2, tf2), end

tic;
[xg2, itg2] = my_steepest_descent(x0, phig2, phidg2, gamma, maxit, tol, modified);
tg2=toc;
if(itg2~=maxit), fprintf('Initial guess x0 = %f, modified steepest descent method found zero of function g2 at x=%f in %d iterations and %f s\n', x0, xg2, itg2, tg2), end


%% Exercise 4.1

clear all
close all

disp('Exercise 4.1\n\n')

f1 = @(x) x.^2 - x + 1 - exp(-x);

x0 = -1.7;
tol = 10^(-10);
a = -1.9;
b =  -1.6;
maxit=100;

[ xc, itc, tc ] = my_chord( x0, f1, a, b, maxit, tol );

if(itc~=maxit), fprintf('Initial guess x0 = %f, chord method found zero of function f1 at x=%f in [%f,%f] in %d iterations and %f s\n', x0, xc, a, b, itc, tc), end

x1 = -1.6;

[ xs, its, ts ] = my_secant( x0, x1, f1, maxit, tol );

if(its~=maxit), fprintf('Initial guesses x0 = %f, x1 = %f, secant method found zero of function f1 at x=%f in %d iterations and %f s\n', x0, x1, xs, its, ts), end

inc = 0.01;

[ xmn, itmn, tmn ] = my_mod_newton( x0, f1, inc, maxit, tol );

if(itmn~=maxit), fprintf('Initial guess x0 = %f, increment inc = %f, modified Newton method found zero of function f1 at x=%f in %d iterations and %f s\n', x0, inc, xmn, itmn, tmn), end


%% Exercise 4.2
clear all
close all

disp('Exercise 4.2\n\n')

f2 = @(x) x.^4 - x.^3 - 7*x.^2 + x + 6; 

g2 = @(x) x.^4 - 3*x.^3 - 3*x.^2 + 11*x - 6;

x0 = 0.0;
a  = -1.1;
b  = 0.1;
maxit = 100;
tol   = 10^(-10);

[ xcf2, itcf2, tcf2 ] = my_chord( x0, f2, a, b, maxit, tol );
if(itcf2~=maxit), fprintf('Initial guess x0 = %f, chord method found zero of function f2 at x=%f in [%f,%f] in %d iterations and %f s\n', x0, xcf2, a, b, itcf2, tcf2), end

[ xcg2, itcg2, tcg2 ] = my_chord( x0, g2, a, b, maxit, tol );
if(itcg2~=maxit), fprintf('Initial guess x0 = %f, chord method found zero of function g2 at x=%f in [%f,%f] in %d iterations and %f s\n', x0, xcg2, a, b, itcg2, tcg2), end

x1 = -1.6;

[ xsf2, itsf2, tsf2 ] = my_secant( x0, x1, f2, maxit, tol );

if(itsf2~=maxit), fprintf('Initial guesses x0 = %f, x1 = %f, secant method found zero of function f2 at x=%f in %d iterations and %f s\n', x0, x1, xsf2, itsf2, tsf2), end

[ xsg2, itsg2, tsg2 ] = my_secant( x0, x1, g2, maxit, tol );

if(itsg2~=maxit), fprintf('Initial guesses x0 = %f, x1 = %f, secant method found zero of function g2 at x=%f in %d iterations and %f s\n', x0, x1, xsg2, itsg2, tsg2), end

inc = 0.01;

[ xmnf2, itmnf2, tmnf2 ] = my_mod_newton( x0, f2, inc, maxit, tol );

if(itmnf2~=maxit), fprintf('Initial guess x0 = %f, increment inc = %f, modified Newton method found zero of function f2 at x=%f in %d iterations and %f s\n', x0, inc, xmnf2, itmnf2, tmnf2), end

[ xmng2, itmng2, tmng2 ] = my_mod_newton( x0, g2, inc, maxit, tol );

if(itmng2~=maxit), fprintf('Initial guess x0 = %f, increment inc = %f, modified Newton method found zero of function g2 at x=%f in %d iterations and %f s\n', x0, inc, xmng2, itmng2, tmng2), end


%% Exercise 5
clear all
close all

disp('Exercise 5\n\n')

phi = @(x) (1-exp(-x.^2)).*sin(3*x);
dphi = @(x) 2*x.*exp(-x.^2).*sin(3*x)...
    +3*(1-exp(-x.^2)).*cos(3*x);

x_pl = -3:.01:3;

set(0,'defaultTextInterpreter','latex');

% (a) Plot

figure()
plot(x_pl, phi(x_pl), 'LineWidth', 3)
xlabel('$x$')
ylabel('$\phi(x)$')
grid on

% (b) Find local minima with modified gradient method, tol E-09

x0 = -1.0;
tol = 10^(-9);

gamma = 1;
maxit = 1000;

modified = 1;

tic;
[xphi, itphi] = my_steepest_descent(x0, phi, dphi, gamma, maxit, tol, modified);
tphi=toc;
if(itphi~=maxit), fprintf('Initial guess x0 = %f, modified steepest descent method found minimum of function phi at x=%f in %d iterations and %f s\n', x0, xphi, itphi, tphi), end

