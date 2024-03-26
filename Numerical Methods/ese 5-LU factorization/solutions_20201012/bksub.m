function x = bksub( A, b )
% Backward substitution algorithm
% A     Upper triangular matrix
% b     Right hand side
% x     Solution of the linear system A * x = b

if size(A,1) == size(A,2)
    if A == triu(A)
        n = size(A,1);

        x = zeros(n,1);
        x(n) = b(n) / A(n,n);
        for i = n-1 : -1 : 1
            x(i) = ( b(i) - A(i,i+1:n) * x(i+1:n) ) / A(i,i);
        end
    else
        fprintf('A is not lower triangular!\n')
    end
else
    fprintf('A is not a square matrix!\n')
end

end