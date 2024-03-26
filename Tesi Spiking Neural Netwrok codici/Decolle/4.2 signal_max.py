# e praticamente identico al 4.1 ma ilo segnale è ripetuto in modo periodico, così la rete può riazzerarsi, questa pausa è un po come avere delle epoch

#Vorrei creare una rete che con l'algortmo decolle riconosca i massi di un segnale somma di più segnali sinosoidali
from Decolle_class import LIF_neuron, Network_decolle_II,Synapse_decolle
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import argrelextrema
from scipy.ndimage import shift

fig=1

#CREAZIONE SEGNALE
if 1:
  dt=1e-4
  T=2 #tempo in secondi
  signal = np.sin(7*np.arange(0,T,dt))+np.sin(4*np.arange(0,T,dt))+ np.ones(int(T/dt))
  repetition=5
  pause_time=0.5
  Num_step=repetition*signal.shape[0]+(repetition-1)*int(pause_time/dt)
  signal_repeated=np.zeros(Num_step)
  t=0
  for i in range(repetition):
    signal_repeated[t:t+signal.shape[0]]=signal
    t+=signal.shape[0]+int(pause_time/dt)

#PARAMETRI NEURONI E SIMULAZIONE

tau=25e-3
LIF_neuron.alfa=dt/tau
fmax=1e2 #100 spike al secondo che equivale a 1 spike ogni 10 ms
LIF_neuron.treshold=(1-np.exp(-1/(tau*fmax)))*np.max(signal) 
print(LIF_neuron.treshold)
LIF_neuron.treshold=0.6

neur_test=LIF_neuron(1,0)
neur_test.treshold=np.max(signal)*2
for n in range(Num_step):
  I=0
  if n==10: I=np.max(signal)
  neur_test.update(I)

if 1:#plot del segnale
 plt.figure("Segnale e risposta neurone")
 plt.suptitle("Signal")
 plt.xlabel("Time step")
 plt.plot(signal_repeated)
 plt.plot(neur_test.U_record)
 fig+=1

#network
dim=[1,20,1]
dim_in=dim[0]
dim_out=dim[len(dim)-1]
lr=1e-3#learning rate
Synapse_decolle.lr=1
network=Network_decolle_II(dim=dim,saveU=1,saveS=1,saveAll=1,meanW=np.max(signal),varW=np.max(signal)/4)

"IN INGRESSO SEGNALE TRANSLATO"
if 1:
  #CORRENTE IN INGRESSO AI NEURONI
 
  I_in=np.zeros((dim_in,Num_step))
  delay=T/(7*dt)
  plt.figure("Segnale shiftato per i vari neuroni")
  fig+=1
  for i in range(dim_in):
      I_in[i,:]=shift(signal_repeated, delay*i) 
      plt.plot(I_in[i,:])
  plt.suptitle("Signal delayed")
  plt.xlabel("Time step")

  #SPIKE OBBBIETTIVO
  S_obj=np.zeros((dim_out,Num_step))
  for i in range(dim_out):
    S_obj[i,argrelextrema(shift(signal_repeated, delay*i), np.greater)]= 1
 
  for i in range(dim_out):
    t=signal.shape[0]
    for j in range(repetition-1):
      S_obj[i,t:t+int(pause_time/dt)]=0
      t+=int(pause_time/dt)+signal.shape[0]
  plt.figure("Spike obbiettivo")
  fig+=1
  for i in range(dim_out):
    S=[(i+1)*j for j in S_obj[i,:]]
    plt.plot(S,'k.',markersize=3)
  plt.suptitle("Objective spike")
  plt.xlabel("Time step")
  plt.ylabel("Neuron Number")
  

  #SIMULAZIONE
  if 0:
    network.reset()
    network.training_mode=False
    network.run(num_step=Num_step,I_in=I_in,S_obj=S_obj)
    fig=network.show(fig=fig)
    plt.show()
  
  network.reset()
  network.training_mode=True
  network.run(num_step=Num_step,I_in=I_in,S_obj=S_obj)
  fig=network.show(fig=fig)
  network.Algorithm_var_plot(num_fig=fig)
  plt.show() 
 
  network.reset()
  network.training_mode=False
  network.run(num_step=Num_step,I_in=I_in,S_obj=S_obj)
  fig=network.show(fig=fig)
  plt.show() 
  

