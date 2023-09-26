%% Exe 1

format long
clear all
close all

N   = 5;
A   = eye(N) + hilb(N);
xex = -ones(N,1);
b   = A*xex;

tol = 1e-13;
maxit = 100;

my_CG = 0; % use own implementation of CG yes/no (if yes, use xex+1 as initial guess throughout)

% (a) CG
tic
if(my_CG)
    [x,flag,relres,iter] = pcg(A,b,tol,maxit, [], [], xex+1);
else
    [x,flag,relres,iter] = pcg(A,b,tol,maxit);
end
t_cg=toc;
rel_err2_cg = norm(x-xex)/norm(xex);
if(flag==0)
    fprintf("CG converged in %f seconds and %d iterations, normalized residual %e, relative error %e.\n", t_cg, iter, relres, rel_err2_cg)
elseif(flag==1)
    fprintf("CG did not converge in %d iterations.\n.", maxit)
elseif(flag==3)
    fprintf("CG stagnated.\n")
end

% (b) PCG
tic
M=diag(diag(A));
if(my_CG)
    [x,flag,relres,iter] = pcg(A,b,tol,maxit,M,eye(N), xex+1);
else
    [x,flag,relres,iter] = pcg(A,b,tol,maxit,M,eye(N));
end
t_pcg=toc;
rel_err2_pcg = norm(x-xex)/norm(xex);
if(flag==0)
    fprintf("PCG converged in %f seconds and %d iterations, normalized residual %e, relative error %e.\n", t_pcg, iter, relres, rel_err2_pcg)
elseif(flag==1)
    fprintf("PCG did not converge in %d iterations.\n\n", maxit)
elseif(flag==3)
    fprintf("PCG stagnated.\n")
end

if (my_CG)

% (c) my CG
tic
[x,flag,iter,rr_vec] = conjgrad(A,b,xex+1,eye(N),maxit,tol);
t_cg=toc;
rel_err2_cg = norm(x-xex)/norm(xex);
if(flag==0)
    fprintf("MyCG converged in %f seconds and %d iterations, normalized residual %e, relative error %e.\n\n", t_cg, iter, rr_vec(end), rel_err2_cg)
elseif(flag==1)
    fprintf("MyCG did not converge in %d iterations.\n\n", maxit)
end

end

%% Exe 2

clear all
close all
format long

my_CG = 0; % use own implementation of CG yes/no (if yes, use xex+1 as initial guess throughout)

point = 'a'; % Select one of 'a', 'd', 'e1', 'e2'

if strcmp(point,'a')
    
    N  = 800;
    v  = 12*ones(N,1);
    A  = diag(v)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80);
    
    A = sparse(A);
    M = diag(v);
    
    xex = ones(N,1);
    b = A*xex;
    
elseif strcmp(point,'d')
    
    N=800;
    v=12*[1:N]';
    
    A=diag(v,0)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80);%...
    
    A = sparse(A);
    M = diag(v);
    xex = ones(N,1);
    b = A*xex;
    
elseif strcmp(point,'e1')
    
    N=8000;
    v=12*ones(N,1);
    A=sparse(diag(v,0)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80)...
        -diag(ones(N-2000,1),-2000)-diag(ones(N-2000,1),2000));
    
    M = spdiags(v,0,N,N);
    
    xex = ones(N,1);
    b = A*xex;
    
elseif strcmp(point,'e2')
    
    
    N=8000;
    v=12*[1:N]';
    A=sparse(diag(v,0)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80)...
        -diag(ones(N-2000,1),-2000)-diag(ones(N-2000,1),2000));
    
    xex = ones(N,1);
    b = A*xex;
    M = spdiags(v,0,N,N);
    
end

tol = 1e-13;
maxit = 300;

%  CG
tic
if(my_CG)
    [x,flag,relres,iter] = pcg(A,b,tol,maxit,[],[],xex+1);
else
    [x,flag,relres,iter] = pcg(A,b,tol,maxit);
end
t_cg=toc;
rel_err2_cg = norm(x-xex)/norm(xex);
if(flag==0)
    fprintf("CG converged in %f seconds %d iterations, normalized residual %e, relative error %e.\n", t_cg, iter, relres, rel_err2_cg)
elseif(flag==1)
    fprintf("CG did not converge in %d iterations.\n", maxit)
elseif(flag==3)
    fprintf("CG stagnated.\n")
end

