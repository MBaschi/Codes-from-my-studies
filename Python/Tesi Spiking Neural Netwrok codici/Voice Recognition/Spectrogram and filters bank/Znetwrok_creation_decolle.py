from image_recognition.network_object import LIF_neuron, Network_decolle,Synapse_slayer, synapse,Layer_decolle,Neuron_slayer
import numpy as np
from signal_import import New_sample_spect,Label
from control_variable import SPECTROGRAM

if SPECTROGRAM: #se importo con spettro
  S_test,start,stop=New_sample_spect(LABEL=Label[0],show_signal=False)
  Num_step=S_test.shape[1]
  im_in=S_test.shape[0]
  EXTENSION=10
  LIF_neuron.treshold=0.009 

if not SPECTROGRAM: #se importo con filter bank
  dim_in=20
  Num_step=22050
  EXTENSION=1
  LIF_neuron.treshold=0.007

Layer_decolle.plot_type=1
dim_out=2
SAMPLING_FREQUENCY = 22050 # 1 sec. of audio
tau=0.3 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
tau_step=tau*Num_step*EXTENSION
#tau=5*dt #cosi lo scelgo io come multiplo di dt
LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
LIF_neuron.T_refactory=0 #periodo refrattario neuroni 

LIF_neuron.RestingPotential=0

dimhid1=25
dimhid2=10
dim=[dim_in,dimhid2,dim_out]
N_of_layer=len(dim)

lr=1e-4 #learning rate
Synapse_slayer.lr=lr
meanW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
varW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))

meanW_int=[]
varW_int=[]
for l in range(N_of_layer): #creo medie e varianze per inizzialzzare i pesi sinaptici dei layer d'uscita intermedi
  if l==0 or l==N_of_layer-1:
    meanW_int.append([])
    varW_int.append([])
  else:
   N_medio=dim[l]*0.3 #mediamente il neurone farà una spike se questo numero di neuroni avrà una spike
   N_var=dim[l]*0.1
   synapse.only_positive=False
   #meanW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_medio)
   #varW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_var)
   
   meanW_int.append(0)
   varW_int.append(np.sqrt(2/(dim[l]+2)))

Network=Network_decolle(dim=dim,saveU=1,saveS=1,saveAll=1,saveW=1,meanW=meanW,varW=varW,meanW_int=meanW_int,varW_int=varW_int)
Network.training_mode=True
Network.Freq_coding=True

#print(LIF_neuron.alfa)
#meanW=np.max(signal),varW=np.max(signal)/4