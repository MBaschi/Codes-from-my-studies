import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import argrelextrema
from scipy.ndimage import shift

from signal_creation import signal,dt,Num_step,T
from network_creation import dim_in,dim_out

I_in=np.zeros((dim_in,Num_step))
delay=T/(7*dt)
plt.figure("Segnale shiftato per i vari neuroni")

for i in range(dim_in):
    I_in[i,:]=shift(signal, delay*i) 
    plt.plot(I_in[i,:])
plt.suptitle("Signal delayed")
plt.xlabel("Time step")


#SPIKE OBBBIETTIVO
S_obj=np.zeros((dim_out,Num_step))
for i in range(dim_out):
  S_obj[i,argrelextrema(shift(signal, delay*i), np.greater)]= 1

plt.figure("Spike obbiettivo")
for i in range(dim_out):
  S=[(i+1)*j for j in S_obj[i,:]]
  plt.plot(S,'k.',markersize=3)
plt.suptitle("Objective spike")
plt.xlabel("Time step")
plt.ylabel("Neuron Number")

plt.show()