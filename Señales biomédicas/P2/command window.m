clear all
close all
disp("_____________");
load('s0014lre.mat'); %carica dataset
label={'Lead I','Lead II','Lead III','AVR','AVF','V1','V2','V3','V4','V5','V6'};
fig=3;
if fig==1
  for i=1:size(signal,2)
    subplot(6,2,i); %array di grafici
    plot(tm,signal(:,i),'k'); % poni in posizione i il grafico signal(i)
    set(gca,'FontName','Arial','FontSize',16); %robe estetiche
    ylabel(char(label(i)));
  end
end 
if fig==2
  for i=1:size(signal,2)
    subplot(6,2,i); %array di grafici
    plot(tm(1:10*Fs),signal(1:10*Fs,i),'k'); % poni in posizione i il grafico signal(i)
    set(gca,'FontName','Arial','FontSize',16); %robe estetiche
    ylabel(char(label(i)));
  end
end

[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(signal(:,1),Fs,1); %elaborazione dati co npam tompkin
RR=diff(qrs_i_raw)/Fs;
subplot(2,1,1);
plot(tm,signal(:,1),'k');
hold on; plot(tm(qrs_i_raw),signal(qrs_i_raw,1),'ro');
subplot(2,1,2); 
plot(tm(qrs_i_raw(1:end-1)),RR,'k') %plot algoritmo tompkin
[evalua]=averageECG(qrs_i_raw,signal(:,1),275,425,1000); %trova i punti di massimo
time=(1:size(evalua,2))/Fs;
for i=1:size(evalua,1)
    hold on; plot(time,evalua(i,:),'b')
end 
hold on; plot(time,mean(evalua),'r');
figure(2);plot(time,evalua(1,:),'b');
figure(2);hold on;plot(time,mean(evalua),'r');