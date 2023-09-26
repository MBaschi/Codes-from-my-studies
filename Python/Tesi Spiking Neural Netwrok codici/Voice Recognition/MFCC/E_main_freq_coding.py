print("______________________________________________________________________________INIZIO")
import numpy as np

from A_DatasetPreparationFunctions import Objective_spike_bin
from B_prepare_datset import Num_step
from C_Signal_creation import X,S_obj,y,start,stop,file_path
#from A_DecolleClass import Neuron_decolle, Synapse_decolle,Layer_decolle
from D_Network_creation import Network,N_of_layer,EXTENSION
#from Slayer_network import Network,N_of_layer,EXTENSION
from Slayer_class import Neuron_slayer,Objective_spike_bin
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm
from Various_function import Calculate_winner_neur,extendI,plot_I_in

Network.Freq_coding=True

EPOCH=10
SHOW_LEARNING=1

trainSize=int(1000)
testSize=int(100)
#int(X.shape[0])
training="Y" #per poter passare dalla molaità training a qella di prova

SPIKE_CALCULATOR=Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=2
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR.frequency_coding=True
SPIKE_CALCULATOR.winner_freq=0.2
SPIKE_CALCULATOR.loser_freq=0.07
SPIKE_CALCULATOR.baseline_freq=0
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa

#Network.synapse[0].plot_val(0) #stampa pesi sinaptici iniziali

for e in range(EPOCH):
    
    print(f'Epoch {e}')
    
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for j in tqdm(range(trainSize)):

     i=randint(0,X.shape[0]-1)
     I_in=X[i].transpose()
     I_in,S=extendI(I_in,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
     obj=SPIKE_CALCULATOR.Calculate(label=y[i],start=start[i]*EXTENSION,stop=stop[i]*EXTENSION)
     plt.plot(obj.T)

     t=np.arange(start=0,stop=Num_step,step=1)/Num_step
     plt.imshow(X[i].transpose())
     plt.xlabel("Time[s]")
     plt.ylabel("MFCC coefficient")

     plt.show()

     Network.reset()
     Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)

     #cambia la beta della surrgrad function dopo un po di sample
     if j==1:
       Neuron_slayer.beta=4.1
       
     #mostra learning in modo statico
     if SHOW_LEARNING:
         if j%300==0 or training=="N":
           plot_I_in(I_in)
           Network.show(S_obj=obj)
           Network.Algorithm_var_plot()
           if training=="Y":
            Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2,interactive= False,start_blank=False)
            Network.synapse[N_of_layer-3].show(layer_number=N_of_layer-3,interactive=False,start_blank=False)
           plt.show()
           training=input("Traning? Y/N:") 
           if training=="Y": Network.training_mode=True
       
           if training=="N": Network.training_mode=False
      #mostra processo di learing in modo oaniamto
     if j>10:
      pass
      """plt.clf()
      Network.layer[N_of_layer-1].show(S_obj=S_obj[i].transpose())
      plt.pause(0.7)"""
     """plt.clf()
     Network.synapse[0].plot_val(0)
     plt.pause(0.2)""" #
   
    #Network.synapse[0].plot_val(1)#pesi sinaptici dopo il learning da questo grafico ho capito che posssiamo spostarci molto dai valori iniziali (cosa positiva)
    #plt.show()

    #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    No_guessed=0
    Yes_guessed=0
   
    for j in tqdm(range(testSize)):
         i=randint(0,X.shape[0]-1)
         I_in=X[i].transpose()
         I_in=extendI(I_in,EXTENSION)
         obj=SPIKE_CALCULATOR.Calculate(label=y[i],start=start[i]*EXTENSION,stop=stop[i]*EXTENSION)
         Network.reset()
         Network.run(num_step=EXTENSION*Num_step,I_in=S,obj=obj)
         neur=Network.Calculate_winner_neur(start=start[i]*EXTENSION)
         if neur==y[i]:
            correct_guess+=1
            if y[i]==0:
               No_guessed+=1
            else:
               Yes_guessed+=1 
    #STAMPA ACCURATEZZA FINALE       
    print(f"Accuracy={(correct_guess/testSize)*100}") 
    print(No_guessed)   
    print(Yes_guessed)

Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2,interactive=False,start_blank=False)
Network.synapse[N_of_layer-3].show(layer_number=N_of_layer-3,interactive=False,start_blank=False)
plt.show()
print("______________________________________________________________________________FINE")        