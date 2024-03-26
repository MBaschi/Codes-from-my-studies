%% Definizione L
num = 10*[10 1];
den = poly([-1 -1 -1 -1]);
L = tf(num,den);
bode(L); grid;

%% Calcolo del margine di fase e di guadagno
margin(L)
[GainM,PhaseM,Wcg,Wcp] = margin(L);
disp(GainM); disp(PhaseM); disp(Wcg); disp(Wcp);
% margine di fase negativo -> sistema instabile

%% Simulazione al gradino del sistema sotto controllo
step(feedback(L,1),10)

%% mu = 1
num = 1*[10 1];
den = poly([-1 -1 -1 -1]);
L1 = tf(num, den);
figure; margin(L); hold on; margin(L1)
[GainM,PhaseM,Wcg,Wcp] = margin(L1);

%% Simulazione al gradino del sistema sotto controllo con mu=1
figure; step(L1/(1+L1),20)

% ATTENZIONE alle semplificazioni
% L1/(1+L1) = feedback(L1,1)
% 1/(1+L1) = feedback(1,L1)
% questo, a meno di semplificazioni poli-zeri

%% Calcolo dell'uscita a fronte di ingresso costante w
[Ywm,Ywf] = bode(L1/(1+L1),0);
t = 0:0.001:100;            % Definizione del vettore tempo
w = 3*ones(size(t));
y_w = Ywm*w;

%% Calcolo dell'uscita a fronte di disturbo d a pulsazione 0.3
[Ydm,Ydf] = bode(1/(1+L1),0.3);
y_d = -Ydm*2*sin(0.3*t + Ydf*pi/180);

%% Grafico dell'uscita
figure
plot(t,y_w+y_d,'linewidth',2)
grid on
xlabel('Tempo [s]')
ylabel('Uscita')
axis([0 100 0 2.5])

%% Sovrappongo la traiettoria ottenuta simulando il sistema
d = -2*sin(0.3*t);
y_simw = lsim(L1/(1+L1),w,t);   % Simulazione w
y_simd = lsim(1/(1+L1),d,t);   % Simulazione d
hold on
plot(t,y_simw+y_simd,'linewidth',2)
legend('Risposta in frequenza','Simulata','location','best')
