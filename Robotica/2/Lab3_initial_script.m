%% Pick and Place
clear all
close all
clc

% NOTA: scrivere “ simRemoteApi.start(19999) ”  nella linea di comando di CoppeliaSim 

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%    LAB 3     %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% parametri DH di un UR5

%   Link   a    alpha    d     theta
%  ----------------------------------
%    1     0    pi/2     d1     th1
%    2     a2     0      0      th2
%    3     a3     0      0      th3
%    4     0    pi/2     d4     th4
%    5     0   -pi/2     d5     th5
%    6     0     0       d6     th6

%% creazione del manipolatore
%parametri DH UR5
alpha = [pi/2,0,0,pi/2,-pi/2,0]; %[in rad]
a = [0,-0.425,-0.39225,0,0,0]; %[in m]
d = [0.08916,0,0,0.10915,0.09456,0.0823]; %[in m]

%creare gli oggetti link associati al modello del robot (parametri DH)
L1 = Link('revolute', 'd', d(1), 'a', a(1), 'alpha', alpha(1)); %ogni link è un oggetto che ha metodi
L2 = Link('revolute', 'd', d(2), 'a', a(2), 'alpha', alpha(2));
L3 = Link('revolute', 'd', d(3), 'a', a(3), 'alpha', alpha(3));
L4 = Link('revolute', 'd', d(4), 'a', a(4), 'alpha', alpha(4));
L5 = Link('revolute', 'd', d(5), 'a', a(5), 'alpha', alpha(5));
L6 = Link('revolute', 'd', d(6), 'a', a(6), 'alpha', alpha(6));

UR5 = SerialLink([L1 L2 L3 L4 L5 L6]);
UR5.name='UR5';

%% Verifica configurazione di default
 q_init=[0,0,0,0,0,0];
    figure
    UR5.plot(q_init)
    title('conf iniziale')
    %UR5.teach
    UR5_offset=[-pi/2,-pi/2,0,-pi/2,0,-pi/2]; 
    figure
    UR5.plot(q_init+UR5_offset)
    title('conf iniziale ofsettata')


%% collegamento a Coppelia 
sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
sim.simxFinish(-1); % just in case, close all opened connections
    clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);
    
    if (clientID>-1)
         disp('Connected to remote API server');
         
    %joint handles
    h=[0,0,0,0,0,0]; %array di puntatori ai giunti, inizializzato a 0
    [returnCode,h(1)]=sim.simxGetObjectHandle(clientID,'UR5_joint1',sim.simx_opmode_blocking);
    [returnCode,h(2)]=sim.simxGetObjectHandle(clientID,'UR5_joint2',sim.simx_opmode_blocking);
    [returnCode,h(3)]=sim.simxGetObjectHandle(clientID,'UR5_joint3',sim.simx_opmode_blocking);
    [returnCode,h(4)]=sim.simxGetObjectHandle(clientID,'UR5_joint4',sim.simx_opmode_blocking);
    [returnCode,h(5)]=sim.simxGetObjectHandle(clientID,'UR5_joint5',sim.simx_opmode_blocking);
    [returnCode,h(6)]=sim.simxGetObjectHandle(clientID,'UR5_joint6',sim.simx_opmode_blocking);
   
    %gripper handle
    [returnCode, j1]=sim.simxGetObjectHandle(clientID, 'ROBOTIQ_85_active1',sim.simx_opmode_blocking); 
    [returnCode, j2]=sim.simxGetObjectHandle(clientID, 'ROBOTIQ_85_active2',sim.simx_opmode_blocking);
         
    
    %% Posizione di default
    joint_pos0=[0,0,0,0,0,0,0];
    
    for i=1:6 %porta il manipolatore in posizione di default (in modo da avere sempre le stesse condizioni iniziali)
        sim.simxSetJointTargetPosition(clientID,h(i),joint_pos0(i),sim.simx_opmode_streaming);
    end
    pause(1);   

    
    % scrivi qui il tuo codice
    

    joint_home=[0,pi/6,pi/4,-pi/2,-pi/2,0];
    UR5.plot( joint_home+UR5_offset);
    title('conf home')
    
  
    
    
    
    
   
    
    %% codice relativo alla connessione con Coppelia   
    else 
         disp('Failed connecting to remote API server');
    end
    sim.delete(); % call the destructor!
    
    disp('Program ended');
    
  
    for i=1:6 %porta il manipolatore in posizione di default (in modo da avere sempre le stesse condizioni iniziali)
        sim.simxSetJointTargetPosition(clientID,h(i), joint_home(i),sim.simx_opmode_streaming);
    end
    
    gripper(clientID,0,j1,j2); %%funzione data dal prof: clientID dice chi sta comunicando, 0=close 1=open, j1 e j2 sono i puntatori agli attuatori della pinza
    
     pause(0.5);
    
     %%PICK
     pos_object=[0.1,0.65,0.03];
     %pos gripper= 0.1 0.635 0.15
     %orientamento gripper=0 0 -pi/2 in angoli di roll pitch e yawl
     
     Tr_pick=transl(0.1,0.635,0.15)*rpy2tr(0,0,-pi/2,'xyz') % matrice di traformazioe: prodotto di quella di translazione per quella di rotazioen
     q_pick=UR5.ikine(Tr_pick,'u','q0',joint_home); %inverse kinematic,siccome abbiamo più soluzione toglia dei gradi di libertà facendo alcune richieste: 'u' significa arriva dal alto (a gomito alto)
                                                    %posizione di partenza:joint home
                                                    
    figure
    UR5.plot( q_pick);
                                                    
      for i=1:6
        sim.simxSetJointTargetPosition(clientID,h(i), q_pick(i)-UR5_offset(i),sim.simx_opmode_streaming);
      end
     pause(0.5);
     gripper(clientID,1,j1,j2);
     pause(0.5);
     
     %PLACE
     
      Tr_place=transl(-0.5,0.4,0.48)*rpy2tr(0,0,-pi/2,'xyz') % matrice di traformazioe: prodotto di quella di translazione per quella di rotazioen
     q_place=UR5.ikine(Tr_place,'u','q0',joint_home); %inverse kinematic,siccome abbiamo più soluzione toglia dei gradi di libertà facendo alcune richieste: 'u' significa arriva dal alto (a gomito alto)
                                                    %posizione di partenza:joint home
                                                    
    figure
    UR5.plot( q_place);
                                                    
      for i=1:6
        sim.simxSetJointTargetPosition(clientID,h(i), q_place(i)-UR5_offset(i),sim.simx_opmode_streaming);
      end
     pause(0.5);
     gripper(clientID,0,j1,j2);
     pause(0.5);
     
     for i=1:6 %porta il manipolatore in posizione di default (in modo da avere sempre le stesse condizioni iniziali)
        sim.simxSetJointTargetPosition(clientID,h(i), joint_home(i),sim.simx_opmode_streaming);
    end
    
    gripper(clientID,0,j1,j2); %%funzione data dal prof: clientID dice chi sta comunicando, 0=close 1=open, j1 e j2 sono i puntatori agli attuatori della pinza
    
     pause(0.5);