import numpy as np

dt=1e-4
T=12 #tempo in secondi
signal = np.sin(8*np.arange(0,T,dt))+np.sin(9*np.arange(0,T,dt))+ np.ones(int(T/dt))
Num_step=signal.shape[0]

import matplotlib.pyplot as plt
def show_signal(show=False):
   plt.figure("Segnale")
   plt.suptitle("Signal")
   plt.xlabel("Time step")
   plt.plot(signal)
   plt.show()





