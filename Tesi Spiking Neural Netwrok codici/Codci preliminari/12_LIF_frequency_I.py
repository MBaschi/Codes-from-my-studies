import numpy as np
import matplotlib.pyplot as plt

class LIF_neuron: #neurone leaky integrate and fire
    treshold=1
    alfa=0.9 #alfa=dt/tau
    def __init__(self,saveU=0,saveS=0): 
        self.U=0 #potenziale di membrana
        self.nextU=0

        self.saveU=saveU
        self.saveS=saveS
        if saveU: #richiesta di salvare i valori del potenzaile (da default falso)       
         self.U_record=[] 
        if saveS: #richiesta di salvare i valori delle spike (da default falso)
         self.S_record=[]
        
    def update(self,I_in): #simula il neurone dal tempo t al t+1 (questa funzione dovrà essere inserita in un for)
        spike=0
        
        self.U=self.nextU
        self.U+=(-self.U+I_in)*self.alfa

        self.nextU=self.U
        if self.U>self.treshold:
            spike=1
            self.nextU=0  
        
        if 1: #salvataggio
          if self.saveU:
              self.U_record.append(self.U)
          if self.saveS:
              self.S_record.append(spike)

        return spike

    def reset(self):
        self.U=0
        if self.saveU:
              self.U_record=[]
        if self.saveS:
              self.S_record=[]
    
    def show(self): #plotta il potenziale o le spike a seconda se sono state richieste o no
        if self.saveU==0 and self.saveS==0:
            print("plot non non abilitato")
        
        if self.saveU==1 and self.saveS==1:
         step=np.size(np.array(self.U_record))
         x=range(step)
         plt.plot(x,self.U_record,x,self.treshold*np.ones(step),'r--',x,1.1*self.treshold*np.array(self.S_record),'o')
        
        if self.saveU==0 and self.saveS==1:
         step=np.size(np.array(self.S_record))
         plt.plot(self.S_record,'o')
        
        if self.saveU==1 and self.saveS==0:
         step=np.size(np.array(self.U_record))
         x=range(step)
         plt.plot(x,self.U_record,x,self.treshold*np.ones(step),'r--')

        plt.xlabel("Time step")
        plt.show()
def f(I,T_ref,tau,v_th,v_reset):
   return 1/(T_ref-tau*np.log((v_th-v_reset-I)/(-I)))

T_max=2 #tempo di simulazione
dt=1e-3 #risoluzione temporale
T=np.arange(0,T_max,dt)


neur=LIF_neuron(1,1)
tau=0.3
neur.treshold=0.1
neur.alfa=dt/tau 


I_max=1.1
dI=0.01 #risoluzione corrrente
I=np.arange(0,I_max,dI)
T_ref=[0,2,10,100]
tau=[0,10,100,1000]
v_th=[0.1 ,0.5,0.7,0.9]
v_reset=[-1,-0.5,0,0.5]


for j in T_ref:
   plt.plot(I,f(I,j,tau=100,v_th=0.1,v_reset=0),label=f"Refactory period={j}")

plt.xlabel("I")
plt.ylabel("f")
plt.legend(loc="upper right")
plt.show()

   
"""
for t in T:
   neur.update(0.5)

neur.show()
plt.show()
"""
"""tau_max=100e-3
tau_min=5e-3
dtau=10e-3
TAU=np.arange(tau_min,tau_max,dtau)
for tau in TAU:
  print(tau)
  neur.treshold=I_max/10
  neur.alfa=dt/tau"""


"""f=[]
for i in I:
 for t in T:
   neur.update(i)
 f.append((np.sum(neur.S_record)/int(T_max/dt)))

plt.plot(I,f)
plt.xlabel("input current")
plt.ylabel("frequecncy spike/second")
plt.show()"""