% PCG
tic
M=diag(diag(A),0);
if(my_CG)
    [x,flag,relres,iter] = pcg(A,b,tol,maxit, M, eye(N), xex+1);
else
    [x,flag,relres,iter] = pcg(A,b,tol,maxit, M);
end
t_pcg=toc;
rel_err2_pcg = norm(x-xex)/norm(xex);
if(flag==0)
    fprintf("PCG converged in %f seconds and %d iterations, normalized residual %e, relative error %e.\n", t_pcg, iter, relres, rel_err2_pcg)
elseif(flag==1)
    fprintf("PCG did not converge in %d iterations.\n.", maxit)
elseif(flag==3)
    fprintf("PCG stagnated.\n")
end

if(my_CG)
    % (c) my CG
    tic
    [x,flag,iter,rr_vec] = conjgrad(A,b,xex+1,M,maxit,tol);
    t_cg=toc;
    rel_err2_cg = norm(x-xex)/norm(xex);
    if(flag==0)
        fprintf("MyCG converged in %f seconds and %d iterations, normalized residual %e, relative error %e.\n\n", t_cg, iter, rr_vec(end), rel_err2_cg)
    elseif(flag==1)
        fprintf("MyCG did not converge in %d iterations.\n\n", maxit)
    end
end

% Cholesky
tic
L=chol(A,'lower');
y=L\b;
x=L'\y;
t_ch=toc;
rel_err2_chol = norm(x-xex)/norm(xex);
fprintf("Cholesky error: %e, execution time: %f seconds.\n\n", rel_err2_chol, t_ch)



%% Exe 3

clear all
close all
format long

point = 'a'; % Select one of 'a', 'd', 'e1', 'e2'

if strcmp(point,'a')
    
    N  = 800;
    v  = 12*ones(N,1);
    A  = diag(v)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80)...
        +diag(ones(N-400,1), 400);   
     
    M = diag(v);
    
    xex = ones(N,1);
    b = A*xex;
    
elseif strcmp(point,'d')
    
    N=800;
    v=12*[1:N]';
    A=diag(v,0)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80)...
        +diag(ones(N-400,1), 400);   
    
    M = diag(v);
    xex = ones(N,1);
    b = A*xex;
    
elseif strcmp(point,'e1')
    
    N=8000;
    v=12*ones(N,1);
    A=sparse(diag(v,0)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80)...
        -diag(ones(N-2000,1),-2000)-diag(ones(N-2000,1),2000))...
        +diag(ones(N-4000,1), 4000);
    
    M = spdiags(v,0,N,N);
    
    xex = ones(N,1);
    b = A*xex;
    
elseif strcmp(point,'e2')
    
    
    N=8000;
    v=12*[1:N]';
    A=sparse(diag(v,0)...
        -diag(ones(N-10,1),-10)-diag(ones(N-10,1),10)...
        -diag(ones(N-20,1),-20)-diag(ones(N-20,1),20)...
        -diag(ones(N-80,1),-80)-diag(ones(N-80,1),80)...
        -diag(ones(N-2000,1),-2000)-diag(ones(N-2000,1),2000))...
        +diag(ones(N-4000,1), 4000);
    
    xex = ones(N,1);
    b = A*xex;
    M = spdiags(v,0,N,N);
    
end

tol = 1e-13;
maxit = 300;

% GMRES
tic
restart_val=32;
[x,flag,relres,iter,resvec] = gmres(A,b,restart_val,tol,maxit);
t_gmres=toc;
rel_err2_gmres = norm(x-xex)/norm(xex);

if(flag==0)
    fprintf("GMRES:\n Converged in %f seconds and %d iterations\n Residual: %e\n2-norm error: %e\n\n", t_gmres, length(resvec), relres, rel_err2_gmres)
elseif(flag==1)
    fprintf("GMRES did not converge in %d iterations.\n.", maxit)
elseif(flag==3)
    fprintf("GMRES stagnated.\n")
end


% PGMRES
M=diag(diag(A));
tic
restart_val=32;
[x,flag,relres,iter,resvec] = gmres(A,b,restart_val,tol,maxit, M);
t_pgmres=toc;
rel_err2_pgmres = norm(x-xex)/norm(xex);

if(flag==0)
    fprintf("PGMRES:\n Converged in %f seconds and %d iterations\n Residual: %e\n2-norm error: %e\n\n", t_pgmres, length(resvec), resvec(end), rel_err2_pgmres)
