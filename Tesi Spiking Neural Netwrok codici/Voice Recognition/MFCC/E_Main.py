print("______________________________________________________________________________INIZIO")
import numpy as np
from A_DecolleClass import Neuron_decolle, Synapse_decolle,Layer_decolle
from A_DatasetPreparationFunctions import Objective_spike_bin
from B_prepare_datset import Num_step
from C_Signal_creation import X,S_obj,y,start,stop,file_path
from D_Network_creation import Network,N_of_layer,dim_out,EXTENSION,dt
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm
from Various_function import Calculate_winner_neur,extendI,plot_I_in



EPOCH=10
SHOW_LEARNING=1
trainSize=int(X.shape[0])
testSize=int(X.shape[0])
training="Y" #per poter passare dalla molaità training a qella di prova

SPIKE_CALCULATOR=Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=2
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
spike_interval_s=np.array([0.03,0.1])
#SPIKE_CALCULATOR.spike_interval=spike_interval_s/dt
SPIKE_CALCULATOR.spike_interval=np.array([30,200])
SPIKE_CALCULATOR.type=4

Layer_decolle.plot_type=1

#Network.synapse[0].plot_val(0) #stampa pesi sinaptici iniziali

for e in range(EPOCH):
    print(f'Epoch {e}')
    
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for j in tqdm(range(trainSize)):
     #print(f'sample {j}')
     
     i=randint(0,X.shape[0]-1)
     I_in=X[i].transpose()

     t=np.arange(start=0,stop=Num_step,step=1)/Num_step
     plt.imshow(t,X[i].transpose())
     plt.xlabel("Time[s]")
     plt.ylabel("MFCC coefficient")
     
     I_in,S=extendI(I_in,EXTENSION)
     Obj_spike=SPIKE_CALCULATOR.Calculate(label=y[i],start=EXTENSION*start[i],stop=EXTENSION*stop[i])

     Network.reset()
     Network.run(num_step=EXTENSION*Num_step,I_in=S,obj=Obj_spike)

     #cambia la beta della surrgrad function dopo un po di sample
     if j==50:
        Neuron_decolle.beta=7
        Synapse_decolle.lr=1e-4
     if j==200:
        Synapse_decolle.lr=1e-6

     #mostra learning in modo statico
     if SHOW_LEARNING:
         if j%1000==0 or training=="N":
           plot_I_in(I_in)
           Network.show(0,S_obj=Obj_spike)
           Network.Algorithm_var_plot(0)
           if training=="Y":
            Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2,interactive=False,start_blank=False)
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
         Obj_spike=SPIKE_CALCULATOR.Calculate(label=y[i],start=EXTENSION*start[i],stop=EXTENSION*stop[i])

         Network.reset()
         Network.run(num_step=EXTENSION*Num_step,I_in=I_in,obj=S_obj[i].transpose())
         neur=Calculate_winner_neur()
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

print("______________________________________________________________________________FINE")        