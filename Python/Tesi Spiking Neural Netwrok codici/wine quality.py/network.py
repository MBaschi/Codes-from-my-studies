import network_object as no
import numpy as np
from control_variable import SHOW_LEARNING,lr


Num_step=1000
dim_in=13
no.LIF_neuron.treshold=0.185
tau=0.01 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
tau_step=tau*Num_step
tau_step=50#cosi lo scelgo io come multiplo di dt
no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
no.LIF_neuron.RestingPotential=0

dim_out=3
dim=[dim_in,5,dim_out]
N_of_layer=len(dim)

meanW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))

meanW=0
varW=5

no.Layer_slayer.plot_type=0
no.Synapse_slayer.lr=lr
no.Synapse_slayer.confine_val=True
no.Synapse_slayer.max_val=1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
no.Synapse_slayer.min_val=-1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
Network=no.Network_slayer(dim=dim,saveU=1,saveS=1,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)

Network.training_mode=True
Network.Freq_coding=True
Network.statit_dataset=True
Network.change_beta(0)