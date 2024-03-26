import numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_digits
from sklearn.model_selection import train_test_split
from scipy.stats import bernoulli
from tqdm import tqdm
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import confusion_matrix
import json
from sklearn.utils import shuffle
import network_object as no
from utils import spike_calculator,plot_I_in,plot_network

JSON_PATH = r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\image_recognition\simplified slayer,lr=1e-3,64x30x10,FA, no noise.json"
SHOW_LEARNING=0
EPOCH=40
lr=1e-3

training="Y"
data= load_digits()
X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.25)
scaler = MinMaxScaler()
scaler.fit(X_train)
X_train=scaler.transform(X_train)
scaler.fit(X_test)
X_test=scaler.transform(X_test)

if 1:
    Num_step=1000
    dim_in=64
    no.LIF_neuron.treshold=0.185
    tau_step=49#cosi lo scelgo io come multiplo di dt
    no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
    no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
    no.LIF_neuron.RestingPotential=0
    no.LIF_neuron.NOISE=False
    no.LIF_neuron.noise_mu=0
    no.LIF_neuron.noise_var=no.LIF_neuron.treshold/10
    T_max=no.LIF_neuron.T_refactory-tau_step*np.log(1+no.LIF_neuron.RestingPotential-no.LIF_neuron.treshold)
    dim_out=10
    dim=[dim_in,30,dim_out]
    N_of_layer=len(dim)
    
    meanW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
    varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
    
    meanW=0
    varW=1

    no.NeuronI.T=T_max/4
    no.NeuronI.theta=0.05
    no.Layer_I.plot_type=0
    no.Synapse_slayer.lr=lr
    no.Synapse_slayer.confine_val=True
    no.Synapse_slayer.max_val=1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
    no.Synapse_slayer.min_val=-1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
    no.NetwrokI.FA=True
    Network=no.NetwrokI(dim=dim,saveU=0,saveS=0,saveAll=0,saveW=SHOW_LEARNING,meanW=meanW,varW=varW) 
    
    Network.training_mode=True
    Network.statitc_dataset=True
    Network.FA=True
    SPIKE_CALCULATOR=no.Objective_spike_bin()
    SPIKE_CALCULATOR.frequency_coding=False
    SPIKE_CALCULATOR.type=5
    SPIKE_CALCULATOR.Num_label=dim_out
    SPIKE_CALCULATOR.Num_step=Num_step
    SPIKE_CALCULATOR.winner_freq=1/(3*T_max)
    SPIKE_CALCULATOR.loser_freq=0

if 1:#salvataggio dati
    data={
        "epoch":[],
        "acuracy":[],
        "confusion matrix":[],
    }

for e in range(EPOCH):  
    print(f'Epoch {e}')
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    X_train,y_train=shuffle(X_train,y_train)
    for i in tqdm(range(X_train.shape[0])):     
        #if y_train[i]!=8: 
        obj=SPIKE_CALCULATOR.Calculate(label=y_train[i],start=0,stop=Num_step)
        Network.reset()
        Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)
        
    #mostra learning 
    if SHOW_LEARNING and i%30==0:
        #i=0
        training=input("new samp? ")
        while(training=="Y"):          
           obj=SPIKE_CALCULATOR.Calculate(label=y_train[i],start=0,stop=Num_step)
           Network.reset()
           Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)
           plt.figure(f"image of the number: {y_train[i]}")
           plt.plot(X_train[i])
           Network.show(S_obj=obj)
           plt.show()
           training=input("new samp? ")
           #i+=1
                 
 #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    total_try=0
    y_true=[]
    y_pred=[]
    for i in tqdm(range(X_test.shape[0])):
        #if y_test[i]!=8:
        total_try+=1
        Network.reset()
        Network.run(num_step=Num_step,I_in=X_test[i],obj=obj)
        winner_neur=Network.Calculate_winner_neur()
        if y_test[i]==winner_neur:
             correct_guess+=1
        y_true.append(y_test[i])
        y_pred.append(winner_neur)
    
    accuracy=(correct_guess/total_try)*100
    conf_matrix=confusion_matrix(y_true=np.array(y_true),y_pred=np.array(y_pred))
    data["epoch"].append(e)
    data["acuracy"].append(accuracy)
    data["confusion matrix"].append(conf_matrix.tolist())
    print(f"Accuracy={accuracy}") 
    print("Confusion matrix:")
    print(conf_matrix)

with open(JSON_PATH, "w") as fp:
    json.dump(data, fp, indent=4)

print("______________________________________________________________________________FINE")        