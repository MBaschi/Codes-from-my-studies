from A_DecolleClass import LIF_neuron, Network_decolle,Synapse_decolle, synapse
import numpy as np

from Variables import Num_label, Num_in_chan, SAMPLING_FREQUENCY

dt=(1/SAMPLING_FREQUENCY)
tau=0.3 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
#tau=300*dt #cosi lo scelgo io come multiplo di dt
LIF_neuron.alfa=dt/tau #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
LIF_neuron.treshold=0.007 #una corrente costante in ingresso con valore < treshold non produrra mai una spike (quindi è un cut off del segnale)
LIF_neuron.RestingPotential=0
dim_in=Num_in_chan
dim_out=Num_label
dimhid1=16
dimhid2=100
dim=[dim_in,dim_in-2,dim_out]
N_of_layer=len(dim)

lr=1.1#learning rate
Synapse_decolle.lr=lr
meanW=(LIF_neuron.treshold/LIF_neuron.alfa)*3
varW=(LIF_neuron.treshold/LIF_neuron.alfa)

meanW_int=[]
varW_int=[]
for l in range(N_of_layer): #creo medie e varianze per inizzialzzare i pesi sinaptici dei layer d'uscita intermedi
  if l==0 or l==N_of_layer-1:
    meanW_int.append([])
    varW_int.append([])
  else:
   N_medio=dim[l]*0.3 #mediamente il neurone farà una spike se questo numero di neuroni avrà una spike
   N_var=dim[l]*0.1
   #meanW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_medio)
   #varW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_var)
   synapse.only_positive=False
   meanW_int.append(0)
   varW_int.append(np.sqrt(2/(dim[l]+2)))

Network=Network_decolle(dim=dim,saveU=1,saveS=1,saveAll=1,saveW=1,meanW=meanW,varW=varW,meanW_int=meanW_int,varW_int=varW_int)
Network.training_mode=True

#meanW=np.max(signal),varW=np.max(signal)/4