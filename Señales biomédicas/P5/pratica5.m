function [NE_prom P_prom]=pratica5(fname)
fm=256;
v=[1 4 8 12 30 128]*4096/fm; %vector por division banda segnal
%PASO 1
[hdr,record]=edfread(strcat(fname,'.edf'));
seg=importdata(strcat(fname,'_seg.txt'));
Wn=[59/(fm/2) 61/(fm/2)]; %frequencia por filtragio
%PASO 2 el filtro notch de 60 Hz
[A,B]=butter(5,Wn,'stop');
r=record';
signal_tot=filtfilt(A,B,r);
seg_muestra=seg.data*fm; %seg es in segundo
n_crisis=length(seg.data)/3; %numero de crisis

   
    n=1; %contador addictional

    for i=1:n_crisis %i=contador crisis
            period(1).data=signal_tot(seg_muestra(n,1):seg_muestra(n,2),:);     %periodo(1) =periodo preictal
            period(2).data=signal_tot(seg_muestra(n+1,1):seg_muestra(n+1,2),:); %periodo(2) =periodo preictal
            period(3).data=signal_tot(seg_muestra(n+2,1):seg_muestra(n+2,2),:); %periodo(3) =periodo preictal
            n=n+3; %necesario para ir a la crisi successiva
            
           for p=1:3 %contador periodo
               for b=1:5 % b contador banda              b=1-->delta
                                      %                  b=2-->theta
                                      %                  ecc ecc
                                      %                  b=5-->gamma
                        for c=1:23
                            [PSD,w]=pwelch(period(p).data(:,c),hamming(20*fm),10*fm,4096,fm); %periodogramma de welcome
                            
                            Etot=sum(PSD); %energia total
                           

                            %energia normalizada
                            NE(c)=sum(PSD((v(b)+1):(v(b+1))))/Etot; %v=[1 4 8 12 30 128]*4096/fm declarado inicialmente
                            %potencia
                            P(c)=sum(PSD((v(b)+1):(v(b+1))))*fm/4096;
                        end 
                        NE_mean(i,b+5*(p-1))=mean(NE);
                        P_mean(i,b+5*(p-1))=mean(P);
               end
           end 
  
    end 
    

  Titulo_1={'','PREICTAL','','','','','ICTAL','','','','','POST','','','',''};
  Titulo_2={'Crisis','delta','theta','alpha','beta','gamma','delta','theta','alpha','beta','gamma','delta','theta','alpha','beta','gamma'};
  xlswrite('EEGanalysis.xlsx', Titulo_1, 'Energia normalizada EEG','A1');
  xlswrite('EEGanalysis.xlsx', Titulo_1, 'PowerEEG','A1')
  xlswrite('EEGanalysis.xlsx', Titulo_2, 'Energia normalizada EEG','A2');
  xlswrite('EEGanalysis.xlsx', Titulo_2, 'PowerEEG','A2')
  xlswrite('EEGanalysis.xlsx', NE_mean, 'Energia normalizada EEG','B3');
  xlswrite('EEGanalysis.xlsx', P_mean, 'PowerEEG','B3');
end

