function  gripper (clientID, closing, j1, j2)
%questa funzione è uguale a quella presente nel codice di default del
%gripper in CoppeliaSim. é tuttavia implementata in Matlab in modo da poter
%controllare il gripper in maniera sincrona all'esecuzione dello script

sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)


[r, p1]=sim.simxGetJointPosition(clientID,j1,sim.simx_opmode_blocking);
[r, p2]=sim.simxGetJointPosition(clientID,j2,sim.simx_opmode_blocking);

if (closing==1)
    if (p1 < (p2-0.008)) %tolleranza
        sim.simxSetJointTargetVelocity (clientID, j1,-0.01, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity (clientID, j2,-0.04, sim.simx_opmode_blocking);
    else
        sim.simxSetJointTargetVelocity (clientID, j1,-0.04, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity (clientID, j2,-0.04, sim.simx_opmode_blocking);
    end
else
    p1 = 1;
    p2 = 3;
    if (p1<p2)
        sim.simxSetJointTargetVelocity (clientID, j1,0.04, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity (clientID, j2,0.02, sim.simx_opmode_blocking);
    else
        sim.simxSetJointTargetVelocity (clientID, j1,0.02, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity (clientID, j2,0.04, sim.simx_opmode_blocking);
    end
    
end

 end
