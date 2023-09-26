function parametro=EHGparameter(data)
% data: la señal EHG burst muestreada en 20 Hz
% parametero: los parámetros espectrales de dicha señal EHG burst:
%   1. Fmedia: Frecuencia media en el rango de frecuencia 0.2-1 Hz
%   2. DF1: Frecuencia dominante en el rango de frecuencia 0.2-1 Hz (DF1)
%   3. DF2: Frecuencia dominante en el rango de frecuencia 0.34-1 Hz (DF2)
%   4. En1: Energía en el rango de frecuencia de 0.2-0.34 Hz respecto a la
%        energía total (0.2-1 Hz)
%   5. En2: Energía en el rango de frecuencia de 0.34-0.6 Hz respecto a la
%        energía total (0.2-1 Hz) 
%   6. En3: Energía en el rango de frecuencia de 0.6-1 Hz respecto a la
%        energía total (0.2-1 Hz) 
%   7. H/L ratio: ratio de la energía de alta frecuencia (0.34-1 Hz)
%        respecto a la energía de baja frecuencia

% frecuencia de muestreo
fehg=20;
% Obtención de la densidad espectral de potencia
    [p,w]=periodogram(data,hamming(length(data)),length(data),fehg);

    df=fehg/length(data); 
    fini=round(0.2/df)+1; fini2=round(0.34/df)+1; 
    ffin=round(1/df)+1;   ffin2=round(0.6/df)+1;
    % calcula la frecuencia media en el rango 0.2-1 Hz
    MF=sum(p(fini:ffin).*w(fini:ffin))/sum(p(fini:ffin));
    % calcula la frecuencia dominante en el rango 0.2- 1 Hz
    [peak,locs]=findpeaks(p(fini:ffin));
    [maxi,ind]=max(peak);
    DF1=w(locs(ind)+fini-1);
    % calcula la frecuencia dominante en el rango 0.34-1 Hz
    [peak,locs]=findpeaks(p(fini2:ffin));
    [maxi2,ind2]=max(peak);
    DF2=w(locs(ind2)+fini2-1);
    
    % calcula la energía por subbanda: En1:0.2-0.34 Hz
    % En2: 0.34-0.6 Hz; En3: 0.6-1 Hz
    En1=sum(p(fini:fini2))/sum(p(fini:ffin));
    En2=sum(p(fini2:ffin2))/sum(p(fini:ffin));
    En3=sum(p(ffin2:ffin))/sum(p(fini:ffin));
    % ratio de la energia en el rango 0.34-0.6 Hz respecto a la energía en el rango
    % 0.2-0.34 Hz
    ratio=(En2+En3)/En1;
    parametro=[MF DF1 DF2 En1 En2 En3 ratio];
end 