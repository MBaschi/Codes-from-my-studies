#Primissimo contatto con gli algoritmi di learning, voglio provare ad implementare lo SPIKE PROPAGATION algorithm che sembra essere uno dei più efficaci
#La rete dovrà imparare a simulare una funzione non lineare: il logaritmo 
print("///////////////////////////////x")
"LIBRERIE"

import numpy as np
import math as m
import matplotlib.pyplot as plt

"DATSET"


"PARAMETRI SIMULAZIONE"

V_t=1 #trhesold potential
V_rest=0.1 #rest potential
T=500 #durata simulazione
dt=0.1 #risoluzione temporale del sistema
N_max=int(T/dt) #numero intervalli emporali della simulazione
tau=3 #costante di tempo neurone

Nin=2 #neuroni al ingresso
Nh=2 #neuroni nascosti
No=2 #neuroni in uscita

"CODING"

"MODELLO NEURONE"

def LIF(mem,I_in):
    mem+=-mem*dt/tau+I_in #la corrente in ingresso è la somma pesata per i pesi sinaptici dei neuroni precedenti( deve essere chiamata in questo modo nel main)

    if mem>V_t:
        mem=V_rest #questo porta a un piccolo probleminose provo a plottare il potenziale della membrana nel tempo: infatti ammenttiamo che a 10 s arriva un impulso esterno che fa salire il potenziale sopra soglia, se provo a plottare non vedro questa salia a causa di questa sezione. non è un grosso problema ma volevo segnalarlo comunque 
        spike=1
    
    else:
       spike=0
    
    return mem,spike

"SIMULAZIONE"
no=np.zeros(No)

for j in range(No):
    no[j]=(j+1)*100

delay_=100*np.random.rand(Nin) #input metto

w1=V_t*np.random.rand(Nin,Nh) #pesi sinaptici primo layer=matrice NxK di numeri casuali tra 0 e 15
w2=V_t*np.random.rand(Nh,No) #pesi sinaptici primo layer=matrice KxM di numeri casuali tra 0 e 15
EP=1

N_spike=np.zeros((No,EP))

for epoch in range(EP):

     print(epoch )
     
     U_in=V_rest*np.ones(Nin) #potenziali di membrana neuroni in ingresso
     U_hl=V_rest*np.ones(Nh) #potenziali di membrana hidden layer
     U_out=V_rest*np.ones(No) #potenziali di membrana neuroni in uscita
     
     S_in=np.zeros(Nin) #vettore che mi serve per sapere se il neurone del layer al ingresso ha sparato o no
     S_hl=np.zeros(Nh) #vettore che mi serve per sapere se il neurone del hidden layer ha sparato o no
     S_out=np.zeros(No) #vettore che mi serve per sapere se il neurone del layer al uscita ha sparato o no
     
     Inibition_out=np.zeros(No) #inibisce i neuroni in uscita
     
     #variabili per algoritmo
     ah=np.zeros(Nh) #neurone fittizzio: simula un neurone collegato al h-esimo neurone del hiddenlayer attraverso una sinapsi con peso 1
     ai=np.zeros(Nin) #stessa cosa di sopra ma per l'input layer
     f=np.zeros((No,Nh,Nin)) #l'emento j,h,i rappresenta il contributo del neurone i alla spike del neurone h, spike che è avvenuta prima della spike di j
     lr=0.1 #learning rate
     delta=np.zeros(No)
     Uj=np.zeros((No,Nh)) #salva il valore del potenziale di membrana del layer in uscita
     
     mem_in_read=np.zeros((Nin,N_max)) #DEBUG
     mem_hl_read=np.zeros((Nh,N_max)) 
     mem_out_read=np.zeros((No,N_max)) 
     
     
     for n in range(N_max): 
        #CALCOLO POTENZIALI DI MEMBRANA INGRESSO
        for i in range(Nin):
            if n==int(delay_[i]):
              IN=V_t
              delay_[i]+=int(tau/(2*dt)) #ogni tau/2 invio una spike
            else: 
              IN=0
            (U_in[i],S_in[i])=LIF(U_in[i],IN) #passo il potenziale attuale e la corrente in ingresso e restituisco il potenziale aggiornato e se ha avuto una spike o no 
            ai[i]+=-ai[i]*dt/tau+S_in[i] #simulo neurone fittizzio

            mem_in_read[i,n]=U_in[i] #DEBUG
            
         
        In_hl=np.dot(S_in,w1) #vettore di dimensione k con corrente il ingreso il neurone kappessimo
     
        #CALCOLO POTENZIALI DI MEMBRANA HIDDEN LAYER
        for h in range(Nh):
            (U_hl[h],S_hl[h])=LIF(U_hl[h],In_hl[h]) 
            ah[h]+=-ah[h]*dt/tau+In_hl[h] #simulo neurone fittizzio

            mem_hl_read[h,n]=U_hl[h] #DEBUG

            if S_hl[h]==1: #se il neurone ha sparato una spike salvo il valore del potenziale del neur in uscita prima che la spike faccia effetto (serve per l'algoritmo)
              for j in range(No):
                 if Inibition_out[j]==0:
                      Uj[j,h]=U_out[j] #potenziali di membrana dei neuroni in uscita quando il neurone h ha sparato
                      for i in range(Nin):
                          f[j,h,i]=ai[i]/U_hl[h] #calcolo f (guarda formula)
                    
        In_out=np.dot(S_hl,w2)
     
        #CALCOLO POTENZIALI DI MEMBRANA USCITA
        for j in range(No):
          if Inibition_out[j]==0: #i neuroni in uscita possono attivarsi solo una volta poi vengono inibiti
            (U_out[j],S_out[j])=LIF(U_out[j],In_out[j])
            "ALGORITMO" 

            mem_out_read[j,n]=U_out[j] #DEBUG

            if S_out[j]==1: #Ho una spike al neurone j devo avviare l'algoritmo di backpropagation

                N_spike[j,epoch]=n #DEBUG
                
                Inibition_out[j]=1 #inanzitutto inibisco il neurone che ha sparato
                S_out[j]=0 #porto S_out a zero altrimenti al ciclo successivo rientra nel if
                for h in range(Nh):
                    delta[j]=(no[j]-n)*dt/U_out[j]
                    w2[h,j]-=lr*delta[j]*ah[h]*tau       
        
        if (Inibition_out==np.ones(No)).all: #quando tutti i neuroni in uscita hanno sparato aggiorno i pesi sinaptici in base ai risultati
            for i in range(Nin): 
                for h in range(Nh):
                    for j in range(No):
                           w1[i,h]-=lr*delta[j]*Uj[j,h]*tau*f[j,h,i]

""""
plot1 = plt.subplot(221)
plot1.plot(N_spike[0,:])
plot2 = plt.subplot(222)
plot2.plot(N_spike[1,:])
plot3 = plt.subplot(223)
plot3.plot(N_spike[2,:])
plot4 = plt.subplot(224)
plot4.plot(N_spike[3,:])
"""""

plot1 = plt.subplot(321)
plot1.plot(mem_in_read[0,:])
plot2 = plt.subplot(322)
plot2.plot(mem_in_read[1,:])

plot3 = plt.subplot(323)
plot3.plot(mem_hl_read[0,:])
plot4 = plt.subplot(324)
plot4.plot(mem_hl_read[1,:])

plot5 = plt.subplot(325)
plot5.plot(mem_out_read[0,:])
plot6 = plt.subplot(326)
plot6.plot(mem_out_read[1,:])



plt.show()
print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX") 