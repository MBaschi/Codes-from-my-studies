import numpy as np
import matplotlib.pyplot as plt
import copy 
from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from scipy.stats import bernoulli
from tqdm import tqdm
from sklearn.preprocessing import MinMaxScaler

import network_object as no
from network import Network,Num_step
import json
from utils import spike_calculator,plot_I_in,plot_network,create_frame,make_gif_weigth
import imageio

#CONTROL VARIABLE
SHOW_LEARNING=False
EPOCH=20

show_interval=100
loser_freq=0
winner_freq=0.7
lr=7e-4 #learning rate
JSON_PATH=r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\wine quality.py\FA same initial weight.json"

if 1:#NETWORK
      Num_step=1000
      dim_in=13
      no.LIF_neuron.treshold=0.185
      tau=0.01 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
      tau_step=tau*Num_step
      tau_step=20#cosi lo scelgo io come multiplo di dt
      no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
      no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
      no.LIF_neuron.RestingPotential=0
      
      dim_out=10
      dim=[dim_in,5,dim_out]
      N_of_layer=len(dim)
      
      meanW=0
      varW=1
      
      no.Layer_slayer.plot_type=0
      no.Synapse_slayer.lr=lr
      
      #MAIN
      training="Y"
      data= load_wine()
      X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33, random_state=42)
      scaler = MinMaxScaler()
      scaler.fit(X_train)
      X_train=scaler.transform(X_train)
      scaler.fit(X_test)
      X_test=scaler.transform(X_test)

data={
      "accuracy":[]
     }      

def run():   
      Network=no.Network_slayer_FA(dim=dim,saveU=0,saveS=1,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)
      Network.training_mode=True
      Network.Freq_coding=True
      Network.statit_dataset=True
      Network.change_beta(0)

      accuracy=[]
      for e in tqdm(range(EPOCH)):    

          Network.training_mode=True
          for i in range(X_train.shape[0]):     
                obj=loser_freq*np.ones((Network.dim[-1],Num_step))
                obj[y_train[i]]=winner_freq
                Network.reset()
                Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)

          Network.training_mode=False
          correct_guess=0 
          total_try=0
          for i in range(X_test.shape[0]):
                total_try+=1
                Network.reset()
                Network.run(num_step=Num_step,I_in=X_test[i],obj=obj)
                if y_test[i]==Network.Calculate_winner_neur():
                     correct_guess+=1
      
          accuracy.append((correct_guess/total_try)*100) 
      
      print(f" accuracy:{accuracy}")
      return accuracy

for i in range(5):
    print(f"Test{i}")
    data["accuracy"].append(run())

with open(JSON_PATH, "w") as fp:
         json.dump(data, fp, indent=4)

print("______________________________________________________________________________FINE")        