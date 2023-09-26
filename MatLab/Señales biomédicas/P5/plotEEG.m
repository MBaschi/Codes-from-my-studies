function plotEEG(rec,inicio,fin)
% representación gráfica de los 23 canales de señal de EEG contenidas en
% la sesión de registro 'rec' desde el segundo 'inicio' y 'fin'.
% 
%llamada a la función: plotEEG('chb05_13') y  plotEEG('chb05_13',1070,1250)

fm=256;
%directory='D:\SenyalesBiomedicas\Practicas\P6';
directory='D:\DATOS\Datos\asignaturas\Señales GIB\P6';
[header,data]=edfread([directory '\' rec '.edf']);%la informacion de los diferentes canales viene en filas, cada fila un canal

if nargin==1
    inicio=1;
    fin=size(data,2);
end
if nargin==2
    inicio=inicio*fm+1;
    fin=size(data,2);
end
if nargin==3
    inicio=inicio*fm+1; fin=fin*fm;
end

time=1/fm:1/fm:size(data,2)/fm;
close all
figure();

inter=0;
n=size(data,1);

bottom=0.08;
Height=(1-bottom-0.02-inter*(n-1))/n;


for i=1:n
    subplot('position',[0.00 bottom 0.88 Height]); 
    plot(time(inicio:fin),data(i,inicio:fin),'k');

    set(gca, 'YLim',[-1000, 1000]);
    bottom=bottom+inter+Height; 
    set(gca,'Color','none');
    set(gca,'box','off');
    set(gca,'XColor',[0.831 0.816 0.784])
    set(gca,'XTick',[]);
    set(gca,'YColor',[0.831 0.816 0.784])    
    set(gca,'YTick',[]);
    
%     switch i
%         case 1
%             ylabel('FP1-F7');   
%             
%         case 2
%             ylabel('F7-T7');   
%         case 3
%             ylabel('T7-P7');   
%         case 4
%             ylabel('P7-O1');   
%         case 5
%             ylabel('FP1-F3');   
%         case 6
%             ylabel('F3-C3');   
%         case 7
%             ylabel('C3-P3');   
%         case 8
%             ylabel('P3-O1');   
%         case 9
%             ylabel('FP2-F4');   
%         case 10
%             ylabel('F4-C4');   
%         case 11
%             ylabel('C4-P4');   
%         case 12
%             ylabel('P4-O2');   
%         case 13
%             ylabel('FP2-F8');   
%         case 14
%             ylabel('F8-T8');   
%         case 15
%             ylabel('T8-P8');   
%         case 16
%             ylabel('P8-O2');   
%         case 17
%             ylabel('FZ-CZ');   
%         case 18
%             ylabel('CZ-PZ');   
%         case 19
%             ylabel('P7-T7');   
%         case 20
%             ylabel('T7-FT9');   
%         case 21
%             ylabel('FT9-FT10');   
%         case 22
%             ylabel('FT10-T8');   
%         case 23
%             ylabel('T8-P8');   
%         otherwise
%             fprintf('error');
%     end
    % axis off (borra el eje)
end
    