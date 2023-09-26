function [x] = fwsub(L,b)
%check the condition
if size(L,1)~=size(L,2)
    error("the matrix is not square")
end 

if triu(L,1)~=zeros(size(L,1))
    error("the matriz is not a lower triangular")
end
    
for i=1:size(L,1)
    if L(i,i)==0
        error("the matrix dosen't respect the hypotesis")
    end 
end 

%compute the algorithm
x=ones(size(L,1),1);
x(1)=b(1)/L(1,1);

for i=2:size(L,1)
    sum=0;
    for j=1:i-1
        sum=sum+x(j)*L(i,j);
    end 
    x(i)=(b(i)-sum)/L(i,i);
end 

end

