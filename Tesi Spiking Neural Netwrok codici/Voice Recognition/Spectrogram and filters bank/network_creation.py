import network_object as no
import numpy as np
from signal_import import New_sample_spect,Label
from control_variable import SPECTROGRAM,SLAYER,SHOW_LEARNING

if SPECTROGRAM: #se importo con spettro
  S_test,start,stop=New_sample_spect(LABEL=Label[0],show_signal_import=False)
  Num_step=S_test.shape[1]
  dim_in=S_test.shape[0]
  EXTENSION=3
  no.LIF_neuron.treshold=0.009 
  lr=1e-4 #learning rate

if not SPECTROGRAM: #se importo con filter bank
  dim_in=5
  Num_step=22050
  EXTENSION=1
  no.LIF_neuron.treshold=0.007
  lr=1e-1 #learning rate

SAMPLING_FREQUENCY = 22050 # 1 sec. of audio
tau=0.1 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
tau_step=tau*Num_step*EXTENSION
#tau=5*dt #cosi lo scelgo io come multiplo di dt
no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
no.LIF_neuron.RestingPotential=0


dim_out=2
dim=[dim_in,10,dim_out]
N_of_layer=len(dim)

meanW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))

meanW=0
#varW=2.5

if SLAYER:
  if SPECTROGRAM:no.Layer_slayer.plot_type=1
  if not SPECTROGRAM:no.Layer_slayer.plot_type=0
  no.Synapse_slayer.lr=lr
  Network=no.Network_slayer(dim=dim,saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)
  NetworkII=no.Network_slayer(dim=[10,dim_out],saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveW=SHOW_LEARNING,meanW=0,varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)/30)

  NetworkII.training_mode=True
  NetworkII.Freq_coding=True  
  NetworkII.change_beta(0)

if not SLAYER:
  if SPECTROGRAM:no.Layer_decolle.plot_type=1
  if not SPECTROGRAM:no.Layer_decolle.plot_type=0

  no.Synapse_decolle.lr=lr

  meanW_int=[]
  varW_int=[]
  for l in range(N_of_layer): #creo medie e varianze per inizzialzzare i pesi sinaptici dei layer d'uscita intermedi
    if l==0 or l==N_of_layer-1:
      meanW_int.append([])
      varW_int.append([])
    else:
     N_medio=dim[l]*0.3 #mediamente il neurone farà una spike se questo numero di neuroni avrà una spike
     N_var=dim[l]*0.1
     no.synapse.only_positive=False
     #meanW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_medio)
     #varW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_var)
     
     meanW_int.append(0)
     varW_int.append(np.sqrt(2/(dim[l]+2)))
  
  Network=no.Network_decolle(dim=dim,saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveAll=SHOW_LEARNING,saveW=SHOW_LEARNING,meanW=meanW,varW=varW,meanW_int=meanW_int,varW_int=varW_int)
  
Network.training_mode=True
Network.Freq_coding=True
Network.change_beta(0)