from image_recognition.network_object import LIF_neuron, Network_slayer,Synapse_slayer, synapse,Layer_slayer,Neuron_slayer
import numpy as np
from signal_import import New_sample_spect,Label
from control_variable import SPECTROGRAM

if SPECTROGRAM: #se importo con spettro
  S_test,start,stop=New_sample_spect(LABEL=Label[0],show_signal=False)
  Num_step=S_test.shape[1]
  im_in=S_test.shape[0]
  EXTENSION=10
  LIF_neuron.treshold=0.009 
  lr=1e-3 #learning rate

if not SPECTROGRAM: #se importo con filter bank
  dim_in=20
  Num_step=22050
  EXTENSION=1
  LIF_neuron.treshold=0.007
  lr=1e-1 #learning rate


Layer_slayer.plot_type=0
SAMPLING_FREQUENCY = 22050 # 1 sec. of audio
tau=0.1 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
tau_step=tau*Num_step*EXTENSION
#tau=5*dt #cosi lo scelgo io come multiplo di dt
LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
LIF_neuron.RestingPotential=0

dimhid1=13
dimhid2=100
dim_out=2
dim=[dim_in,dimhid1,dim_out]
N_of_layer=len(dim)


Synapse_slayer.lr=lr
meanW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
varW=(LIF_neuron.treshold/LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))

meanW=0
varW=2.5

Network=Network_slayer(dim=dim,saveU=1,saveS=1,saveW=1,meanW=meanW,varW=varW)
Network.training_mode=True
Network.Freq_coding=True

#print(LIF_neuron.alfa)
#meanW=np.max(signal),varW=np.max(signal)/4