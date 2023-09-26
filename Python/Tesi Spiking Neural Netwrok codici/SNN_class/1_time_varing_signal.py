#intendo sviluppare una rete neurale spiking per l'analisi di segnali tempo varianti. 
#un segnale temporale è monodimensionale come lo decodifico?
#un solo neurone non va bene perche se traslo il segnale di poco cambia completamente la trascrizione
#quello che ho pensato è di avere N neuroni in ingresso che decodificano il segnale translato

from basic_class import LIF_neuron, LIF_layer, Network
import numpy as np
import matplotlib.pyplot as plt

dt=1e-3
T=30 #tempo in secondi
#CREAZIONE SEGNALE
signal = np.sin(np.arange(0,T,dt))+np.sin(2*np.arange(0,T,dt))
if 0:#plot del segnale
 plt.figure(7)
 plt.plot(signal)
 plt.show()

#PARAMETRI NEURONI E SIMULAZIONE
Num_step=signal.shape[0]
tau=5e-3
LIF_neuron.alfa=dt/tau
LIF_neuron.treshold=np.max(signal)/2 #la treshold deve essere in qualche modo collegata al ampiezza del segnale
#network
dim_in=4
dim_hid=5
dim_out=3
network=Network(dim_in,dim_hid,dim_out,saveU=1,saveS=1,meanW=0,varW=np.max(signal)/4)
"IN INGRESSO IL SEGNALE NON TRANSALATO"
if 0:
  #CORRENTE IN INGRESSO AI NEURONI
  I_in=np.zeros((dim_in,Num_step))
  for i in range(dim_in):
      I_in[i,:]=signal
  #SIMULAZIONE
  network.run(num_step=Num_step,I_in=I_in)
  network.show()
  plt.show()

"IN INGRESSO SEGNALE TRANSLATO"
if 1:
  #CORRENTE IN INGRESSO AI NEURONI
  network.reset()
  I_in=np.zeros((dim_in,Num_step))
  delay=T/(10*dt)
  for i in range(dim_in):
      I_in[i,:]= np.sin(np.arange(0,30,dt)+delay*i)+np.sin(2*np.arange(0,30,dt)+delay*i)
      plt.plot(I_in[i,:])
  plt.show()
  #SIMULAZIONE
  network.run(num_step=Num_step,I_in=I_in)
  network.show()
  plt.show()  

