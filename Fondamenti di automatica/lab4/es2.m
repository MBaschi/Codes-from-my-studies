%% Definizione di sistemi
k = 8;
m = 2;
h = [7; 4; 0.4; 0.04; 0.01];

num = 1;
den1 = [m h(1) k];
G1 = tf(num,den1);
den2 = [m h(2) k];
G2 = tf(num,den2);
den3 = [m h(3) k];
G3 = tf(num,den3);
den4 = [m h(4) k];
G4 = tf(num,den4);
den5 = [m h(5) k];
G5 = tf(num,den5);

%% Diagrammi di Bode
bode(G1,G2,G3,G4,G5)
legend('7','4','0.4','0.04','0.01')

%% risposte a ingresso sinusoidale
[G2modulo,G2fase] = bode(G2,2);
[G3modulo,G3fase] = bode(G3,2);
[G4modulo,G4fase] = bode(G4,2);

%% Uscita secondo teorema di risposta in frequenza
t = 0:0.001:10;            % Definizione del vettore tempo
y_rf_2 = G2modulo*sin(2*t + G2fase*pi/180);
y_rf_3 = G3modulo*sin(2*t + G3fase*pi/180);
y_rf_4 = G4modulo*sin(2*t + G4fase*pi/180);

figure;
plot(t,y_rf_2,t,y_rf_3,t,y_rf_4);
legend('4','0.4','0.04')
xlabel('tempo'); ylabel('risposta');
