function x = fwsub_band( A, b, p )
% Forward substitution algorithm
% A     Lower triangular matrix
% b     Right hand side
% p     Bandwidth
% x     Solution of the linear system A * x = b

if size(A,1) == size(A,2)
    if A == tril(A)
        n = size(A,1);

        x = zeros(n,1);
        x(1) = b(1) / A(1,1);
        for i = 2:n
            x(i) = ( b(i) - A(i,max(i-p,1):i-1) * x(max(i-p,1):i-1) ) / A(i,i);
        end
    else
        fprintf('A is not lower triangular!\n')
    end
else
    fprintf('A is not a square matrix!\n')
end
    
end