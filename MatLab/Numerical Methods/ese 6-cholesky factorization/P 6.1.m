clear all
close all
disp("__________")

A=[5 4 3 2 1 
   4 5 4 3 2 
   3 4 5 4 3
   2 3 4 5 4
   1 2 3 4 5];
xex=[1 2 3 4 5]';
b=A*xex;

if A==A'
    if min(eig(A))>0
        %a)
        [L,U,P]=lu(A); %P= identitty matrix so no pivoting 
        if isequal(P,eye(size(A,1)))
            disp("no pivoting")
        else
            disp("pivoting has been curried out")
        end 
        y=L\b;
        x=U\y;
        reler_2_a=norm(xex-x)/norm(xex);
        reler_inf_a=norm(xex-x,inf)/norm(xex,inf);
        abser_2_a=norm(xex-x);
        abser_inf_a=norm(xex-x,inf);
        
        %b)
        Lc=chol(A);
        y=Lc'\b;
        xc=Lc\y;
        if isequal(L,Lc)
            disp("L=Lc")
        else 
            disp("L~=Lc")
        end 
        
        reler_2_b=norm(xex-xc)/norm(xex);
        reler_inf_b=norm(xex-xc,inf)/norm(xex,inf);
        abser_2_b=norm(xex-xc);
        abser_inf_b=norm(xex-xc,inf);
    else
       disp("the matrix is not positive definite")
    end 
    
else
    disp("the matrix is not simmetric")
end 

%20 min