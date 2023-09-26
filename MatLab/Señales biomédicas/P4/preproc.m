
function [time,Bip,tt,TOCO,parametro,feature]=preproc(id)

%paso 1: leer el registro EHG y TOCO
EHG=load(strcat(id,'_datas.txt'));
TOCO=load(strcat(id,'_TOCO.txt'));
%paso 2: leer el fichero de segmentacion de las contracciones
CTseg=importdata(strcat('CTseg_',id,'.txt'));
%paso3a: diezmado de la señal 
%pasaremos de la frecuencia 500Hz a 20Hz 
N=500/20;
%nombramos señales de EHG
L=length(EHG);
time=(1:L)/20; %vector tiempo del 
tt=(1:length(TOCO))/20; %vector tiempo TOCO
M1=EHG(:,1);
M2=EHG(:,2);
%hacemos el diezmado utilizando reshape
m1d=mean(reshape(M1,[N,L/N]));
m2d=mean(reshape(M2,[N,L/N]));
%paso 3b: filtro paso banda de m1d y m2d de orden 5
    %paso alto
[A,B]=butter(5,0.1/(20/2),'high');
Y1=filtfilt(A,B,m1d);
Y2=filtfilt(A,B,m2d);
    %paso bajo
[C,D]=butter(5,4/(20/2),'low');
M1_proc=filtfilt(C,D,Y1);
M2_proc=filtfilt(C,D,Y2);

%paso 3c: señal bipolar
Bip=M1_proc-M2_proc;
Bip=Bip-mean(Bip);

%paso 4: Calculos de la señal EHG
%Duracion de la contraccion en segundos: D
if CTseg.data(1,1)==0
    CTseg.data(1,1)=1   
end 
    dur=(CTseg.data(:,2)-CTseg.data(:,1))/20; %duracion contraction
%valor eficaz de la señal

n=size(CTseg.data,1); %numero contractiones
for i=1:n
    inicio=CTseg.data(i,1);
    fin=CTseg.data(i,2);
    RMS(i)=rms(Bip(inicio:fin)); % tenemos que calcular el RMS del segnal para cada contractionù
    energy(i)=sum(Bip(inicio:fin).^2)*(1/20); %energia en el dominio temporal
    parametro(i,:)=EHGparameter(Bip(inicio:fin));
    DFDrat(i)=parametro(i,3)/dur(i)*1000;
end 
%parameter=[dur,RMS,energy,parametro,DFDrat];
%paso 5:Calcule Calcule el valor mediana de los parámetros de EHG de las M contracciones de cada paciente
duracion_m=median(dur);
RMS_m=median(RMS);
Energy_m=median(energy);
parametro_m=median(parametro,1);
DFDrat_m=median(DFDrat);
feature=[duracion_m,RMS_m,Energy_m,parametro_m,DFDrat_m];

end