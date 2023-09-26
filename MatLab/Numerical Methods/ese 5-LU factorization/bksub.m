function [x] = bksub(U,b)
%check the condition
if size(U,1)~=size(U,2)
    error("the matrix is not square")
end 

if tril(U,1)~=zeros(size(U,1))
    error("the matriz is not a lower triangular")
end
    
for i=1:size(U,1)
    if U(i,i)==0
        error("the matrix dosen't respect the hypotesis")
    end 
end 

%compute the algorithm
n=size(U,1);
x=ones(n,1);
x(n)=b(n)/U(n,n);

for i=n-1:1
    sum=0;
    for j=i+1:n
        sum=sum+x(j)*L(i,j);
    end 
    x(i)=(b(i)-sum)/L(i,i);
end 
end