elseif(flag==1)
    fprintf("PGMRES did not converge in %d iterations.\n.", maxit)
elseif(flag==3)
    fprintf("PGMRES stagnated.\n")
end


% LU
tic
[L,U,P]=lu(A);
y=L\(P*b);
x=U\y;
t_lu=toc;
rel_err2_lu = norm(x-xex)/norm(xex);
fprintf("LU error: %e, Execution time: %f seconds.\n\n", rel_err2_lu, t_lu)


%% Exercise 4/5
clear all
close all
format long

ex5 = 0; % Select one of '0: exercise 4, 1: exercise 5'

if(~ex5)
    N = 200;
else
    N = 5000;
end
m = 5;
Af=zeros(N*m);

if(~ex5)
    B = [10 3 4 1 1;
        3 30 2 2 2;
        4 2 50 3 4;
        1 2 3 30 4;
        1 2 4  4 10];
    
else
    B = [10 3 4 1 1;
        3 300 2 2 2;
        4 2 500 3 4;
        1 2 3 3000 5;
        1 2 4  4 10^7];
end

for i=1:N
    Af(m*(i-1)+1:m*i, m*(i-1)+1:m*i)= B;
end

if(ex5)
    Af = Af + diag(ones(N*m-2000,1), 2000) - diag(0.025*ones(N*m-3000,1), -3000);
end
A = sparse(Af);

xex = repmat([2;-3], N*m/2,1);

b = A*xex;

apriori = condest(A)*eps;

maxit = 300;
tol=10^(-12);

fprintf("Apriori estimate: %e\n\n", apriori)

% Backslash
tic
x=A\b;
t_bs=toc;
rel_err1_bs = norm(x-xex,1)/norm(xex,1);
rel_err2_bs = norm(x-xex)/norm(xex);
rel_errinf_bs = norm(x-xex, inf)/norm(xex, inf);
apost_bs = condest(A)*norm(b-A*x,1)/norm(b,1);
fprintf("Backslash:\n 1-norm error: %e\n 2-norm error: %e\ninf-norm error: %e\n apost_est: %e\n Execution time: %f seconds.\n\n", rel_err1_bs, rel_err2_bs, rel_errinf_bs, apost_bs, t_bs)



if(~ex5)

    my_CG = 1; % use own implementation of CG yes/no (if yes, use xex+1 as initial guess throughout)
    
    % Cholesky
    tic
    L=chol(A,'lower');
    y=L\b;
    x=L'\y;
    t_ch=toc;
    rel_err1_chol = norm(x-xex,1)/norm(xex,1);
    rel_err2_chol = norm(x-xex)/norm(xex);
    rel_errinf_chol = norm(x-xex, inf)/norm(xex, inf);
    apost_ch = condest(A)*norm(b-A*x,1)/norm(b,1);
    fprintf("Cholesky:\n 1-norm error: %e\n 2-norm error: %e\ninf-norm error: %e\n apost_est: %e\n Execution time: %f seconds\n\n", rel_err1_chol, rel_err2_chol, rel_errinf_chol, apost_ch, t_ch)

    % CG
    tic
    if(my_CG)
        [x,flag,relres,iter] = pcg(A,b,tol,maxit,[],[],xex+1);
    else
        [x,flag,relres,iter] = pcg(A,b,tol,maxit);
    end
    t_cg=toc;
    rel_err1_cg = norm(x-xex,1)/norm(xex,1);
    rel_err2_cg = norm(x-xex)/norm(xex);
    rel_errinf_cg = norm(x-xex, inf)/norm(xex, inf);
    apost_cg = condest(A)*norm(b-A*x,1)/norm(b,1);
    if(flag==0)
        fprintf("CG:\n Converged in %f seconds and %d iterations\n Residual: %e\n1-norm error: %e\n2-norm error: %e\ninf-norm error: %e\n apost_est: %e\n\n", t_cg, iter, relres, rel_err1_cg, rel_err2_cg, rel_errinf_cg, apost_cg)
    elseif(flag==1)
        fprintf("CG did not converge in %d iterations.\n.", maxit)
    elseif(flag==3)
        fprintf("CG stagnated.\n")
    end
    
    % PCG
    M=diag(diag(A));
    tic
    if(my_CG)
        [x,flag,relres,iter] = pcg(A,b,tol,maxit,M,eye(N*m), xex+1);
    else
        [x,flag,relres,iter] = pcg(A,b,tol,maxit,M);
    end        
    t_pcg=toc;
    rel_err1_pcg = norm(x-xex,1)/norm(xex,1);
    rel_err2_pcg = norm(x-xex)/norm(xex);
    rel_errinf_pcg = norm(x-xex, inf)/norm(xex, inf);
    apost_pcg = condest(A)*norm(b-A*x,1)/norm(b,1);
    if(flag==0)
        fprintf("PCG:\n Converged in %f seconds and %d iterations\n Residual: %e\n1-norm error: %e\n2-norm error: %e\ninf-norm error: %e\n apost_est: %e\n\n", t_pcg, iter, relres, rel_err1_pcg, rel_err2_pcg, rel_errinf_pcg, apost_pcg)
    elseif(flag==1)
        fprintf("PCG did not converge in %d iterations.\n.", maxit)
    elseif(flag==3)
        fprintf("PCG stagnated.\n")
    end
    
    if(my_CG)
        % (c) my CG
        tic
        [x,flag,iter,rr_vec] = conjgrad(A,b,xex+1,M,maxit,tol);
        t_cg=toc;
        rel_err2_cg = norm(x-xex)/norm(xex);
        if(flag==0)
            fprintf("MyCG converged in %f seconds and %d iterations, normalized residual %e, relative error %e.\n\n", t_cg, iter, rr_vec(end), rel_err2_cg)
        elseif(flag==1)
            fprintf("MyCG did not converge in %d iterations.\n\n", maxit)
        end
    end

    
