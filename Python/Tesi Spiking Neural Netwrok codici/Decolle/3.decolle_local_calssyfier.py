#DECOLLE
#la loss locale in questo codice è mean square error loss ed ogni layer deve classiffiacre l'ingresso
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
 print("(1)")

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
  layer_dim=np.array([3,4,Num_class])
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
    U=deepcopy(M) #potenziali di membrana
    U_out=deepcopy(M) #potenziali di membrana dei neuroni di uscita intermedi
    P=deepcopy(M) #attività sinapsi
    R=deepcopy(M) #periodo refattario
    Q=deepcopy(M)
    S=deepcopy(M) #tutte queste variabili del sistema hanno come dimensione [layer][neurone][tempo]
  if 1:#matrice Y[layer][class]
    layer=np.zeros(Num_class)
    Y0=[]
    for l in range(layer_dim.shape[0]):
      Y0.append(layer) 
    Y=deepcopy(Y0) 
  if 1:#matrice G[layer][neurone]
    G=[]
    for l in range(layer_dim.shape[0]):
      layer=np.random.uniform(0,layer_dim[1],layer_dim[l])
      G.append(layer) #matrice decriptaggio layer
    print(G[1])
  if 1:#matrice W[layer][neurone,neurone] 
    W=[]
    for l in range(layer_dim.shape[0]):
      layer=np.random.normal(loc=10,scale=50,size=(layer_dim[l],layer_dim[l-1]))
      W.append(layer) #pesi sinaptici       
  #variabili algoritmo
 if 1:
  lr=1e-1#learning rate
  #variabili per salvataggio e plotting
 if 1:
  loss=np.zeros((epoch))
  loss_data=np.zeros((Num_class,epoch))
  deltaW_0=[]
  deltaW=[]
  for l in range(layer_dim.shape[0]):
      layer=np.zeros((layer_dim[l],layer_dim[l-1],Num_step))
      deltaW_0.append(layer)  
  deltaW=deepcopy(deltaW_0)

#3)DATA HANDLING
if 1:
     
     #spike in ingresso
     s_in=[] 
     for i in range(Num_class): #[data][neurone][tempo]
      s_in.append(S[0])
     
     for i in range(layer_dim[0]):
        for j in range(Num_class):
          s_in[j][i][:]=bernoulli.rvs(0.01, size=Num_step)
     
     if 1: #creazione sequenze
          f_high=0.2 #frequenza di neurone attivo
          #sequenza 1 = X
          s_in[0][0][:] = bernoulli.rvs(f_high, size=Num_step)  
          s_in[0][2][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[0][4][:] = bernoulli.rvs(f_high, size=Num_step)   
          s_in[0][6][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[0][8][:] = bernoulli.rvs(f_high, size=Num_step)
  
          #sequenza 2 = []
          s_in[1][0][:] = bernoulli.rvs(f_high, size=Num_step)  
          s_in[1][1][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[1][2][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[1][3][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[1][5][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[1][6][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[1][7][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[1][8][:] = bernoulli.rvs(f_high, size=Num_step)

          #sequenza 3 = 0
          s_in[2][1][:] = bernoulli.rvs(f_high, size=Num_step)  
          s_in[2][3][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[2][5][:] = bernoulli.rvs(f_high, size=Num_step)   
          s_in[2][7][:]= bernoulli.rvs(f_high, size=Num_step)

          #sequenza 4 = +
          s_in[3][1][:] = bernoulli.rvs(f_high, size=Num_step)  
          s_in[3][3][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[3][4][:] = bernoulli.rvs(f_high, size=Num_step)
          s_in[3][5][:] = bernoulli.rvs(f_high, size=Num_step)   
          s_in[3][7][:] = bernoulli.rvs(f_high, size=Num_step)

     #obbiettivo
     Y_obj=0.1*np.ones([Num_class,Num_class]) #matrice contenente i vettori obbiettivo es: classe 0 Y_obj[0][:]=[1 0.1 0.1 0.1] classe 1 Y_obj[1,:]=[0.1 1 0.1 0.1]
     for i in range(Num_class): #[classe]
      Y_obj[i,i]=1
            
#4)SIMULAZIONE
if 1:

 def surr_grad(U):
  grad=0
  if 0.5*treshold<U<1.5*treshold: grad=1
  return grad  
  
 def run ():
    for t in range(Num_step-1):
      for l in range(layer_dim.shape[0]-1):
        l+=1
        #simulazione sistema
        for i in range(layer_dim[l]):
          for j in range(layer_dim[l-1]):
            U[l][i][t]+=W[l][i,j]*P[l-1][j][t]
            P[l-1][j][t+1]=alfa*P[l-1][j][t]+(1-alfa)*Q[l-1][j][t]
            Q[l-1][j][t+1]=beta*Q[l-1][j][t]+(1-beta)*S[l-1][j][t]
            
          U[l][i][t]-=ro*R[l][i][t] 
          if U[l][i][t]>treshold:
            S[l][i][t]=1
          R[l][i][t+1]=gamma*R[l][i][t]+(1-gamma)*S[l][i][t]
          
          Y[l][t]+=G[l][i]*S[l][i][t]

        #calcolo errore e modfica pesi sinaptici
        for i in range(layer_dim[l]):
          for j in range(layer_dim[l-1]):
            W[l][i,j]-=lr*G[l][i]*(Y[l][t]-Y_obj[l][t])*surr_grad(U[l][i][t])*P[l-1][j][t]
            deltaW[l][i,j,t]=lr*G[l][i]*(Y_obj[l][t]-Y[l][t])*surr_grad(U[l][i][t])*P[l-1][j][t]

 for epo in range(epoch):
    print(epo)
    for data in range(Num_class):
       if 1: #zero var
         U=deepcopy(M)
         P=deepcopy(M)
         R=deepcopy(M)
         Q=deepcopy(M)
         S=deepcopy(M)
         Y=deepcopy(Y0)
         deltaW=deepcopy(deltaW_0)
         
       S[0]=deepcopy(s_in[data])
       run()

print("fine") 
