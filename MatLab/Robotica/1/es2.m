clear all
close all
d=[0,0,0];
a=[0.5,0.3,0.2];
alpha=[0,0,0];
L1=Link('revolute','d',d(1),'a',a(1),'alpha',alpha(1)); 
L2=Link('revolute','d',d(2),'a',a(2),'alpha',alpha(2)); 
L3=Link('revolute','d',d(3),'a',a(3),'alpha',alpha(3)); 

L1.qlim=[-pi/3,pi/3]; % valori limiti variabili di giunto
L2.qlim=[-2*pi/3,2*pi/3]; % valori limiti variabili di giunto
L3.qlim=[-pi/2,pi/2]; % valori limiti variabili di giunto per assicurarci di nono sforare

rob_planare=SerialLink([L1 L2 L3]);
rob_planare.name='3 link robot';

q_init=[0,0,0];

figure
rob_planare.plot(q_init)
title('initial conf');
%2.4) plotta spazio di lavoro
N=15;
q1_value=[-pi/3:(2*pi/3)/N:pi/3]; % da -60 a + 60 con passo di 8
q2_value=[-2*pi/3:(4*pi/3)/N:2*pi/3];
q3_value=[-pi/2:pi/*N:pi/2];
%ciclo for dato dal prof 
for i=1:length(q1_value)
    for j=1:length(q2_value)
        for k=1:length(q3_value)
            q1=q1_value(i);
            q2=q2_value(j);
            q3=q3_value(k);
            
            A01=[cos(q1), -sin(q1),  0, a(1)*cos(q1); 
                 sin(q1),  cos(q1),  0, a(1)*sin(q1); 
                 0,        0,        1, 0; 
                 0,        0,        0, 1];
             
            A12=[cos(q2), -sin(q2),  0, a(2)*cos(q2);
                 sin(q2),  cos(q2),  0, a(2)*sin(q2);
                 0,        0,        1, 0;
                 0,        0,        0, 1];
             
            A23=[cos(q3), -sin(q3), 0, a(3)*cos(q3); 
                 sin(q3),  cos(q3), 0, a(3)*sin(q3); 
                 0,        0,       1, 0;
                 0,        0,       0, 1];
             
            T03=A01*A12*A23;
            
            plot(T03(1,4),T03(2,4),'x'); %segnare una 'x' corrispondente a p_x e p_y dell'end effector (p_z non è necessario dato che il manipolatore è planare)
            title('workspace');
            hold on;
        end
    end
end
