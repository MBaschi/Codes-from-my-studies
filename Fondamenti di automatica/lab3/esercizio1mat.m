%% ESERCIZIO 1
clear; close all; clc

%% definizione matrici del sistema
A=[2 1 -1; -3 -2 -1; -1 1 -4];
b=[1 0 1]';
c=[0 0 1];
d=0;

%% stabilità
autoval = eig(A); disp(autoval)
% moduli > 1  ->  instabile

%% raggiungibilità
R = ctrb(A, b);
disp(rank(R))
disp(det(R))
% R ha rango pieno  ->  completamente raggiungibile

%% osservabilità
O = obsv(A, c);
disp(rank(O))
disp(det(O))
% O ha rango pieno  ->  completamente osservabile

% il sistema è completamente raggiungibile e osservabile, quindi è
% stabilizzabile mediante un regolatore lineare composto da legge di
% controllo k e ricostruttore dello stato l.
% la dinamica del sistema regolato è fissabile arbitrariamente. In
% particolare, è possibile determinare una legge di controllo e un
% ricostruttore dello stato tali che tutti i transitori si annullino in
% tempo finito

%% legge di controllo k
autovalori = [0 0 0];
k = acker(A, -b, autovalori); disp(k)
disp(eig(A + b*k)) % verifica autovalori

%% ricostruttore dello stato l
lT = acker(A', -c', autovalori);
l = lT'; disp(l)
disp(eig(A + l*c)) % verifica autovalori

%% Controlliamo che il sistema abbia effettivamente gli autovalori che crediamo noi...
% x(k+1) = A x(k) + B*K*xhat(k)
% hat x(k+1) = A xhat(k) + B*K*xhat(k) + L (yhat(k)-y(k)) = A xhat(k) + B*K*xhat(k) + L (C xhat(k)- C x(k))
matriciona = [A, b*k; -l*c, A+l*c+b*k];
disp(eig(matriciona))

% compensiamo il guadagno del nuovo sistema
guadagnochiuso = [c, zeros(1, 3)]*inv(eye(size(matriciona)) - matriciona)*[b; b];
K = 1/guadagnochiuso; disp(guadagnochiuso)