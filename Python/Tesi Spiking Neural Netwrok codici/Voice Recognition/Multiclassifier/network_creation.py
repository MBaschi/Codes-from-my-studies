import no
import numpy as np
from function import New_sample_spect,Label
from control_variable import SPECTROGRAM,SLAYER,SHOW_LEARNING,lr

if SPECTROGRAM: #se importo con spettro
  S_test,start,stop=New_sample_spect(LABEL=Label[0],show_signal_import=False)
  Num_step=S_test.shape[1]
  dim_in=S_test.shape[0]
  EXTENSION=30
  no.LIF_neuron.treshold=0.009 


if not SPECTROGRAM: #se importo con filter bank
  dim_in=20
  Num_step=22050
  EXTENSION=1
  no.LIF_neuron.treshold=0.007


SAMPLING_FREQUENCY = 22050 # 1 sec. of audio
tau=0.2 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
tau_step=tau*Num_step*EXTENSION
#tau=5*dt #cosi lo scelgo io come multiplo di dt
no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
no.LIF_neuron.RestingPotential=0


dim_out=len(Label)

dim=[dim_in,30,10,dim_out]
N_of_layer=len(dim)

meanW=0
varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*1/3

if SLAYER:
  if SPECTROGRAM:no.Layer_slayer.plot_type=1
  if not SPECTROGRAM:no.Layer_slayer.plot_type=0
  no.Synapse_slayer.lr=lr
  no.Synapse_slayer.confine_val=True
  no.Synapse_slayer.max_val=1.5*no.LIF_neuron.treshold/no.LIF_neuron.alfa
  no.Synapse_slayer.min_val=-1.5*no.LIF_neuron.treshold/no.LIF_neuron.alfa 
  Network=no.Network_slayer(dim=dim,saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveW=1,meanW=meanW,varW=varW)
  NetworkII=no.Network_slayer(dim=[dim_out,5,dim_out],saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveW=SHOW_LEARNING,meanW=0,varW=varW)

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
Network.Freq_coding=False#True 
Network.spike_conv_mode=False#True
Network.change_beta(0)