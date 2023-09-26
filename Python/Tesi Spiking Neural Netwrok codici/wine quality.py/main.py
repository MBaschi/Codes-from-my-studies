import numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from scipy.stats import bernoulli
from tqdm import tqdm
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import confusion_matrix

import network_object as no
from network import Network,Num_step
from control_variable import SHOW_LEARNING,EPOCH,trainSize,testSize,show_interval,loser_freq,winner_freq
from utils import spike_calculator,plot_I_in,plot_network

training="Y"
data= load_wine()
X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33)
scaler = MinMaxScaler()
scaler.fit(X_train)
X_train=scaler.transform(X_train)
scaler.fit(X_test)
X_test=scaler.transform(X_test)


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
        
    #mostra learning 
    if SHOW_LEARNING and e%3==0:
            i=0
            training=input("new samp? ")
            while(training=="Y"):     
               print(X_train[i])  
               x=[1,2,3,4,5,6,7,8,9,10,11,12,13]   
               obj=loser_freq*np.ones((Network.dim[-1],Num_step))
               obj[y_train[i]]=winner_freq
               Network.reset()
               Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)
               plt.figure(f"Wine from cultivator number: {y_train[i]}")
               plt.plot(x,X_train[i])
               plt.xlabel("Feature")
               #plt.xticks(x)
               plt.ylabel("Value")
               plot_network(Network=Network,obj="a")
               plt.show()
               training=input("new samp? ")
               i+=1
        
    
 #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    total_try=0
    y_true=[]
    y_pred=[]
    for i in tqdm(range(X_test.shape[0])):
          total_try+=1
          Network.reset()
          Network.run(num_step=Num_step,I_in=X_test[i],obj=obj)
          winner_neur=Network.Calculate_winner_neur()
          if y_test[i]==winner_neur:
               correct_guess+=1
          y_true.append(y_test[i])
          y_pred.append(winner_neur)
     
    print(f"Accuracy={(correct_guess/total_try)*100}") 
    print("Confuzion matrix:")
    print(confusion_matrix(y_true=np.array(y_true),y_pred=np.array(y_pred)))
print("______________________________________________________________________________FINE")        