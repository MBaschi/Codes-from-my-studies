clear all
close all
fname='chb05_13';

fm=256;
%PASO 1
[hdr, record]=edfread(strcat(fname,'.edf'));
seg=importdata(strcat(fname,'_seg.txt'));
Wn=[59/(fm/2) 61/(fm/2)];

for canal=1:23;
    
    %PASO 2 el filtro notch de 60 Hz
    [A,B]=butter(5,Wn,'stop');
    signal(canal,:)=filtfilt(A,B,record(canal,:));
    
    seg_muestra=seg.data*fm; %seg es in segundo
    
    n_crisis=length(seg.data)/3; %numero de crisis
    
    n=1; %contador addictional
    for i=1:n_crisis
        signal_preictal(canal,:,i)=signal(canal,seg.data(n,1):seg.data(n,2));
        signal_ictal(canal,:,i)=signal(canal,seg.data(n+1,1):seg.data(n+1,2));
        signal_post(canal,:,i)=signal(canal,seg.data(n+2,1):seg.data(n+2,2));
        n=n+3;
        
        %PASO 3
        PSD_canal_preictal(canal,i,:)=pwelch(signal_preictal(canal,:,i),20,10,4096);
        Etot_preictal=sum(PSD_canal_preictal(canal,i,:));
        %energia normalizada preictal
        NE_delta_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,1:4))/Etot_preictal;
        NE_theta_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,4:8))/Etot_preictal;
        NE_alpha_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,8:12))/Etot_preictal;
        NE_beta_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,12:30))/Etot_preictal;
        NE_gamma_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,30:128))/Etot_preictal;
        %potencia preictal
        P_delta_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,1:4))*(4-1);
        P_theta_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,1:4))*(8-4);
        P_alpha_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,8:12))*(12-8);
        P_beta_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,12:30))*(30-12);
        P_gamma_preictal(canal,i)=sum(PSD_canal_preictal(canal,i,30:128))*(128-30);
        
        %PASO 4
        PSD_canal_ictal(canal,i,:)=pwelch(signal_ictal(canal,:,i),20,10,4096);
        Etot_ictal=sum(PSD_canal_ictal(canal,i,:));
        %energia normalizada ictal
        NE_delta_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,1:4))/Etot_ictal;
        NE_theta_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,4:8))/Etot_ictal;
        NE_alpha_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,8:12))/Etot_ictal;
        NE_beta_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,12:30))/Etot_ictal;
        NE_gamma_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,30:128))/Etot_ictal;
        %potencia ictal
        P_delta_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,1:4))*(4-1);
        P_theta_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,1:4))*(8-4);
        P_alpha_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,8:12))*(12-8);
        P_beta_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,12:30))*(30-12);
        P_gamma_ictal(canal,i)=sum(PSD_canal_ictal(canal,i,30:128))*(128-30);
        
        %PASO 5
        PSD_canal_post(canal,i,:)=pwelch(signal_post(canal,:,i),20,10,4096);
        Etot_post=sum(PSD_canal_post(canal,i,:));
        %energia normalizada post
        NE_delta_post(canal,i)=sum(PSD_canal_post(canal,i,1:4))/Etot_post;
        NE_theta_post(canal,i)=sum(PSD_canal_post(canal,i,4:8))/Etot_post;
        NE_alpha_post(canal,i)=sum(PSD_canal_post(canal,i,8:12))/Etot_post;
        NE_beta_post(canal,i)=sum(PSD_canal_post(canal,i,12:30))/Etot_post;
        NE_gamma_post(canal,i)=sum(PSD_canal_post(canal,i,30:128))/Etot_post;
        %potencia post
        P_delta_post(canal,i)=sum(PSD_canal_post(canal,i,1:4))*(4-1);
        P_theta_post(canal,i)=sum(PSD_canal_post(canal,i,1:4))*(8-4);
        P_alpha_post(canal,i)=sum(PSD_canal_post(canal,i,8:12))*(12-8);
        P_beta_post(canal,i)=sum(PSD_canal_post(canal,i,12:30))*(30-12);
        P_gamma_post(canal,i)=sum(PSD_canal_post(canal,i,30:128))*(128-30);
    end 
       
    
end 

for i=1:n_crisis
    
%promedio NE preictal
 NE_delta_preictal_prom(i)=mean(NE_delta_preictal(:,i));
 NE_theta_preictal_prom(i)=mean(NE_theta_preictal(:,i));
 NE_alpha_preictal_prom(i)=mean( NE_alpha_preictal(:,i));
 NE_beta_preictal_prom(i)=mean(NE_beta_preictal(:,i));
 NE_gamma_preictal_prom(i)=mean( NE_gamma_preictal(:,i));
 %promedio potencia preictal
 P_delta_preictal_prom(i)=mean(P_delta_preictal(:,i));
 P_theta_preictal_prom(i)=mean(P_theta_preictal(:,i));
 P_alpha_preictal_prom(i)=mean(P_alpha_preictal(:,i));
 P_beta_preictal_prom(i)=mean(P_beta_preictal(:,i));
 P_gamma_preictal_prom(i)=mean(P_gamma_preictal(:,i));
 
  %promedio NE ictal
 NE_delta_ictal_prom(i)=mean(NE_delta_ictal(:,i));
 NE_theta_ictal_prom(i)=mean(NE_theta_ictal(:,i));
 NE_alpha_ictal_prom(i)=mean( NE_alpha_ictal(:,i));
 NE_beta_ictal_prom(i)=mean(NE_beta_ictal(:,i));
 NE_gamma_ictal_prom(i)=mean( NE_gamma_ictal(:,i));
 %promedio potencia ictal
 P_delta_ictal_prom(i)=mean(P_delta_ictal(:,i));
 P_theta_ictal_prom(i)=mean(P_theta_ictal(:,i));
 P_alpha_ictal_prom(i)=mean(P_alpha_ictal(:,i));
 P_beta_ictal_prom(i)=mean(P_beta_ictal(:,i));
 P_gamma_ictal_prom(i)=mean(P_gamma_ictal(:,i));
 
%promedio NE post
 NE_delta_post_prom(i)=mean(NE_delta_post(:,i));
 NE_theta_post_prom(i)=mean(NE_theta_post(:,i));
 NE_alpha_post_prom(i)=mean( NE_alpha_post(:,i));
 NE_beta_post_prom(i)=mean(NE_beta_post(:,i));
 NE_gamma_post_prom(i)=mean( NE_gamma_post(:,i));
 %promedio potencia post
 P_delta_post_prom(i)=mean(P_delta_post(:,i));
 P_theta_post_prom(i)=mean(P_theta_post(:,i));
 P_alpha_post_prom(i)=mean(P_alpha_post(:,i));
 P_beta_post_prom(i)=mean(P_beta_post(:,i));
 P_gamma_post_prom(i)=mean(P_gamma_post(:,i));
end 
disp('fin');