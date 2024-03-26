import numpy as np
import matplotlib.pyplot as plt

from sklearn.datasets import load_digits
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import confusion_matrix
from scipy.stats import bernoulli
from tqdm import tqdm
import pandas as pd

import network_object as no
from network import Network,Num_step
from control_variable import SHOW_LEARNING,EPOCH,trainSize,testSize,show_interval,loser_freq,winner_freq
from utils import spike_calculator,plot_I_in,plot_network

training="Y"
data= load_digits()
X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.25)
scaler = MinMaxScaler()
scaler.fit(X_train)
X_train=scaler.transform(X_train)
scaler.fit(X_test)
X_test=scaler.transform(X_test)

accuracy=[]
for e in range(EPOCH):    
    print(f'Epoch {e}')
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for i in tqdm(range(X_train.shape[0])):#X_train.shape[0]
          
          obj=loser_freq*np.ones((Network.dim[-1],Num_step))
          obj[y_train[i]]=winner_freq
          Network.reset()
          Network.run(num_step=Num_step,I_in=X_train[i],obj=obj)

          if SHOW_LEARNING:
             j=0
             training=input("new samp? ")
             while(training=="Y"):
                obj=loser_freq*np.ones((Network.dim[-1],Num_step))
                obj[y_train[j]]=winner_freq
                Network.reset()
                Network.run(num_step=Num_step,I_in=X_train[j],obj=obj)
                plt.figure(f"image of the number: {y_train[j]}")
                plt.imshow(X_train[j].reshape((8,8)))
                plot_network(Network=Network,obj="a")
                plt.show()
                training=input("new samp? ")
                j+=1
        
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
            plot_network(Network=Network,obj="a")
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
    for i in tqdm(range(X_test.shape[0])):#X_test.shape[0]
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
Excel_file=pd.ExcelWriter('D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\image_recognition\MNIST compressed accuracy.xlsx',engine='xlsxwriter')
df=pd.DataFrame(np.array(accuracy))
df.to_excel(Excel_file,sheet_name="accuracy")
Excel_file.save()
print("______________________________________________________________________________FINE")        