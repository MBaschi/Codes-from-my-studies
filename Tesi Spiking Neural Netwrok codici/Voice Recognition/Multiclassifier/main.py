print("______________________________________________________________________________INIZIO")
import numpy as np
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm

from control_variable import SHOW_SIGNAL_IMPORT,SHOW_LEARNING,Show_learn_interval,lr
from no import Neuron_slayer,Neuron_decolle,Objective_spike_bin
from network_creation import Network,EXTENSION,Num_step,N_of_layer,dim_in
from function import Calculate_winner_neur,extendI,plot_I_in,plot_network,New_sample_spect,New_sample_filter_bank
from control_variable import SPECTROGRAM, Label
import json
from sklearn.metrics import confusion_matrix
JSON_PATH=r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\Voice recognition\Multiclassifier\Test3.json"
data={
      "accuracy":[],
      "confusion matrix":[]
     }        

EPOCH=40

trainSize=int(400)
testSize=int(100)
#int(X.shape[0])
training="y" #per poter passare dalla molaità training a quella di prova

SPIKE_CALCULATOR=Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=3
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR.frequency_coding=False#True#
SPIKE_CALCULATOR.type=0#2
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa
SPIKE_CALCULATOR.trh=Network.layer[0].neur[0].treshold

SPIKE_CALCULATOR.spike_interval=[100,300]
SPIKE_CALCULATOR.winner_freq=1.5
SPIKE_CALCULATOR.loser_freq=0.2
SPIKE_CALCULATOR.baseline_freq=0

Network.change_beta(0)
counter=0
for e in range(EPOCH):
    
    print(f'Epoch {e}')
    
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for i in tqdm(range(trainSize)):
      label=Label[counter]
      winner_neur=counter
      Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  
      I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
      obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
      Network.reset()
      Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=1.3*obj,winner_neur=winner_neur)
      counter+=1
      if counter>=len(Label):
       counter=0
   
    if SHOW_LEARNING:
          if e%Show_learn_interval==0:
            training="y"
            while training=="y":
              label=Label[counter]
              winner_neur=counter
              Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  
              I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
              obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
              Network.reset()
              Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=1.3*obj,winner_neur=winner_neur)
              counter+=1
              if counter>=len(Label):
               counter=0
              plot_I_in(I_in,start_blank=True)
              plt.figure("objective activity")
              plt.plot(obj.T)
              plot_network(Network=Network,obj=obj)
              plt.show()
              training=input("\n Watch next? y/n:") 
            
    #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    total_try=0
    counter=0
    y_true=[]
    y_pred=[]
    for i in tqdm(range(testSize)): 
       label=Label[counter]
       correct_neur=counter
       
       Network.reset()
       Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  

       I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*Neuron_slayer.treshold/Neuron_slayer.alfa)
       obj=SPIKE_CALCULATOR.Calculate(label=correct_neur,start=start*EXTENSION,stop=stop*EXTENSION)
       Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj,winner_neur=correct_neur)
       neur=Network.Calculate_winner_neur(start=start*EXTENSION)
       
       counter+=1
       if counter==len(Label):
         counter=0
       
       total_try+=1
       if correct_neur==neur:
             correct_guess+=1
       y_true.append(counter)
       y_pred.append(neur)

    accuracy=(correct_guess/testSize)*100
    conf_matrix=confusion_matrix(y_true=np.array(y_true),y_pred=np.array(y_pred))
    data["accuracy"].append(accuracy)
    data["confusion matrix"].append(conf_matrix.tolist())
    print(f"Accuracy={accuracy}") 
    print(conf_matrix)

with open(JSON_PATH, "w") as fp:
         json.dump(data, fp, indent=4)

print("______________________________________________________________________________FINE")        