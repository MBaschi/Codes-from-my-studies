from network_object import LIF_neuron, synapse,Network_slayer,Neuron_slayer
import numpy as np
import matplotlib.pyplot as plt

neuroneA=Neuron_slayer()
neuroneA.update(0)
neuroneB=LIF_neuron(saveS=1,saveU=1)

neuroneB.treshold=2
neuroneA.alfa=0.001

Num_step=1000
I_in=np.zeros(Num_step)
I_in[200]=1000
I_in[300:400]=1

for t in range(Num_step):
    neuroneA.update(I_in=I_in[t])

neuroneA.show()
plt.show()

neta=Network_slayer(dim=[5,10,23,8])
I_in=np.zeros((5,Num_step))
print("done")