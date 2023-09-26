function [x] = bksub(U,b)
%funzione per il metodo bakward subtitution
%passo una matrice up diagonal e restituisco la soluzione 
D=size(L);
n=D(1); %dimensione dell matrice data

x=ones(n,1);
x(n)=b(n)/U(n,n);


for i=n-1:1
    sum=0; 
    
    for j=n:n-i
      sum=L(i,j)*x(j)+sum;  
    end
    
    x(i)=(b(i)-sum)/L(i,i);
end 
end

