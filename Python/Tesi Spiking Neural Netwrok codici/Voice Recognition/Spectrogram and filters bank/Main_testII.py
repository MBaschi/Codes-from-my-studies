#ho un network che impara e uno che impara a distinguere le due sequenze del network precedente
print("______________________________________________________________________________INIZIO")
import numpy as np
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm

from control_variable import SHOW_SIGNAL_IMPORT,SHOW_LEARNING,Show_learn_interval
import image_recognition.network_object as no
from network_creation import Network,EXTENSION,Num_step,N_of_layer,dim_in,NetworkII
from various_function import Calculate_winner_neur,extendI,plot_I_in,plot_network
from signal_import import New_sample_spect,New_sample_filter_bank, Label
from control_variable import SPECTROGRAM

NetworkII.Freq_coding=False
NetworkII.spike_conv_mode=True

Network.Freq_coding=True
Network.spike_conv_mode=False
EPOCH=10

trainSizeI=int(300)
trainSizeII=int(300)
#int(X.shape[0])
training="Y" #per poter passare dalla molaità training a quella di prova

SPIKE_CALCULATOR=no.Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=2
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR.frequency_coding=True

SPIKE_CALCULATOR.type=2
SPIKE_CALCULATOR.winner_freq=0.8
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa
SPIKE_CALCULATOR.trh=Network.layer[0].neur[0].treshold

SPIKE_CALCULATOR_II=no.Objective_spike_bin()
SPIKE_CALCULATOR_II.Num_label=2
SPIKE_CALCULATOR_II.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR_II.frequency_coding=False
SPIKE_CALCULATOR_II.type=0
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa
SPIKE_CALCULATOR.trh=Network.layer[0].neur[0].treshold


Network.change_beta(0)

for e in range(EPOCH):
    
    print(f'Epoch {e}')
    
    #FASE DI TRAINING NETWORK I
    print("Training progress network I")
    Network.training_mode=True
    for i in tqdm(range(trainSizeI)):
       if i%2==0: 
          label=Label[0]
          winner_neur=0
       else:
          label=Label[1]
          winner_neur=1

       Network.reset()
       Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  

       I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*no.Neuron_slayer.treshold/no.Neuron_slayer.alfa)
       obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
       Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
   
    #FASE DI TRAINING NETWORK II
    Network.training_mode=False
    no.Synapse_slayer.lr=1e-3
    print("Training progress network II")
    for i in tqdm(range(trainSizeII)):
       if i%2==0: 
          label=Label[0]
          winner_neur=0
       else:
          label=Label[1]
          winner_neur=1
       
       Network.reset()
       NetworkII.reset()

       Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  
       I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*no.Neuron_slayer.treshold/no.Neuron_slayer.alfa)
       obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
       objII=SPIKE_CALCULATOR_II.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
      
       Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
       S_out=(Network.S_record[-2])*1.1*no.Neuron_slayer.treshold/no.Neuron_slayer.alfa
       NetworkII.run(num_step=Num_step*EXTENSION,I_in=S_out,obj=objII,WINNER=winner_neur)

       if i==300:
          NetworkII.change_beta(250)

       #mostra learning 
       if SHOW_LEARNING:
           if i%Show_learn_interval==0 or training=="N" :
             plt.figure("objective activity I")
             plt.plot(obj.T)
             plot_network(Network=Network,obj=obj)
             plt.show()
             plt.plot(objII.T)
             plot_network(Network=NetworkII,obj=objII)
             plt.show()
             training=input("Traning? Y/N:") 

print("______________________________________________________________________________FINE")        