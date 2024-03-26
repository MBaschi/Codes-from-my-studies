function L = chol_band(A, bw)

% Function implementing Cholesky decomposition
% For version for banded matrices, input bw>0

n=size(A,1);
L=zeros(n);
L(1,1)= sqrt(A(1,1));

if(bw)
    
    for i=2:n
        ii=max(i-bw,1);
        for j=ii:i-1
            L(i,j)=...
                (A(i,j)-L(i,1:j-1)*L(j,1:j-1)')/L(j,j);
        end
        L(i,i)=sqrt(A(i,i) -L(i,1:i-1)*L(i,1:i-1)' );
    end
    
else
    
    for i=2:n
        for j=1:i-1
            L(i,j)=...
                (A(i,j)-L(i,1:j-1)*L(j,1:j-1)')/L(j,j);
        end
        L(i,i)=sqrt(A(i,i) -L(i,1:i-1)*L(i,1:i-1)' );
    end
    
    
end

end

