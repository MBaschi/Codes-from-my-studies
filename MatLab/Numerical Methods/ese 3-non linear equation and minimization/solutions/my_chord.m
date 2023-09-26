function [ x, it, t ] = my_chord( x0, f, a, b, maxit, tol )

x = x0;

tic
for it = 1 : maxit
    dx = - (b-a) * f(x) / (f(b) - f(a));
    % Stop criterium
    if norm( dx, Inf ) < tol
        break;
    end
    x = x + dx;    
end
t = toc;

if it == maxit, fprintf( "Chord method did not converge!\n" ), end

end