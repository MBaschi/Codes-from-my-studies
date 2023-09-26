#SLAYER
#in slayer one data la reta è stata capace di apprendere con il BPTT una sequenza, qui ho provato a fargli apprendere due sequenze con due output distinti
Num_class=1

# 1)LIBRERIE E COSE PRELIMINARI
if 1:
 import numpy as np
 import math as m
 import pandas as pd
 import matplotlib.pyplot as plt
 from scipy.stats import bernoulli
 from scipy import signal
 from copy import copy, deepcopy
 np.set_printoptions(precision=1)

#2)PARAMETRI SIMULAZIONE E NETWORK
if 1:
  #parametri simulazione
 if 1:
  T=5e-2 #tempo in secondi
  dt=1e-4 #dt
  Num_step = int(T/dt)
  epoch=100
  #parametri neurone
 if 1:
  tau_membrane=5e-3 #costante di tempo membrana in secondi
  tau_synapse=5e-3 #costante di tempo sinapsi in secondi
  tau_refactory=5e-3 #costante di tempo periodo refatttario in secondi
  
  alfa=0.95 #np.exp(-dt/tau_membrane)
  gamma=0.65 #np.exp(-dt/tau_refactory)
  beta=0.92 #np.exp(-dt/tau_synapse)

  treshold = 1
  ro=1
  #parametri network
 if 1:
  layer_dim=np.array([4,4,Num_class])
  #variabili neuroni e pesi sinaptici
 if 1:
  if 1: #matrice vuota con dimensioni M[layer][neurone][tempo]
    val=np.zeros
    M=[]
    for l in range(layer_dim.shape[0]):
      neur=[]
      for i in range(layer_dim[l]):
        time=[]
        neur.append(np.zeros(Num_step))
      M.append(neur) 
  U=deepcopy(M)
  P=deepcopy(M)
  R=deepcopy(M)
  Q=deepcopy(M)
  S=deepcopy(M) #tutte queste variabili del sistema hanno come dimensione [layer][neurone][tempo]
  
  if 1:#matrice Y[layer][tempo]
    layer=np.zeros(Num_step)
    Y0=[]
    for l in range(layer_dim.shape[0]):
      Y0.append(layer) 
    Y=deepcopy(Y0)
  if 1:#matrice G[layer][neurone]
    G=[]
    for l in range(layer_dim.shape[0]):
      layer=np.random.uniform(-1,10,layer_dim[l])
      G.append(layer) 

    print(G[1])
  if 1:#matrice W[layer][neurone,neurone]
    W=[]
    for l in range(layer_dim.shape[0]):
      layer=np.random.normal(loc=0,scale=1,size=(layer_dim[l],layer_dim[l-1]))
      W.append(layer)  
    
  #variabili algoritmo
 if 1:
  lr=1e-3 #learning rate
  #variabili per salvataggio e plotting
 if 1:
  loss=np.zeros((epoch))
  loss_data=np.zeros((Num_class,epoch))

#3)DATA HANDLING
if 1:
     #spike in ingresso
     s_in=[] 
     for i in range(Num_class): #[data][neurone][tempo]
      s_in.append(S[0])
     
     for i in range(layer_dim[0]):
        s_in[0][i]=bernoulli.rvs(0.1, size=Num_step)
        """for t in range(Num_step):
          if t%5==0:s_in[0][i][t]=1"""
     #obbiettivo
     Y_obj=deepcopy(Y)
     #Y_obj[1]=np.linspace(0,10,Num_step) #primo layer:lineare
     Y_obj[1]=10*np.ones(Num_step)
     Y_obj[2]=np.sin((np.pi/100)*np.arange(Num_step))  #layer in uscita:sinusoide
            
#4)SIMULAZIONE
if 1:

 def surr_grad(U_i):
  grad=0
  if 0.5<U_i<1.5: grad=1
  return grad  
  
 def run ():
    for t in range(Num_step-1):
      for l in range(layer_dim.shape[0]-1):
        l+=1
        #simulazione sistema
        for i in range(layer_dim[l]):
          for j in range(layer_dim[l-1]):
            if S[l-1][j][t]==1:
              pass 
            U[l][i][t]+=W[l][i,j]*P[l-1][j][t]
            P[l-1][j][t+1]=alfa*P[l-1][j][t]+(1-alfa)*Q[l-1][j][t]
            Q[l-1][j][t+1]=beta*Q[l-1][j][t]+(1-beta)*S[l-1][j][t]
            
          U[l][i][t]-=ro*R[l][i][t] 
          if U[l][i][t]>treshold:S[l][i][t]=1
          R[l][i][t+1]=gamma*R[l][i][t]+(1-gamma)*S[l][i][t]
          
          Y[l][t]+=G[l][i]*S[l][i][t]
        #calcolo errore e modfica pesi sinaptici
        for j in range(layer_dim[l-1]):
          W[l][i,j]-=lr*G[l][i]*(Y[l][t]-Y_obj[l][t])*surr_grad(U[l][i][t])*P[l-1][j][t]

 plot=plt.figure(3)
 for epo in range(epoch):
  for data in range(Num_class):
     U=deepcopy(M)
     P=deepcopy(M)
     R=deepcopy(M)
     Q=deepcopy(M)
     S=deepcopy(M)
     Y=deepcopy(Y0)
     S[0]=deepcopy(s_in[data])
     run()
    

  plt.clf()
  subplot=plot.add_subplot(111)
  im=subplot.plot(Y[1])   
  im=subplot.plot(Y_obj[1],'r')    
  plt.suptitle(f"epoch:{epo}") 
  plt.pause(0.2)
  #print(f'epoch:{epo} ')
print("fine") 
