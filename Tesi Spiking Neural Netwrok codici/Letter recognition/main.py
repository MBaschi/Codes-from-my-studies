import numpy as np
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm
import random
random.seed(389)
import network_object as no
from functions import New_sample_spect,LABELS,extendI,plot_I_in,plot_network
import json

SHOW_LEARNING=1
Show_learn_interval=9000
SHOW_SIGNAL_IMPORT=0
lr=1e-3
EPOCH=30
trainSize=10000
testSize=100

JSON_PATH=r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\Voice recognition\Multiclassifier\yes,no,follow"
data={
      "accuracy":[],
      "confusion matrix":[]
     }   


if 1: #NETWROK
    
  S_test,start,stop=New_sample_spect(LABEL=LABELS[0],show_signal_import=False)
  Num_step=S_test.shape[1]
  dim_in=S_test.shape[0]
  EXTENSION=10
  no.LIF_neuron.treshold=0.009 

  SAMPLING_FREQUENCY = 22050 # 1 sec. of audio
  tau=0.4 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
  tau_step=tau*Num_step*EXTENSION
  #tau=5*dt #cosi lo scelgo io come multiplo di dt
  no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
  no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
  no.LIF_neuron.RestingPotential=0
  
  dim_out=26
  dim=[dim_in,30,30,dim_out]
  N_of_layer=len(dim)
  
  meanW=0
  varW=no.LIF_neuron.treshold/no.LIF_neuron.alfa

  no.Layer_slayer.plot_type=1
  no.Synapse_slayer.confine_val=True
  no.Synapse_slayer.max_val=1.5*no.LIF_neuron.treshold/no.LIF_neuron.alfa
  no.Synapse_slayer.min_val=-1.5*no.LIF_neuron.treshold/no.LIF_neuron.alfa
  no.Synapse_slayer.lr=lr
  Network=no.Network_slayer(dim=dim,saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveW=0,meanW=meanW,varW=varW)

  Network.training_mode=True
  Network.Freq_coding=True
  Network.change_beta(0)

if 1: #OBJECTIVE SPIKE
  SPIKE_CALCULATOR=no.Objective_spike_letters()
  SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
  SPIKE_CALCULATOR.winner_freq=0.7

for e in range(EPOCH):
    
    print(f'Epoch {e}')
    
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    counter=0
    for i in tqdm(range(trainSize)):
      label=random.choice(LABELS)
      Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  
      I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*no.Neuron_slayer.treshold/no.Neuron_slayer.alfa)
      obj=SPIKE_CALCULATOR.Calculate(start=start*EXTENSION,stop=stop*EXTENSION,label=label)
      Network.reset()
      Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
      
      #mostra learning 
      grad_w=np.matmul(Network.sigma[-1],Network.P_record[-1].transpose())
      
      if SHOW_LEARNING:
          if i%Show_learn_interval==0 or training=="y" :
            plot_I_in(I_in,start_blank=True)
            plt.figure(label)
            plt.imshow(obj, aspect="auto")
            plot_network(Network=Network,obj=obj)
            plt.show()
            training=input("\n Watch next? y/n:") 
    
    #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    No_guessed=0
    Yes_guessed=0
    for i in tqdm(range(testSize)):
      label=LABELS[counter]
      Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  
      I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*no.Neuron_slayer.treshold/no.Neuron_slayer.alfa)
      obj=SPIKE_CALCULATOR.Calculate(start=start*EXTENSION,stop=stop*EXTENSION,label=label)
      Network.reset()
      Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)

      counter+=1
      if counter==len(LABELS):
          counter=0
    data["accuracy"].append((correct_guess/testSize)*100)
    print(f"Accuracy={(correct_guess/testSize)*100}") 
