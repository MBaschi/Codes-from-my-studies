%% ESERCIZIO 3
clear; close all; clc

%% definizione matrici del sistema
A = [1 1 0; -5 -3 0; 2 3 -1];
b = [1; 1; 0];
c = [1 1 1];
d = 0;

%$ definizione del sistema
S = ss(A,b,c,d);

%% risposta scalino
figure
step(S)
%
[out_sca, time_sca] = step(S);
figure
plot(time_sca, out_sca);

%% risposta impulso
figure
impulse(S)
%
[out_imp, time_imp] = impulse(S);
figure
plot(time_imp, out_imp);
