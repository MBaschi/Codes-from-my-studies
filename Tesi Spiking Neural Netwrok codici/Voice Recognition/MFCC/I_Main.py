print("______________________________________________________________________________INIZIO")
import numpy as np
from A_DecolleClass import Neuron_decolle, Synapse_decolle
from F_functions import New_sample
from Variables import Num_file, Num_step
from H_Network_creation import Network,N_of_layer,dim_out
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm

EPOCH=10

SHOW_LEARNING=1
SHOW_ANIMATION=0  
trainSize=int(0.01*Num_file)
testSize=int(0.01*Num_file)

def Calculate_winner_neur():
   S_count=0
   neuron_index=0
   for i in range(dim_out):
        if np.count_nonzero(Network.layer[N_of_layer-1].neur[i].S_record)>S_count:
           S_count=np.count_nonzero(Network.layer[N_of_layer-1].neur[i].S_record)
           neuron_index=i
   return neuron_index

def Show_learning():
   Network.show(0,S_obj=S_obj)
   Network.Algorithm_var_plot(0)
   
   Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2)
   Network.synapse[N_of_layer-3].show(layer_number=N_of_layer-3)
   plt.show()
        
#Network.synapse[0].plot_val(0) #stampa pesi sinaptici iniziali

for e in range(EPOCH):
    print(f'Epoch {e}')

    #FASE DI TRAINING
    if 1:
     print("Training progress:")
     Network.training_mode=True
   
     for i in tqdm(range(trainSize)):
      if i%2==0: label="yes"
      else:label="no"
    
      I_in,S_obj=New_sample(LABEL=label)
      Network.reset()
      Network.run(num_step=Num_step,I_in=I_in,obj=S_obj)
 
      #cambia la beta della surrgrad function dopo un po di sample
      if i==10:
         Neuron_decolle.beta=340
 
      #plot vari
      if SHOW_LEARNING and i%10==0 :
          Show_learning()
      if SHOW_ANIMATION:
        plt.clf()
        Network.layer[N_of_layer-1].show(S_obj=S_obj)
        plt.pause(0.7)
        """plt.clf()
        Network.synapse[0].plot_val(0)
        plt.pause(0.2)"""
   
    #Network.synapse[0].plot_val(1)#pesi sinaptici dopo il learning 
    #plt.show()

    #FASE DI TEST
    if 1:
       print("Test progress:")
       Network.training_mode=False
       No_guessed=0
       Yes_guessed=0
      
       for i in tqdm(range(testSize)):
            if i%2==0: label="yes"
            else:label="no"
            I_in,S_obj=New_sample(LABEL=label)
            Network.reset()
            Network.run(num_step=Num_step,I_in=I_in,S_obj=S_obj)
            neur=Calculate_winner_neur()    
            if  neur==0 and label=='yes':
               No_guessed+=1
            if  neur==1 and label=='no':
               Yes_guessed+=1 
         
    #STAMPA ACCURATEZZA FINALE  
    correct_guess=No_guessed+Yes_guessed   
    print(f"Accuracy={(correct_guess/testSize)*100}") 
    print(No_guessed)   
    print(Yes_guessed)

print("______________________________________________________________________________FINE")     

        