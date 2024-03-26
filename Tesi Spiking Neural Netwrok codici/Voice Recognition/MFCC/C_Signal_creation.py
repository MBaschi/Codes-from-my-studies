
import json
import numpy as np
import matplotlib.pyplot as plt
from B_prepare_datset import Num_mfcc
import librosa
DATA_PATH = r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\Voice recognition\MFCC\dataIII.json"

PRINT_EXAMPLE=1
Example_data=17
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
    start=np.array(data["start"])
    stop=np.array(data["stop"])
    S_obj=np.array(data["S_obj"])
    # i tempi di start e stop sono salvati in sample e devo traformarli in step

    print("Training sets loaded!")
    return X, y,start,stop,S_obj,Names

def scale_transform(X,S_obj,printExample=False):#i segnali devono essere normalizzati
   
    v=np.ones((X.shape[0],X.shape[1]))
    if printExample:
       a=3
       EX=X
       plt.figure(1)
       plt.plot(EX[0,:,a])
       plt.plot(EX[3,:,a])
       plt.plot(EX[95,:,a])
       print(f'min={np.min(EX[:,:,a])}')
       X_sifted=EX[:,:,a]+v*np.abs(np.min(EX[:,:,a]))
       EX[:,:,a]=X_sifted/np.max(X_sifted)
       print(f'max={np.max(X_sifted)}')
       plt.figure(2)
       plt.plot(EX[0,:,a])
       plt.plot(EX[3,:,a])
       plt.plot(EX[95,:,a])
       
       plt.figure(3)
       plt.plot(X[10])
       plt.vlines(x=np.where(S_obj[Example_data,:,0]==1),ymin=-600, ymax=0,colors='black', ls=':', lw=2, label="Objective Spike neuron 0")
       plt.vlines(x=np.where(S_obj[Example_data,:,1]==1),ymin=0, ymax=300,colors='red', ls=':', lw=2, label="Objective Spike neuron 1")
       
    for i in range(Num_mfcc):
        X_sifted=X[:,:,i]+v*np.abs(np.min(X[:,:,i])) #shifto tutti i segnali in positivo
        X[:,:,i]=X_sifted/np.max(X_sifted) #normalizzo

    if printExample:
        plt.figure(4)
        plt.plot(X[10])
        plt.vlines(x=np.where(S_obj[Example_data,:,0]==1),ymin=0, ymax=1,colors='black', ls=':', lw=2, label="Objective Spike neuron 0")
        plt.vlines(x=np.where(S_obj[Example_data,:,1]==1),ymin=-1, ymax=0,colors='red', ls=':', lw=2, label="Objective Spike neuron 1")
        plt.figure(5)
        plt.show()
    
    return X

X, y,start,stop,S_obj,file_path= load_data(DATA_PATH)

if PRINT_EXAMPLE:
  signal,s = librosa.load(file_path[Example_data])
  plt.figure(5)
  plt.plot(signal)
  plt.xlabel('time[s]')

X=scale_transform(X,printExample=PRINT_EXAMPLE,S_obj=S_obj)

#print(X.shape)#=(6796, 87, 13)
#print(y.shape)#=(6796,)   
