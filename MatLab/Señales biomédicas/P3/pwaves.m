function [indP,indR,ISOamp,beat, tm, signalfilt]=pwaves(tm,signal)

% indP: instante de tiempo en el que se ha localizado el valor máximo en la
        % onda P, es decir, en la ventana (indR-275ms:indR-90ms) (expresado en muestras)
% indR: instante de tiempo en el que se ha localizado la onda R (expresado
        % en muestras)
% ISOamp: la amplitud de la línea isoeléctrica de cada latido cardiaco
% beat (701xN): los N latidos identificados en el registro extendiendo de 275 ms antes al 425 ms después de cada latido. 
        % Cada columna de la variable corresponde a un latido cardiaco. La
        % matriz tiene una dimensión de 701xN
% tm:  vector de tiempo
% signalfilt: señal ECG filtrada paso bajo 35 Hz

close all;
fm=1000;pre=275; post=425;
% filtro paso bajo en 35 Hz
[b,a]=butter(5,35*2/fm,'low'); signal=filtfilt(b,a,signal);

% Detección de la onda R
[qrs_amp_raw,R_index,delay]=pan_tompkin(signal,fm,0);
% intervalo de tiempo mínimo entre la onda P y la onda R
lapso=0.09*fm;
pw=[];
iso=[];
indR=[];
beat=[];
 if (R_index(1)-pre+1)<1
% La ventana hacia atrás del primer latido está fuera de la ventana de
% análisis
        if R_index(1)<lapso
% No cumple el intervalo de tiempo mínimo entre la onda P y la onda R, por
% lo que no se detecta la onda P del primer latido
            fprintf('No se ha detectado onda P en el primer latido.\n');
        else
% Cumple el criterio del intervalo de tiempo mínimo
            eval=signal(1:R_index(1)+post);
% Buscar la onda P (valor máximo) en la ventana anterior al QRS, considerando el intervalo
% mínimo de tiempo 
            [maximo,indice]=max(eval(1:R_index(1)-lapso));
            isoelectric=prctile(eval(1:R_index(1)-lapso),25);
            pw=[pw;indice];
            iso=[iso;isoelectric];
            indR=[indR;R_index(1)];
        end
 else
% La ventana hacia atrás del primer latido está dentro de la ventana de
% análisis
     ini=R_index(1)-pre;
     fin=R_index(1)+post;
     eval=signal(ini:fin);
% Buscar la onda P (valor máximo) en la ventana anterior al QRS, considerando el intervalo
% mínimo de tiempo      
     [maximo,indice]=max(eval(1:pre-lapso));
     isoelectric=prctile(eval(1:pre-lapso),25);
     pw=[pw;R_index(1)-(pre-indice)-1];
     iso=[iso;isoelectric];
     indR=[indR;R_index(1)];
     beat=[beat eval];
 end
 
for i=2:length(R_index)
    ini=R_index(i)-pre;
    if R_index(i)+post>length(signal)
        fin=length(signal);
    else 
        fin=R_index(i)+post;
    end    
    eval=signal(ini:fin);
    % sólo incluirlo en el estudio del latido promedio si la ventana
    % [R_index-pre, R_index+post] está dentro de la ventana de análisis
    if length(eval)==pre+post+1
        beat=[beat eval];
    end

    [maximo,indice]=max(eval(1:pre-lapso));
    isoelectric=prctile(eval(1:pre-lapso),25);
    pw=[pw;R_index(i)-(pre-indice)-1];
    iso=[iso;isoelectric];
    indR=[indR;R_index(i)];
end


pamp=signal(pw)-iso;

pw_v=[];
indR_v=[];
iso_v=[];

for i=1:length(pamp)
    % Eliminando aquellas que se difiere demasiado al valor mediana 
    if pamp(i)>=0.3*median(pamp) 
       pw_v=[pw_v;pw(i)]; 
       indR_v=[indR_v; indR(i)];
       iso_v=[iso_v;iso(i)];
    end
end

% variables de salida
indP=pw_v;
ISOamp=iso_v;
indR=indR_v;
signalfilt=signal;

