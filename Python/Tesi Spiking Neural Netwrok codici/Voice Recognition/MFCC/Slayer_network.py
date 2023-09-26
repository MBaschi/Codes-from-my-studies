from Slayer_class import LIF_neuron, Network_slayer,Synapse_slayer, synapse,Layer_slayer
import numpy as np

from B_prepare_datset import Num_label, Num_mfcc, SAMPLING_FREQUENCY,hop_length

Layer_slayer.plot_type=1
EXTENSION=10
dt=(1/SAMPLING_FREQUENCY)*hop_length/EXTENSION
tau=0.1 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s

#tau=5*dt #cosi lo scelgo io come multiplo di dt
LIF_neuron.alfa=dt/tau #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
LIF_neuron.treshold=0.009 #una corrente costante in ingresso con valore < treshold non produrra mai una spike (quindi è un cut off del segnale)
LIF_neuron.RestingPotential=0
dim_in=Num_mfcc
dim_out=Num_label
dimhid1=13
dimhid2=100
dim=[dim_in,dimhid1,dim_out]
N_of_layer=len(dim)

lr=1e-5 #learning rate
Synapse_slayer.lr=lr
meanW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
varW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))

Network=Network_slayer(dim=dim,saveU=1,saveS=1,saveW=1,meanW=meanW,varW=varW)
Network.training_mode=True
Network.Freq_coding=False

#print(LIF_neuron.alfa)
#meanW=np.max(signal),varW=np.max(signal)/4