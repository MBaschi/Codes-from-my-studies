#DECOLLE
#Studio de agoritmo decolle su una rete piccola 3x5x1 per osservare la dinamica del sistema siccome non mi piace come si comporta l'ho chiamata paper perchè ha le stesse equazioni del paper poi provo con la stessa dinami usata nel bptt
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
  layer_dim=np.array([20,12,10])
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
    
    Y0=[]
    for l in range(layer_dim.shape[0]):
      layer=np.zeros(Num_step)
      Y0.append(layer) 
    Y=deepcopy(Y0)
  if 1:#matrice G[layer][neurone]
    G=[]
    for l in range(layer_dim.shape[0]):
      layer=np.random.uniform(-layer_dim[1]/2,layer_dim[1]/2,layer_dim[l])
      G.append(layer) 
    print(G[1])
    print(G[2])
  if 1:#matrice W[layer][neurone,neurone]
    W=[]
    for l in range(layer_dim.shape[0]):
      layer=np.random.normal(loc=10,scale=50,size=(layer_dim[l],layer_dim[l-1]))
      W.append(layer)       
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
      s_in[0][i]=bernoulli.rvs(0.05, size=Num_step)
     #obbiettivo
     Y_obj=deepcopy(Y)
     Y_obj[1]=layer_dim[1]*np.ones(Num_step)
     Y_obj[2]=layer_dim[2]*np.sin((np.pi/100)*np.arange(Num_step))  #layer in uscita:sinusoide
            
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

 Excel=pd.ExcelWriter('Decolle .xlsx',engine='xlsxwriter')
 layername=('in','hid','out')
 col_Y=0
 col_U=0
 for i in range(layer_dim[0]):
   dS=pd.DataFrame(S[0][i])
   dS.to_excel(Excel,sheet_name='S in',startcol=col_U,index=False)
   col_U+=1

 plot_deltaw=plt.figure(num=1,figsize=(10, 10), dpi=100)
 plot_Y=plt.figure(num=2)
 plot_spike=plt.figure(num=3)
 colori=['b','g','r','c','m','y','k','w']

 for epo in range(epoch):
    print(epo)
    for data in range(Num_class):
       U=deepcopy(M)
       P=deepcopy(M)
       R=deepcopy(M)
       Q=deepcopy(M)
       S=deepcopy(M)
       Y=deepcopy(Y0)
       deltaW=deepcopy(deltaW_0)
       S[0]=deepcopy(s_in[data])
       
       run()
       #PLOT VARI
       if 1:
         plt.clf()
         if 1: #plot Y vs Y obj
           subplot=plot_Y.add_subplot(211)
           im=subplot.plot(Y[1])   
           im=subplot.plot(Y_obj[1],'r')   
           subplot=plot_Y.add_subplot(212)
           im=subplot.plot(Y[2])   
           im=subplot.plot(Y_obj[2],'r')    
           plt.suptitle(f"epoch:{epo}") 
         
         if 0: #plot delta W
            for j in range(layer_dim.shape[0]):
              subplot=plot_deltaw.add_subplot(311+j)
              for i in range(layer_dim[1]):
               im=subplot.plot(deltaW[1][i,j,:],colori[i]) 
            plt.suptitle(f"epoch:{epo}")  
         
         if 1: #plot spike
          for l in range(layer_dim.shape[0]-1):
            l+=1
            subplot=plot_spike.add_subplot((layer_dim.shape[0]-1)*100+10+l)
            for i in range(layer_dim[l]):
              im=subplot.plot((i+1)*S[l][i],'k.',markersize=1) 

      
         plt.pause(1)
        
        
    
    #EXCEL 
    if 1:  
      col_Y+=2
      for l in range(layer_dim.shape[0]-1):
              l+=1
              col_U=0
             
              dY=pd.DataFrame(Y[l])
              dY.to_excel(Excel,sheet_name='Y '+layername[l],startcol=col_Y,header=[f'{epo}'],index=False)
              for i in range(layer_dim[l]):
                
                dU=pd.DataFrame(U[l][i])
                dU.to_excel(Excel,sheet_name='U '+layername[l],startcol=col_U+layer_dim[l]*col_Y,header=[f'{epo}'],index=False)
    
                dS=pd.DataFrame(S[l][i])
                dS.to_excel(Excel,sheet_name='S '+layername[l],startcol=col_U+layer_dim[l]*col_Y,header=[f'{epo}'],index=False)
    
                """dP=pd.DataFrame(P[l][i])
                dP.to_excel(Excel,sheet_name='P '+layername[l],startcol=col_U+layer_dim[l]*col_Y,header=[f'{epo}'],index=False)
    
                dQ=pd.DataFrame(Q[l][i])
                dQ.to_excel(Excel,sheet_name='Q '+layername[l],startcol=col_U+layer_dim[l]*col_Y,header=[f'{epo}'],index=False)
    
                dR=pd.DataFrame(U[l][i])
                dR.to_excel(Excel,sheet_name='R '+layername[l],startcol=col_U+layer_dim[l]*col_Y,header=[f'{epo}'],index=False)"""
                col_U+=1
Excel.save() 
  
  #print(f'epoch:{epo}   loss:{loss[epo]:.2f} ')
print("fine") 
