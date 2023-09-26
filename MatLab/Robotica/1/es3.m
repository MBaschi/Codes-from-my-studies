clear all
close all
clc
disp('______________')
syms th1 d2 d3 %variabili simboliche
%scriviamo matrici di strasformazioni omogenee 
 A01=[ cos(th1),-sin(th1),0,0;
       sin(th1),cos(th1),0,0;
       0,0,1,1;
       0,0,0,1];
  A12=[0,0,1,0;
       1,0,0,0;
       0,1,0,d2;
       0,0,0,1];
  A23=[1,0,0,0;
       0,1,0,0;
       0,0,1,d3;
       0,0,0,1];
   
   Tsym=A01*A12*A23;
   
 %calcoliamo jacobiano J=[z0x(p-p0);z1,z2] primo rotazoinale altri due
 %traslazionali
 
 z0=[0;0;1];
 p0=[0;0;0];
  p=Tsym(1:3,4); % primi tre elementi della colonna 4 della matrice totale di trasformzione
 pdiff=p-p0;
 
 
 Jc1=[z0(2)*pdiff(3)-z0(3)*pdiff(2);
      z0(3)*pdiff(1)-z0(1)*pdiff(3)
      z0(1)*pdiff(2)-z0(2)*pdiff(1)]; %colonna uno jacobiano prodotto vettoriale tra z0 e pdiff (scirtta a mano perchè ci sono problemi con la funzione prodotto vettoriale di matlab
  
  z1=A01(1:3,3);
  Jc2=z1; %seconda colonna jacobiano
  
  A02=A01*A12; 
  z2=A02(1:3,3);
  Jc3=z2;
  
  Jsym=[Jc1,Jc2,Jc3]; %matrice jacobiana simbolica
  
  %calcola singolarità
  
 det_J=det(Jsym) %questa scittura funziona ma non semplifica la scirtture
 det_J=simplify(det(Jsym))
  
 % ora troviamo i valori per cui abbiamo la signolarità
 
 S=solve(det_J==0,'ReturnConditions', true) % crea una struct con le soluzioni 
  
  
  