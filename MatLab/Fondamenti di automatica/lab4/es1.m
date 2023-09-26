%% Definizione del sistema
num = 10;
den = poly([-1 -1 -1]); % den = conv(conv([1 1], [1 1]), [1 1])
sistema = tf(num, den); disp(sistema)

%% Risposta allo scalino e risposta all'impulso (NON richieste nel testo)
figure, step(sistema)
figure, impulse(sistema)

%% Movimento libero del sistema a partire da [1 1 1] (NON richiesto nel testo)
% figure, initial(sistema, [1 1 1])
% linea 11 da errore perchè per ottenere il movimento libero è necessario
% usare il sistema nella forma state-space
[A, B, C, D] = tf2ss(num, den);
sistema_ss = ss(A, B, C, D);
figure, initial(sistema_ss,[1 1 1])

%% Visualizzazione diagrammi con la funzione bode
figure;
wmin = 0.1; wmax = 10; bode(sistema, {wmin, wmax})
grid on

%% Sovrapposizione diagrammi approssimati con la funzione bodeasin
[omega,bms,omegasf,bfsf]=bodeasin(num,den,wmin,wmax);
[ampiezza,fase,puls]=bode(sistema,{wmin,wmax});
figure;
subplot(2,1,1); semilogx(omega,bms,'r','linewidth',2);
subplot(2,1,2); semilogx(omegasf,bfsf,'r','linewidth',2);
subplot(2,1,1); hold on; semilogx(puls,20*log10(ampiezza(1,:))','linewidth',2); grid on; xlim([wmin,wmax])
subplot(2,1,2); hold on; semilogx(puls,fase(1,:)','linewidth',2); grid on; xlim([wmin,wmax])

%% Errore massimo: dove abbiamo i 3 poli coincidenti
[ampiezza1,fase1]=bode(sistema,1);
erroremax=20-20*log10(ampiezza1); disp(erroremax)
erroremaxapprossimato= 3*3; disp(erroremaxapprossimato)

%% Calcolo della risposta in frequenza nel punto desiderato
[G0modulo,G0fase] = bode(sistema,0);              % Per l'ingresso costante
[G05modulo,G05fase] = bode(sistema,0.5);          % Per l'ingresso a 0.5 rad/s

%% Uscita secondo teorema di risposta in frequenza
t = 0:0.001:100;            % Definizione del vettore tempo
y_rf = 15*G0modulo - 3*G05modulo*sin(0.5*t + G05fase*pi/180);   % Uscita

% grafici
u = 15 - 3*sin(0.5*t);       % Definizione ingresso
y_sim = lsim(sistema,u,t);   % Simulazione uscita da condizione iniziale nulla
figure                       % Grafico dei risultati
plot(t,y_sim,t,y_rf,'g','LineWidth',2)
grid on
legend('Simulata','Risposta in frequenza','location','best')
xlabel('Tempo [s]')
ylabel('Uscita')
