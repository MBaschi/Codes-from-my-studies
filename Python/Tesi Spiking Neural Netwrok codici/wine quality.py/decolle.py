import numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from scipy.stats import bernoulli
from tqdm import tqdm
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import confusion_matrix
import json
import network_object as no
from network import Network,Num_step
from control_variable import loser_freq,winner_freq
from utils import spike_calculator,plot_I_in,plot_network


SHOW_LEARNING=0
lr=1e-2
Num_step=3000
dim_in=13

training="Y"
data= load_wine()

scaler = MinMaxScaler()
X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33)
scaler.fit(X_train)
X_train=scaler.transform(X_train)
scaler.fit(X_test)
X_test=scaler.transform(X_test)

EPOCH=50
loser_freq=0
winner_freq=0.6
SPIKE_CALCULATOR=no.Objective_spike_bin()
SPIKE_CALCULATOR.frequency_coding=False
SPIKE_CALCULATOR.type=5
SPIKE_CALCULATOR.Num_label=3
SPIKE_CALCULATOR.Num_step=Num_step
SPIKE_CALCULATOR.spike_interval=np.array([Num_step,Num_step/30])
SPIKE_CALCULATOR.winner_freq=0.05
SPIKE_CALCULATOR.loser_freq=0



JSON_PATH="D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\DecolleII.json"
save={
      "accuracy":[],
      "confusion matrix":[]
     }      

def run(var):
   X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33)
   scaler.fit(X_train)
   X_train=scaler.transform(X_train)
   scaler.fit(X_test)
   X_test=scaler.transform(X_test)

  
   no.LIF_neuron.treshold=0.185
   tau_step=50#cosi lo scelgo io come multiplo di dt
   no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
   no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
   no.LIF_neuron.RestingPotential=0
   no.LIF_neuron.NOISE=True
   no.LIF_neuron.noise_var=no.LIF_neuron.treshold/10
   no.LIF_neuron.noise_mu=0
   
   dim_out=3
   dim=[dim_in,20,dim_out]
   N_of_layer=len(dim)
   
   meanW=0
   varW=no.LIF_neuron.treshold/no.LIF_neuron.alfa
   no.Layer_decolle.plot_type=0
   no.Synapse_decolle.lr=lr
   no.Synapse_decolle.confine_val=True
   no.Synapse_decolle.max_val=1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
   no.Synapse_decolle.min_val=-1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
   Network=no.Network_decolle(dim=dim,saveU=0,saveS=0,saveW=SHOW_LEARNING,meanW=meanW,varW=varW,saveAll=0,meanW_int=[meanW,meanW],varW_int=[var,var])
   
   Network.training_mode=True
   Network.Freq_coding=False
   Network.statitc_dataset=True
   Network.change_beta(0)
   accuracy_record=[]
   for e in (range(EPOCH)):   
       X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33)
       scaler.fit(X_train)
       X_train=scaler.transform(X_train)
       scaler.fit(X_test)
       X_test=scaler.transform(X_test) 
        
    #FASE DI TRAINING      
       Network.training_mode=True
       for i in tqdm(range(X_train.shape[0])):  
             obj=loser_freq*np.ones((Network.dim[-1],Num_step))
             obj[y_train[i]]=winner_freq 
             obj=SPIKE_CALCULATOR.Calculate(label=y_train[i],start=0,stop=Num_step)         
             Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)
             Network.reset()

             #mostra learning 
       if SHOW_LEARNING and e%40==0:
                i=0
                training=input("new samp? ")
                while(training=="Y"):          
                   #obj=loser_freq*np.ones((Network.dim[-1],Num_step))
                   #obj[y_train[i]]=winner_freq         
                   Network.run(num_step=Num_step,I_in=X_train[i],obj=SPIKE_CALCULATOR.Calculate(y_train[i],start=0,stop=Num_step))
                   plt.figure(f"Wine vote: {y_train[i]}")
                   plt.plot(X_train[i])
                   Network.show(S_obj=SPIKE_CALCULATOR.Calculate(y_train[i],start=0,stop=Num_step))
                   plt.show()
                   training=input("new samp? ")
                   Network.reset()
                   i+=1
       
    #FASE DI TEST      
       Network.training_mode=False
       correct_guess=0 
       total_try=0
       y_true=[]
       y_pred=[]
       for i in tqdm(range(X_test.shape[0])):
             obj=loser_freq*np.ones((Network.dim[-1],Num_step))
             obj[y_train[i]]=winner_freq
             total_try+=1
             Network.reset()
             obj=SPIKE_CALCULATOR.Calculate(label=y_train[i],start=0,stop=Num_step)         
             Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)
             winner_neur=Network.Calculate_winner_neur()
             if y_test[i]==winner_neur:
                  correct_guess+=1
             y_true.append(y_test[i])
             y_pred.append(winner_neur)
        
       accuracy=(correct_guess/total_try)*100
       conf_matrix=confusion_matrix(y_true=np.array(y_true),y_pred=np.array(y_pred)) 
       print(accuracy)
       accuracy_record.append(accuracy)
       print("Confuzion matrix:")
       print(conf_matrix)
       save["accuracy"].append((correct_guess/total_try)*100)
       save["confusion matrix"].append(conf_matrix.tolist())
   
   return accuracy_record

var_init=1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
var=var_init
print(f"accuracy trough epoch {run(var=var)}")
with open(JSON_PATH, "w") as fp:
         json.dump(save, fp, indent=4)

var_init=1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
num_test=10
for i in (range(num_test)):
     var=var_init-(i/num_test)*(no.LIF_neuron.treshold/no.LIF_neuron.alfa)
     print(f"test {i}  with var {var} ")
     print(f"accuracy trough epoch {run(var=var)}")