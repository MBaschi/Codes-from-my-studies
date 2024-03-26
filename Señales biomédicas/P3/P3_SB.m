%Previo Práctica 3
%Andrea García Moreno, Mateo Baschieri, Aline Patrón Aguilar
%Creamos la funcion que nos devuelve un vector 'data' que tiene 4
%parámetros que vamos a calcular: VAR_RR, RATIO_PR, VAR_tPR, RATIO2_PR
%parámetro de entrada 'pacfile'

function[data]=P3_SB(pacfile)

%paso 1: leemos los datos 
load(pacfile);

%paso 2: detectar onda P, R, amplitud, beat, etc
%para eso llamaremos la funcion pwaves
[indP,indR,ISOamp,beat,tm,signalfilt]=pwaves(tm,sig);

%paso 3: intervalo RR y variabilidad 
int_RR=diff(indR);
VAR_RR=100*(std(int_RR)/mean(int_RR));

%paso 4: amplitud de la onda P de cada latido 
amp_P=abs(signalfilt(indP)-ISOamp);

%paso 5: Amplitud promedio onda P
prom_P= mean(amp_P);

%paso 6: Amplitud de la onda R de cada latido y paso 7: su promedio
amp_R=abs(signalfilt(indR)-ISOamp);
prom_R=mean(amp_R);

%paso 8: Ratio de la amplitud de la onda R y P
RATIO_PR= prom_P/prom_R;

%paso 9: tiempo máximo entre la amplitud máxima de la onda P y la onda R. Variabilidad. 
%tenemos frecuencia y queremos tiempo, por lo que dividimos por la frecuencia es de 1000Hz
int_PR= (indR-indP)/1000;
VAR_tPR=100*(std(int_PR)/mean(int_PR));

%paso 10: latido medio a partir de la matriz beat 
%sumamos la segunda columna de beat  
prom_beat=mean(beat,2); 

%paso 11: Veremos la posición en la que se encuentra la máxima amplitud del latido promedio de la onda R
[amp_prom_R,tm_prom_R]=max(prom_beat);

%paso 12: Amplitud de la linea isoelectrica como percentil 25 entre
%indR_275 y indR_90
%si indR_275 es menor o igual que 0 la ventana se extiende [1, indR_90]
if tm_prom_R<=0
    ventana=prom_beat(1:90);
    P_amp_beat_prom=max(ventana);
    ISO_amp_beat_prom=prctile(prom_beat(1:90),25);
else
    ventana=prom_beat((tm_prom_R-275):(tm_prom_R-90));
    P_amp_beat_prom=max(ventana);
    %calculamos el percentil 25 de ISO
    ISO_amp_beat_prom=prctile(prom_beat((tm_prom_R-275):(tm_prom_R-90)),25);    
end

%paso 13: amplitud de la onda P del latido promedio como la diferencia
%entre el valor máximo de la ventana anterior y la amplitud iso.
P_template=P_amp_beat_prom-ISO_amp_beat_prom;
%paso 14: 
R_template=amp_prom_R-ISO_amp_beat_prom;

%paso 15: ratio entre la amplitud de la onda P respecto a la onda R
RATIO2_PR=P_template/R_template;

data=[VAR_RR,RATIO_PR,VAR_tPR,RATIO2_PR];

end