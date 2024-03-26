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

from utils import spike_calculator,plot_I_in,plot_network,create_frame,make_gif_weigth
import imageio

#CONTROL VARIABLE
SHOW_LEARNING=False
EPOCH=5
trainSize=int(500)
testSize=int(3000)
show_interval=100
loser_freq=0
winner_freq=0.7
lr=1e-4 #learning rate
#NETWORK
Num_step=1000
dim_in=13
no.LIF_neuron.treshold=0.185
tau=0.01 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
tau_step=tau*Num_step
tau_step=50#cosi lo scelgo io come multiplo di dt
no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
no.LIF_neuron.RestingPotential=0

dim_out=10
dim=[dim_in,30,dim_out]
N_of_layer=len(dim)

meanW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))

meanW=0
varW=1

no.Layer_slayer.plot_type=0
no.Synapse_slayer.lr=lr
Network=no.Network_slayer_FA(dim=dim,saveU=0,saveS=1,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)

Network.training_mode=True
Network.Freq_coding=True
Network.statit_dataset=True
Network.change_beta(0)

#SAVE INITIAL VALUE
W0_init=copy.deepcopy(Network.synapse[0].W)
W1_init=copy.deepcopy(Network.synapse[1].W)

fig,_=Network.synapse[0].plot_val(layer_number=0)
fig.savefig(f'D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\wine quality.py\FA images\initial value layer 0.png')
fig,_=Network.synapse[1].plot_val(layer_number=1)
fig.savefig(f'D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\wine quality.py\FA images\initial value layer 1.png')
plt.clf()
plt.suptitle(f"B")
im=plt.imshow(Network.B[1].T)
fig.colorbar(im)
fig.savefig(f'D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\wine quality.py\FA images\B.png')
W0_dist=[]
W1_dist=[]
W1_B_dist=[]
#MAIN
training="Y"
data= load_wine()
X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33, random_state=42)
scaler = MinMaxScaler()
scaler.fit(X_train)
X_train=scaler.transform(X_train)
scaler.fit(X_test)
X_test=scaler.transform(X_test)

#GIF PESI SINAPTICI
frames=[]
for j in  range(Network.num_layer-1):
      frames.append([])

for e in range(EPOCH):    
    print(f'Epoch {e}')
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for i in tqdm(range(X_train.shape[0])):     
          obj=loser_freq*np.ones((Network.dim[-1],Num_step))
          obj[y_train[i]]=winner_freq
          Network.reset()
          Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)

          W0_dist.append(np.linalg.norm(Network.synapse[0].W-W0_init))
          W1_dist.append(np.linalg.norm(Network.synapse[1].W-W1_init))
          W1_B_dist.append(np.linalg.norm(Network.synapse[1].W-Network.B[1].T))
          for j in  range(Network.num_layer-1):
           fig,im=Network.synapse[j].plot_val(layer_number=j)
           frames[j].append(im)
    #mostra learning 
    if SHOW_LEARNING and e%3==0:
         i=0
         training=input("new samp? ")
         while(training=="Y"):          
            obj=loser_freq*np.ones((Network.dim[-1],Num_step))
            obj[y_train[i]]=winner_freq
            Network.reset()
            Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)
            plt.figure(f"image of the number: {y_train[i]}")
            plt.plot(X_train[i])
            plot_network(Network=Network,obj="a")
            Network.synapse[0].plot_val(layer_number=0)
            Network.synapse[1].plot_val(layer_number=1)
            plt.show()
            training=input("new samp? ")
            i+=1

    #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    total_try=0
    for i in tqdm(range(X_test.shape[0])):
          total_try+=1
          Network.reset()
          Network.run(num_step=Num_step,I_in=X_test[i],obj=obj)
          if y_test[i]==Network.Calculate_winner_neur():
               correct_guess+=1

    print(f"Accuracy={(correct_guess/total_try)*100}") 

for i in  range(Network.num_layer-1):
      imageio.mimsave(f'D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\wine quality.py\FA images\layer{i}.gif', # output gif
                frames[i],          # array of input frames
                fps = 5)

plt.figure("weigth norm")
plt.plot(W0_dist)
plt.plot(W1_dist)
plt.plot(W1_B_dist)
plt.show()

print("______________________________________________________________________________FINE")        