#Leraning wine with variable number of hidden neuron , plot of accuracy in the various epoch saved in  Var_hif_neur_iamge
import numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from scipy.stats import bernoulli
from tqdm import tqdm
from sklearn.preprocessing import MinMaxScaler

import network_object as no

#control variable
SHOW_LEARNING=True
EPOCH=30
trainSize=int(500)
testSize=int(3000)
show_interval=100
loser_freq=0
winner_freq=0.7
lr=1e-4 #learning rate

#COSTANT NETWORK VARIABLE
Num_step=1000
dim_in=13
dim_out=10
no.LIF_neuron.treshold=0.185
tau=0.01 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
tau_step=tau*Num_step
tau_step=20#cosi lo scelgo io come multiplo di dt
no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
no.LIF_neuron.RestingPotential=0

meanW=0
varW=1

no.Layer_slayer.plot_type=0
no.Synapse_slayer.lr=lr

#LOAD DATASET
training="Y"
data= load_wine()
X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33, random_state=42)
scaler = MinMaxScaler()
scaler.fit(X_train)
X_train=scaler.transform(X_train)
scaler.fit(X_test)
X_test=scaler.transform(X_test)


def create_mew_network(dim_hid):
    dim=[dim_in,5,5,dim_out]
    Network=no.Network_slayer(dim=dim,saveU=0,saveS=1,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)
    Network.training_mode=True
    Network.Freq_coding=True
    Network.static_dataset=True
    Network.change_beta(0)
    return Network

def learn(Network):
    accuracy_record=[]
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
        accuracy_record.append((correct_guess/total_try)*100)
    
    return accuracy_record

def save_plot(accuracy,num_hid):
     fig = plt.figure(f"hid={num_hid} ")
     plt.plot(accuracy)
     fig.savefig(fr"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\wine quality.py\Var_hid_neur_image\hid=5,5.{num_hid} max_accuracy={np.max(accuracy)},devanisher.png")

hidden_neuron=0
for j in range(10):
     Network=create_mew_network(hidden_neuron)
     save_plot(learn(Network=Network),hidden_neuron)
     hidden_neuron+=5
     