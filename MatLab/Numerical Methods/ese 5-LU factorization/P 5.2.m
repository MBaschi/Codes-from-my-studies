clear all
close all
disp("_____________")
A=[10 2 3 4 5
    2 10 2 3 4
    3 2 10 2 3 
    4 3 2 10 2 
    5 4 3 2 10];
[L,U]=lu(A);
detLU=det(L)*det(U)
det(A)