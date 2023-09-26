#Desiro creare un LIF model 


import numpy as np
import math  as m
import matplotlib.pyplot as plt

print("____________________________________________________ inizio ")
I_t=10  #Preshold curretn
tau=10  #time costant
V=0    #Potential of the membrane
V_t=[V] #potential in time
t_max=100   #simulation time
dt=0.1  #time resolution
t=0     # initial time

#altra opzione potevo creare un vettore t=np.arange(0,dt,t_tot)

w=5    #synaptic weigth

I_in=np.zeros(int(t_max/dt)) 
I_in[int(10/dt)]=1           #input spike at t=10

V_treshold=0.5

while t<t_max:
    V=V+(-V+w*I_in[t])*dt/tau

    if V>V_treshold:
        V=0
        spike=1
    else:
        spike=0
     
    t+=dt

z=range(int(t_max/dt)+2)
plt.plot(z,V_t,z,I_t*np.ones(int(t_max/dt)+2),'r--')
plt.show()
print("____________________________________________________ fine ")
    
#forse posso anche scriverlo come classe
class LIF:
    dt=1e-4
    tau=1e-3

    def __init__(self):
      self.mem=0
      self.spike=0
    

    def update_pot(self,I_in):

        self.mem+=-self.mem*dt/self.tau+I_in

        if self.mem>V_t:
         self.mem=0  
         self.spike=1
    
        else:
         self.spike=0

        return self.mem,self.spike


ne=np.zeros(5)

for i in range(5):
    ne[i]=LIF_c