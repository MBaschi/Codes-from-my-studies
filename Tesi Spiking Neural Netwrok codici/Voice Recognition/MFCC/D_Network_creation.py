from A_DecolleClass import LIF_neuron, Network_decolle,Synapse_decolle, synapse,Layer_decolle
import numpy as np

from B_prepare_datset import Num_label, Num_mfcc, SAMPLING_FREQUENCY,hop_length

Layer_decolle.plot_type=1
EXTENSION=10
dt=(1/SAMPLING_FREQUENCY)*hop_length/EXTENSION
tau=0.1 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s

#tau=220*dt #cosi lo scelgo io come multiplo di dt
LIF_neuron.alfa=dt/tau #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso

LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
LIF_neuron.treshold=0.009 #una corrente costante in ingresso con valore < treshold non produrra mai una spike (quindi è un cut off del segnale)
LIF_neuron.RestingPotential=0
dim_in=Num_mfcc
dim_out=Num_label
dimhid1=9
dimhid2=100
dim=[dim_in,dimhid1,dim_out]
N_of_layer=len(dim)

lr=7e-5 #learning rate
Synapse_decolle.lr=lr
meanW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
varW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))

meanW_int=[]
varW_int=[]
for l in range(N_of_layer): #creo medie e varianze per inizzialzzare i pesi sinaptici dei layer d'uscita intermedi
  if l==0 or l==N_of_layer-1:
    meanW_int.append([])
    varW_int.append([])
  else:
   N_medio=dim[l]*10 #mediamente il neurone farà una spike se questo numero di neuroni avrà una spike
   N_var=dim[l]*1
   synapse.only_positive=False
   #meanW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_medio)
   #varW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_var)
   
   meanW_int.append(0)
   varW_int.append(np.sqrt(2/(dim[l]+2)))

Network=Network_decolle(dim=dim,saveU=1,saveS=1,saveAll=1,saveW=1,meanW=meanW,varW=varW,meanW_int=meanW_int,varW_int=varW_int)
Network.training_mode=True
Network.Freq_coding=False



#meanW=np.max(signal),varW=np.max(signal)/4