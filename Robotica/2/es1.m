%% Codice di default da usare per far comunicare Matlab e CoppeliaSim

clear all
close all
clc

% NOTA: scrivere “ simRemoteApi.start(19999) ”  nella linea di comando di CoppeliaSim
% per avviare la comunicazione
 
sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
sim.simxFinish(-1); % just in case, close all opened connections
    clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);
    
    if (clientID>-1)
         disp('Connected to remote API server');
        
    % scrivi qui il tuo codice relativo all'interazione con Coppelia
         %% Puntatori ai giunti del manipolatore
         
         h=[0,0,0,0,0,0,0]; %array di puntatori ai giunti, inizializzato a 0
         [r,h(1)]=sim.simxGetObjectHandle(clientID,'LBR_iiwa_7_R800_joint1',sim.simx_opmode_blocking); %crea un handle/puntatore h(1) al primo giunto. 'r' contiene un "return code" che non utilizzeremo
          [r,h(2)]=sim.simxGetObjectHandle(clientID,'LBR_iiwa_7_R800_joint2',sim.simx_opmode_blocking);
          [r,h(3)]=sim.simxGetObjectHandle(clientID,'LBR_iiwa_7_R800_joint3',sim.simx_opmode_blocking);
          [r,h(4)]=sim.simxGetObjectHandle(clientID,'LBR_iiwa_7_R800_joint4',sim.simx_opmode_blocking);
          [r,h(5)]=sim.simxGetObjectHandle(clientID,'LBR_iiwa_7_R800_joint5',sim.simx_opmode_blocking);
          [r,h(6)]=sim.simxGetObjectHandle(clientID,'LBR_iiwa_7_R800_joint6',sim.simx_opmode_blocking);
          [r,h(7)]=sim.simxGetObjectHandle(clientID,'LBR_iiwa_7_R800_joint7',sim.simx_opmode_blocking);
         
         %% Configurazioni
       
         joint_pos0=[0,0,0,0,0,0,0];
         joint_pos1=[-pi/2,pi/6,-pi/6,-pi/3,pi/2,pi/12,0];
         joint_pos2=[0,pi/4,-pi/6,-pi/3,pi/6,pi/3,pi/2];
         joint_pos3=[2*pi/3,pi/3,0,-pi/2,0,pi/6,-pi/2];
         
         %% Comandare il moto del manipolatore in Coppeliasim
         for i=1:7
         sim.simxSetJointTargetPosition(clientID,h(i),joint_pos0(i),sim.simx_opmode_streaming);
         end 
         pause(7); %pausa di 7 secondi
         
         for counter=1:2
              for i=1:7
             sim.simxSetJointTargetPosition(clientID,h(i),joint_pos1(i),sim.simx_opmode_streaming);
              end
              pause(7);
             for i=1:7
             sim.simxSetJointTargetPosition(clientID,h(i),joint_pos2(i),sim.simx_opmode_streaming);
             end
              pause(7);
              for i=1:7
              sim.simxSetJointTargetPosition(clientID,h(i),joint_pos3(i),sim.simx_opmode_streaming);
              end 
              pause(7);
               for i=1:7
             sim.simxSetJointTargetPosition(clientID,h(i),joint_pos2(i),sim.simx_opmode_streaming);
               end
                pause(7);
              for i=1:7
             sim.simxSetJointTargetPosition(clientID,h(i),joint_pos3(i),sim.simx_opmode_streaming);
              end
              pause(7);
         end 
         
         
         
         
         
    else 
         disp('Failed connecting to remote API server');
    end
    sim.delete(); % call the destructor!
    
    disp('Program ended');