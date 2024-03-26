#ho solo due segnali da imparare 
print("______________________________________________________________________________INIZIO")
import numpy as np
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm

from control_variable import SHOW_SIGNAL_IMPORT,SHOW_LEARNING,Show_learn_interval,SPECTROGRAM
from  image_recognition.network_object import Neuron_slayer,Neuron_decolle,Objective_spike_bin
#from network_creation_slayer import Network,EXTENSION,Num_step,N_of_layer
#from netwrok_creation_decolle import Network,EXTENSION,Num_step,N_of_layer
from network_creation import Network,EXTENSION,Num_step,N_of_layer
from various_function import Calculate_winner_neur,extendI,plot_I_in,plot_network
from signal_import import New_sample_spect, Label

EPOCH=10

trainSize=int(1000)
testSize=int(1)
#int(X.shape[0])

SPIKE_CALCULATOR=Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=2
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR.frequency_coding=True

SPIKE_CALCULATOR.winner_freq=0.3
SPIKE_CALCULATOR.loser_freq=0.1
SPIKE_CALCULATOR.baseline_freq=0
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa
SPIKE_CALCULATOR.trh=Network.layer[0].neur[0].treshold
SPIKE_CALCULATOR.type=0
SPIKE_CALCULATOR.spike_interval=[200,300]

err=[]
Network.change_beta(0)
Spect,start,stop=New_sample_spect(LABEL=Label[0],show_signal_import=True)  
I_in_yes,S_yes=extendI(Spect,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
obj_yes=SPIKE_CALCULATOR.Calculate(label=0,start=start*EXTENSION,stop=stop*EXTENSION)

Spect,start,stop=New_sample_spect(LABEL=Label[1],show_signal_import=True)  
I_in_no,S_no=extendI(Spect,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
obj_no=SPIKE_CALCULATOR.Calculate(label=1,start=start*EXTENSION,stop=stop*EXTENSION)


for e in range(EPOCH):
    
    print(f'Epoch {e}')
   
    Network.training_mode=True
    for i in tqdm(range(trainSize)):
       if i%60<30: 
          label=Label[0]
          winner_neur=0
          if SPECTROGRAM:S=S_yes
          if not SPECTROGRAM:S=I_in_yes
          obj=obj_yes
       else:
          label=Label[1]
          winner_neur=1
          if SPECTROGRAM:S=S_no
          if not SPECTROGRAM:S=I_in_no
          obj=obj_no

       Network.reset()
       Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
       if i==100:
          pass
          #Network.change_beta(500)
       #print(Network.total_err[-1])
       #err.append(Network.total_err[-1])   
   
       if SHOW_LEARNING:
           if i%Show_learn_interval==0 or i%(Show_learn_interval+1)==0 :
             if not SPECTROGRAM:plot_I_in(S)
             plt.figure("objective activity")
             plt.plot(obj.T)
             plot_network(Network=Network,obj=obj)
             plt.show()
                
    plt.plot(err)
    plt.show() 

print("______________________________________________________________________________FINE")        