import numpy as np
import matplotlib.pyplot as plt


from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import confusion_matrix
from tqdm import tqdm
import pandas as pd
import json
import network_object as no
from Prepare_dataset import LABEL,JSON_PATH,Num_mfcc

SHOW_LEARNING=0
EPOCH=100
loser_freq=0
winner_freq=0.7
lr=1e-4

training="Y"

def load_data(data_path):
    """Loads training dataset from json file.
    :param data_path (str): Path to json file containing data
    :return X (ndarray): Inputs
    :return y (ndarray): Targets
    """
    with open(data_path, "r") as fp:
        data = json.load(fp)

    X = np.array(data["MFCCs"])
    y = np.array(data["labels"])
    Names=data["files"]

    # i tempi di start e stop sono salvati in sample e devo traformarli in step

    print("Training sets loaded!")
    return X, y,Names

X, y,Names=load_data(JSON_PATH)

X=X.reshape(X.shape[0],X.shape[1]*X.shape[2])

X_train, X_test, y_train, y_test = train_test_split( X, y, test_size=0.25)
scaler = MinMaxScaler()
scaler.fit(X_train)
X_train=scaler.transform(X_train)
scaler.fit(X_test)
X_test=scaler.transform(X_test)

train_size=int(X_train.shape[0])
test_size=int(X_test.shape[0])
#   NETWORK AND SIMULATION PARAMNETER
if 1:
    Num_step=100
    dim_in=X_train.shape[1]
    no.LIF_neuron.treshold=0.185
    tau=0.01 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
    tau_step=tau*Num_step
    tau_step=20 #cosi lo scelgo io come multiplo di dt
    no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
    no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
    no.LIF_neuron.RestingPotential=0
    
    dim_out=len(LABEL)
    dim=[dim_in,30,dim_out]
    N_of_layer=len(dim)
    
    meanW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
    varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
    
    meanW=0
    varW=1
    
    no.Layer_slayer.plot_type=0
    no.Synapse_slayer.lr=lr
    no.Synapse_slayer.confine_val=True
    no.Synapse_slayer.max_val=1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
    no.Synapse_slayer.min_val=-1.1*no.LIF_neuron.treshold/no.LIF_neuron.alfa
    #Network=no.Network_slayer(dim=dim,saveU=0,saveS=1,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)
    Network=no.Network_slayer_FA(dim=dim,saveU=0,saveS=0,saveW=0,meanW=meanW,varW=varW)
    Network.training_mode=True
    Network.Freq_coding=True
    Network.static_dataset=True
    Network.change_beta(0)

accuracy=[]
for e in range(EPOCH):    
    print(f'Epoch {e}')
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for i in tqdm(range(train_size)):#X_train.shape[0]
          obj=loser_freq*np.ones((Network.dim[-1],Num_step))
          obj[y_train[i]]=winner_freq
          Network.reset()
          Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)

    #mostra learning 
    if SHOW_LEARNING and e%3==0:
         j=0
         training=input("new samp? ")
         while(training=="Y"):
            obj=loser_freq*np.ones((Network.dim[-1],Num_step))
            obj[y_train[j]]=winner_freq
            Network.reset()
            Network.run(num_step=Num_step,I_in=X_train[j],obj=obj)
            plt.figure(f"image of the number: {y_train[j]}")
            plt.imshow(X_train[j].reshape((8,8)))
            no.plot_network(Network=Network,obj="a")
            plt.show()
            training=input("new samp? ")
            j+=1
        
    
 #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    total_try=0
    y_true=[]
    y_pred=[]
    for i in tqdm(range(test_size)):#X_test.shape[0]
          total_try+=1
          Network.reset()
          Network.run(num_step=Num_step,I_in=X_test[i],obj=obj)
          winner_neur=Network.Calculate_winner_neur()
          if y_test[i]==winner_neur:
               correct_guess+=1
          y_true.append(y_test[i])
          y_pred.append(winner_neur)

    print(f"Accuracy={(correct_guess/total_try)*100}") 
    accuracy.append((correct_guess/total_try)*100)

    print(confusion_matrix(y_true=np.array(y_true),y_pred=np.array(y_pred)))
#ESPORTAZIONE EXCELL
Excel_file=pd.ExcelWriter('D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\Voice recognition\as_static.py\ accuracy.xlsx',engine='xlsxwriter')
df=pd.DataFrame(np.array(accuracy))
df.to_excel(Excel_file,sheet_name="accuracy")
Excel_file.save()
print("______________________________________________________________________________FINE")        