
function [x] = fwsub(L,b)
%funzione per il metodo forward subtitution
%passo una matrice low diagonal e restituisco la soluzione 
D=size(L);
n=D(1);

x=ones(n,1);
x(1)=b(1)/L(1,1);


for i=2:n
    sum=0;
    
    for j=1:i-1
      sum=L(i,j)*x(j)+sum;  
    end
    
    x(i)=(b(i)-sum)/L(i,i);
end 
end

