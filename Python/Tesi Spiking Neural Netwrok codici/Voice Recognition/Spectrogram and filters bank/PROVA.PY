import numpy as np
import matplotlib.pyplot as plt
from network_object import Neuron_slayer
from scipy.signal import convolve2d

Num_step=1000
alfa=1/100
start=200
stop=500

S_out_record=np.zeros(Num_step)
S_obj=np.zeros(Num_step)
S_out_record[300]=1
flip_spike_response=np.flip(np.power((1-alfa),np.arange(Num_step)))
e=sc.convolve(S_out_record,flip_spike_response)[Num_step:2*Num_step]
plt.plot(e)
plt.show()