from scipy.fft import fft, fftfreq
import numpy as np
import matplotlib.pyplot as plt
import os
from A_DecolleClass import Neuron_decolle,LIF_neuron


LIF_neuron.alfa=1/300#plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
print(LIF_neuron.alfa)
LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
LIF_neuron.treshold=0.009 #una corrente costante in ingresso con valore < treshold non produrra mai una spike (quindi è un cut off del segnale)
LIF_neuron.RestingPotential=0
neuroneo=Neuron_decolle(saveU=1,saveS=1,saveAll=1)


Num_step=1000
T=1
I=0
for t in range(Num_step):
    if t%T==0:
     I=10000
    else:
       I=0

    neuroneo.update_neur(I)

neuroneo.show()
plt.figure(2)
plt.plot(neuroneo.P_record)
plt.show()

