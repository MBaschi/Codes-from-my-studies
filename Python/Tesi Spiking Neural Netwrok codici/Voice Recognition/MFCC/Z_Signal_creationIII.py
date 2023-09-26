
import json
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler, normalize
from B_prepare_datset import hop_length
DATA_PATH = "data.json"

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
    start=np.array(data["start"])
    stop=np.array(data["stop"])
    # i tempi di start e stop sono salvati in sample e devo traformarli in step
    start=np.floor(start/hop_length).astype(int)
    stop=np.floor(stop/hop_length).astype(int)
    print("Training sets loaded!")
    return X, y,start,stop

def scale_transform(X,printExample=False):#i segnali devono essere normalizzati
   
    v=np.ones((X.shape[0],X.shape[1]))
    if printExample:
       a=0
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
       plt.show()
   
    for i in range(X.shape[2]):
        X_sifted=X[:,:,i]+v*np.abs(np.min(X[:,:,i])) #shifto tutti i segnali in positivo
        X[:,:,i]=X_sifted/np.max(X_sifted) #normalizzo
    
    """scaler = MinMaxScaler() #forse più veloce ma meno preciso
    for i in range(X.shape[2]):
      X[:,:,i]=scaler.fit_transform(X[:,:,i])"""""
  
    return X

def remove_problematic_sample(X,y,start,stop): #alcuni campioni finiscono proprio alla fine, per altri non è stato trovata la fine, meglio 
    
    stopMax=X.shape[1]
    initial_length=X.shape[0]
    n=X.shape[0]-1
    while n>=0:
        if stop[n]==stopMax or stop[n]<10: #rimuovi take finiscono troppo tarid o finiscono troppo presto
            X=np.delete(X,n,axis=0)
            y=np.delete(y,n,axis=0)
            start=np.delete(start,n,axis=0)
            stop=np.delete(stop,n,axis=0)
            
        n-=1
    final_length=X.shape[0]
    print(f"Removed element:{initial_length-final_length}")
    return X, y,start,stop

X, y,start,stop= load_data(DATA_PATH)
X=scale_transform(X,printExample=False)
X, y,start,stop=remove_problematic_sample(X,y,start,stop)

#print(X.shape)#=(6796, 87, 13)
#print(y.shape)#=(6796,)   

#SPIKE OBBIETTIVO
S_obj=np.zeros((X.shape[0],X.shape[1],2))

#ho una sola spike alla fine del segnale obbiettivo
S_obj_single_spike=S_obj 
for n in range(X.shape[0]):
    S_obj_single_spike[n,stop[n],y[n]]=1

#ho burst di spike alla fine del segnale
S_obj_end_burst=S_obj 
burst_len=[5,2]
burst=[np.ones(burst_len[0]),np.ones(burst_len[1])]
for n in range(X.shape[0]):

    S_obj_end_burst[n,stop[n]-burst_len[0]:stop[n],y[n]]=burst[0] #neurone della classe emette 5 spike
    S_obj_end_burst[n,stop[n]-burst_len[1]:stop[n],y[n]-1]=burst[1] #neurone non della classe emette 3 spike

#spike per tutta la durata del segnale
S_obj_continuous=S_obj 
spike_interval=[2,5]
def ones_zero(duration,periodicity):# ritorna un vettore di durata duration, sotto tutti 0 tranne ogni periodicity che ho un 1
    v=np.zeros(duration)
    for n in range(duration):
        if n%periodicity==0: v[n]=1
    return v

for n in range(X.shape[0]):

    S_obj_continuous[n,start[n]:stop[n],y[n]]=ones_zero(stop[n]-start[n],spike_interval[0]) #neurone della classe emette 5 spike
    S_obj_continuous[n,start[n]:stop[n],y[n]]=ones_zero(stop[n]-start[n],spike_interval[1]) #neurone non della classe emette 3 spike

plt.figure("Spike coding type")
plt.plot(X[10])
fig, ax = plt.subplots()
ax.stem(S_obj_single_spike[10,:,1], markerfmt=' ')
plt.show()