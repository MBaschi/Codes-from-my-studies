#Vorrei creare una rete che con l'algortmo decolle riconosca i massi di un segnale somma di più segnali sinosoidali
from Decolle_class import LIF_neuron, Network_decolle_I
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import argrelextrema
from scipy.ndimage.interpolation import shift

dt=1e-3
T=5 #tempo in secondi
#CREAZIONE SEGNALE
signal = np.sin(10*np.arange(0,T,dt))+np.sin(20*np.arange(0,T,dt))
print (argrelextrema(signal, np.greater))
if 1:#plot del segnale
 plt.suptitle("Signal")
 plt.xlabel("Time step")
 plt.plot(signal)
 plt.show()

#PARAMETRI NEURONI E SIMULAZIONE
Num_step=signal.shape[0]
tau=5e-3
LIF_neuron.alfa=dt/tau
LIF_neuron.treshold=np.max(signal)/2 #la treshold deve essere in qualche modo collegata al ampiezza del segnale
#network
dim_in=3
dim_hid=4
dim_out=1
lr=1e-3#learning rate
Network_decolle_I.lr=lr
network=Network_decolle_I(dim=[dim_in,dim_hid,dim_out],saveU=1,saveS=1,saveAll=1,meanW=0,varW=np.max(signal)/4)


"IN INGRESSO SEGNALE TRANSLATO"
if 1:
  #CORRENTE IN INGRESSO AI NEURONI
  network.reset()
  I_in=np.zeros((dim_in,Num_step))
  delay=T/(7*dt)
  plt.figure(1)
  for i in range(dim_in):
      I_in[i,:]=shift(signal, delay*i) 
      plt.plot(I_in[i,:])
  plt.suptitle("Signal delayed")
  plt.xlabel("Time step")

  #SPIKE OBBBIETTIVO
  S_obj=np.zeros((dim_out,Num_step))
  for i in range(dim_out):
    S_obj[i,argrelextrema(shift(signal, delay*i), np.greater)]= 1
  plt.figure(2)
  for i in range(dim_out):
    S=[(i+1)*j for j in S_obj[i,:]]
    plt.plot(S,'k.',markersize=3)
  plt.suptitle("Objective spike")
  plt.xlabel("Time step")
  plt.ylabel("Neuron Number")
  plt.show()

  #SIMULAZIONE
  network.run(num_step=Num_step,I_in=I_in,S_obj=S_obj)
  network.show()
  plt.show()
  network.debug_plot(0,Num_step)
  plt.show()  