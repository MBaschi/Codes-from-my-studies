import numpy as np
import matplotlib.pyplot as plt
import network_object as no
np.set_printoptions(2)

Num_step=1000
no.LIF_neuron.treshold=0.01
tau_step=99#cosi lo scelgo io come multiplo di dt
no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
no.LIF_neuron.RestingPotential=0
I_1=[1,2,3,4,5,7,10,20]
num_neuron=len(I_1)
self=no.Layer_slayer(dim=num_neuron,saveS=1,saveU=1)
def ones_zero(duration,periodicity):# ritorna un vettore di durata duration, sotto tutti 0 tranne ogni periodicity che ho un 1
        v=np.zeros(duration)
        for n in range(duration):
            if n%periodicity==0: v[n]=1
        return v
#f=np.arange(start=0.1,stop=1.1,step=1/num_neuron)
#f=[0.001,0.01,0.1,0.2,0.3,0.4,0.50,0.005,1,0.9]
I=1/np.array(I_1)
for n in range(Num_step):
     self.update_layer(I)


plt.figure(f"a")
x=np.arange(0,len(self.neur[0].P_record),1)
v=np.ones(len(self.neur[0].P_record))
for i in range(self.dim):
 plt.plot(self.neur[i].P_record,label=f"{I[i]}")
 
plt.xlabel("Time step")
plt.ylabel("a")
plt.legend(title="Neuron output frequency")
plt.yticks(np.arange(start=0,stop=1,step=0.1))
plt.show()
self.Algorithm_var_plot()
self.show()

"""T_max=no.LIF_neuron.T_refactory-tau_step*np.log(1+no.LIF_neuron.RestingPotential-no.LIF_neuron.treshold)
print(T_max/4)
no.NeuronI.T=T_max/4
no.NeuronI.theta=0.05
layer=no.Layer_I(1,1,1,1)
I=0.3*np.ones(Num_step)

for t in range(Num_step):
    layer.update_layer(I=I)

layer.show()
layer.Algorithm_var_plot()
plt.show()"""