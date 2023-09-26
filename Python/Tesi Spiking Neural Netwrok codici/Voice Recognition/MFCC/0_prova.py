from scipy.fft import fft, fftfreq
from sklearn import preprocessing as pre
import numpy as np
import matplotlib.pyplot as plt
import os
from A_DecolleClass import Neuron_decolle,LIF_neuron

step=3000
LIF_neuron.alfa=0.00580
LIF_neuron.alfa=0.01
a=1*np.ones(step)
a[300:500]=4
b=np.power((1-LIF_neuron.alfa),np.arange(step))
plt.plot(a)
plt.plot(b)
x=np.convolve(a,b)

plt.plot(x)
plt.show()