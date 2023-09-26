from Decolle_class import LIF_neuron, Network_decolle_II,Synapse_decolle
import numpy as np

from signal_creation import signal,dt
Num_step=signal.shape[0]

tau=25e-3
LIF_neuron.alfa=dt/tau
LIF_neuron.treshold=0.6

dim=[1,5,3,4,1]
N_of_layer=len(dim)
dim_in=dim[0]
dim_out=dim[N_of_layer-1]
lr=1e-1#learning rate
Synapse_decolle.lr=lr
meanW=(LIF_neuron.treshold/LIF_neuron.alfa)*3
varW=(LIF_neuron.treshold/LIF_neuron.alfa)
meanW_int=(LIF_neuron.treshold/LIF_neuron.alfa)/5
varW_int=(LIF_neuron.treshold/LIF_neuron.alfa)/10
Network=Network_decolle_II(dim=dim,saveU=1,saveS=1,saveAll=1,meanW=meanW,varW=varW,meanW_int=meanW_int,varW_int=varW_int)
print(Network.synapse[0].W)
print(Network.int_syn[1].W)
#meanW=np.max(signal),varW=np.max(signal)/4