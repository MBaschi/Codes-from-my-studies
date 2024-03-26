function [L,U] = lu_band_t(A)
% Function implementing LU factorization for tridiagonal matrices
n=size(A);

L=zeros(n);
U=zeros(n);

U(1,1)=A(1,1);
L(1,1)=1;
for k = 2:n
    L(k,k-1) = A(k,k-1)/U(k-1,k-1);
    U(k,k)   = A(k,k) - A(k-1,k)*L(k,k-1);
    L(k,k)   = 1;
    U(k-1,k) = A(k-1,k);
end