else
    
    % LU
    tic
    [L,U,P]=lu(A);
    y=L\(P*b);
    x=U\y;
    t_lu=toc;
    rel_err1_lu = norm(x-xex,1)/norm(xex,1);
    rel_err2_lu = norm(x-xex)/norm(xex);
    rel_errinf_lu = norm(x-xex, inf)/norm(xex, inf);
    apost_lu = condest(A)*norm(b-A*x,1)/norm(b,1);
    fprintf("LU:\n 1-norm error: %e\n 2-norm error: %e\ninf-norm error: %e\n apost_est: %e\n Execution time: %f seconds.\n\n", rel_err1_lu, rel_err2_lu, rel_errinf_lu, apost_lu, t_lu)
    
    % GMRES
    tic
    restart_val=32;
    [x,flag,relres,iter,resvec] = gmres(A,b,restart_val,tol,maxit);
    t_gmres=toc;
    rel_err1_gmres = norm(x-xex,1)/norm(xex,1);
    rel_err2_gmres = norm(x-xex)/norm(xex);
    rel_errinf_gmres = norm(x-xex, inf)/norm(xex, inf);
    apost_gmres = condest(A)*norm(b-A*x,1)/norm(b,1);
    
    if(flag==0)
        fprintf("GMRES:\n Converged in %f seconds and %d iterations\n Residual: %e\n1-norm error: %e\n2-norm error: %e\ninf-norm error: %e\n apost_est: %e\n\n", t_gmres, length(resvec), relres, rel_err1_gmres, rel_err2_gmres, rel_errinf_gmres, apost_gmres)
    elseif(flag==1)
        fprintf("GMRES did not converge in %d iterations.\n.", maxit)
    elseif(flag==3)
        fprintf("GMRES stagnated.\n")
    end
    
    
    % PGMRES
    M=diag(diag(A));
    tic
    restart_val=32;
    [x,flag,relres,iter, resvec] = gmres(A,b,restart_val,tol,maxit, M);
    t_pgmres=toc;
    rel_err1_pgmres = norm(x-xex,1)/norm(xex,1);
    rel_err2_pgmres = norm(x-xex)/norm(xex);
    rel_errinf_pgmres = norm(x-xex, inf)/norm(xex, inf);
    apost_pgmres = condest(A)*norm(b-A*x,1)/norm(b,1);
    
    if(flag==0)
        fprintf("PGMRES:\n Converged in %f seconds and %d iterations\n Residual: %e\n1-norm error: %e\n2-norm error: %e\ninf-norm error: %e\n apost_est: %e\n\n", t_pgmres, length(resvec), resvec(end), rel_err1_pgmres, rel_err2_pgmres, rel_errinf_pgmres, apost_pgmres)
    elseif(flag==1)
        fprintf("PGMRES did not converge in %d iterations.\n.", maxit)
    elseif(flag==3)
        fprintf("PGMRES stagnated.\n")
    end
end

