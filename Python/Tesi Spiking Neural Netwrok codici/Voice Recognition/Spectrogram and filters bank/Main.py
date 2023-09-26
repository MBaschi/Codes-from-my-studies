print("______________________________________________________________________________INIZIO")
import numpy as np
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm

from control_variable import SHOW_SIGNAL_IMPORT,SHOW_LEARNING,Show_learn_interval
from network_object import Neuron_slayer,Neuron_decolle,Objective_spike_bin
from network_creation import Network,EXTENSION,Num_step,N_of_layer,dim_in
from various_function import Calculate_winner_neur,extendI,plot_I_in,plot_network
from signal_import import New_sample_spect,New_sample_filter_bank, Label
from control_variable import SPECTROGRAM

Network.Freq_coding=False
Network.spike_conv_mode=True
EPOCH=10

trainSize=int(500)
testSize=int(3000)
#int(X.shape[0])
training="Y" #per poter passare dalla molaità training a quella di prova

SPIKE_CALCULATOR=Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=2
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR.frequency_coding=True

SPIKE_CALCULATOR.type=2
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa
SPIKE_CALCULATOR.trh=Network.layer[0].neur[0].treshold

SPIKE_CALCULATOR.spike_interval=[100,300]
SPIKE_CALCULATOR.winner_freq=1.5
SPIKE_CALCULATOR.loser_freq=0.2
SPIKE_CALCULATOR.baseline_freq=0

Network.change_beta(0)

for e in range(EPOCH):
    
    print(f'Epoch {e}')
    
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for i in tqdm(range(trainSize)):
       if i%2==0: 
          label=Label[0]
          winner_neur=0
       else:
          label=Label[1]
          winner_neur=1
       
       if SPECTROGRAM:
          Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  
          I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
          obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
          Network.reset()
          Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
       
       if not SPECTROGRAM:
          I_in,start,stop=New_sample_filter_bank(LABEL=label,num_filter=dim_in,Max_freq=1e4,show_signal_import=SHOW_SIGNAL_IMPORT)  
          obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
          Network.reset()   
          Network.run(num_step=Num_step*EXTENSION,I_in=I_in,obj=obj) 
     
       #mostra learning 
       if SHOW_LEARNING:
           if i%Show_learn_interval==0 or training=="N" :
             plot_I_in(I_in)
             plt.figure("objective activity")
       
             plt.plot(obj.T,label=["Winner class","Lossing class"])
             plt.xlabel("Simulation step")
             plt.ylabel("Error")
             plt.yticks([])
             plt.legend(loc="upper left")
             plot_network(Network=Network,obj=obj)
             plt.show()
  
             training=input("Traning? Y/N:") 
             if training=="Y": Network.training_mode=True
             if training=="N": Network.training_mode=False
    
    #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    No_guessed=0
    Yes_guessed=0
    for i in tqdm(range(testSize)):
       if i%2==0: 
          label=Label[0]
          winner_neur=0
       else:
          label=Label[1]
          winner_neur=1
       Network.reset()
       Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  

       I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
       obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
       Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
       neur=Network.Calculate_winner_neur(start=start*EXTENSION)
       
       if neur==winner_neur:
            correct_guess+=1
            if label==Label[0]:
               No_guessed+=1
            else:
               Yes_guessed+=1 

    print(f"Accuracy={(correct_guess/testSize)*100}") 
    print(Label[0]+f" guessed={No_guessed}")   
    print(Label[1]+f" guessed={Yes_guessed}")

print("______________________________________________________________________________FINE")        