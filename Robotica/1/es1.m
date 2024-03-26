clear all
close all
disp('_____________');
% parametri DH
alpha=[pi/2,0,0,pi/2,-pi/2, 0];
a=[0, -0.425, -0.39225, 0, 0,0];
d=[0.08916, 0,0, 0.10915, 0.09456, 0.0823];
%parametri dei link
L1=Link('revolute','d',d(1),'a',a(1),'alpha',alpha(1)); % funzione del robotic toolbox che mi consente di definre una variabile link
L2=Link('revolute','d',d(2),'a',a(2),'alpha',alpha(2)); % il primo argomento definisce il tipo di link (in questo caso rotazionale)
L3=Link('revolute','d',d(3),'a',a(3),'alpha',alpha(3)); % gli argomenti successivi specificano le altre variabili
L4=Link('revolute','d',d(4),'a',a(4),'alpha',alpha(4));
L5=Link('revolute','d',d(5),'a',a(5),'alpha',alpha(5));
L6=Link('revolute','d',d(6),'a',a(6),'alpha',alpha(6));
% manipolatore
UR5=SerialLink([L1 L2 L3 L4 L5 L6]); % il manipolatore in esame è l'UR5
UR5.name='UR5'; %nome che comparirà nelle immagini
%1.3) mostrare il manipolatore nella configurazione q_init
q_init=[0,-pi/2,0,-pi/2,0,-pi];

figure
UR5.plot(q_init);
title('Init configuration');
%pause %funzione che può essere inserità per decidere quando far andare
%avanti il codice
%1.4) Calcolo della cinematica diretta
q1=[pi/4,-3*pi/4,-pi/3,-pi/3,pi/2,pi/3];
Tr1=fkine(UR5,q1) % matrice di rotazione da terna base a end effector

UR5.plot(q1)
title('conf related to tr1');
%1.5) calcolo jacobiano

J_q1=jacob0(UR5,q1); % jacobiano del manipolatore UR5 nella posizione q1
det_J_q1=det(J_q1); % vediamo se q1 è una singolarità 

%1.6) verificare se le configurazioni date sono singolairtà
q_sing1=[0,-pi/6,0,pi/12,pi/2,0];
J_q_sing1=jacob0(UR5,q_sing1); 
det_J_q_sing1=det(J_q_sing1);% non viene esattamente zero ma e-18 dopo e-15 possiamo consideralo zero
UR5.plot(q_sing1)
title('conf related to q_sing1'); % si osserva dal immagine che è una singolarità di gomito 
% singilarità di spalla rotazione istantanea in questà configuarzione
% singolarità di gomino: bloccaggio / scatto dei giunti
% in singorlarità il robot fa dei movitanti strani "inutili" che non
% vengono scritti ne codice ma vengono fatti perhè siamo in signolarità

%1.7) Calcolo cinematica inversa
p_ee=[0.5  0 0.25]; % posizione end effector
ee_rot_matrix=eye(3); %% matrice di rotazione  (unitaria perè abbiamo solo una translazione)

Tr2=[ee_rot_matrix p_ee'
    zeros(1,3) 1];
q_ee_des=UR5.ikine(Tr2); % inverse kinematic

UR5.plot(q_ee_des)
title('conf ikine');

%1.8)
UR5.teach(q_ee_des)