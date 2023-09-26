#Primissimo contatto con gli algoritmi di learning, voglio provare ad implementare lo Pike Progapagation algorithm che sembra essere uno dei più efficaci
#La rete dovrà imparare a simulare una funzione non lineare: il logaritmo 

"LIBRERIE"
import numpy as np
import math as m
import matplotlib.pyplot as plt

"DATSET"
IN=np.arange(0,1000,1)

"CODING"

"PARAMETRI SIMULAZIONE"

V_t=30 #trhesold potential
T=1000 #durata simulazione
dt=0.1 #risoluzione temporale del sistema
N_max=int(T/dt) #numero intervalli emporali della simulazione
tau=3 #costante di tempo neurone

Nin=2 #neuroni al ingresso
Nh=10 #neuroni nascosti
No=1  #neuroni in uscita

"MODELLO NEURONE"

def LIF(mem,I_in):
    mem+=-mem*dt/tau+I_in #la corrente in ingresso è la somma pesata per i pesi sinaptici dei neuroni precedenti( deve essere chiamata in questo modo nel main)

    if mem>V_t:
        mem=0  #questo porta a un piccolo probleminose provo a plottare il potenziale della membrana nel tempo: infatti ammenttiamo che a 10 s arriva un impulso esterno che fa salire il potenziale sopra soglia, se provo a plottare non vedro questa salia a causa di questa sezione. non è un grosso problema ma volevo segnalarlo comunque 
        spike=1
    
    else:
       spike=0
    
    return mem,spike

"SIMULAZIONE"
w1=15*np.random.rand(Nin,Nh) #pesi sinaptici primo layer=matrice NxK di numeri casuali tra 0 e 15
w2=15*np.random.rand(Nin,No) #pesi sinaptici primo layer=matrice KxM di numeri casuali tra 0 e 15

mem_in=np.zeros(Nin) #potenziali di membrana neuroni in ingresso
mem_hl=np.zeros(Nh) #potenziali di membrana hidden layer
mem_out=np.zeros(No) #potenziali di membrana neuroni in uscita


spike_in=np.zeros(Nin) #vettore che mi serve per sapere se il neurone del layer al ingresso ha sparato o no
spike_hl=np.zeros(Nh) #vettore che mi serve per sapere se il neurone del hidden layer ha sparato o no
spike_out=np.zeros(No) #vettore che mi serve per sapere se il neurone del layer al uscita ha sparato o no

#variabili necessarie per l'algoritmo
a=np.zeros(Nh)
inibition_out=np.zeros(No)
lr=0.1
no =5
for l in range(1000):
  for n in range(N_max):
     #CALCOLO POTENZIALI DI MEMBRANA INGRESSO
     for i in range(Nin): 
      (mem_in[i],spike_in[i])=LIF(mem_in[i],IN[i,n]) #passo il potenziale attuale e la corrente in ingresso e restituisco il potenziale aggiornato e se ha avuto una spike o no 

     In_hl=np.dot(spike_in,w1) #vettore di dimensione k con corrente il ingreso il neurone kappessimo
  
     #CALCOLO POTENZIALI DI MEMBRANA HIDDEN LAYER
     for i in range(Nh):
       (mem_hl[i],spike_hl[i])=LIF(mem_hl[i],In_hl[i])
       (a[i,n],)=LIF(a[i,n],spike_hl[i])
       
     
     In_out=np.dot(spike_hl,w2)
  
     #CALCOLO POTENZIALI DI MEMBRANA USCITA
     for j in range(No):
       (mem_out[j],spike_out[j])=LIF(mem_out[j],In_out[j])

       "ALGORITMO"
       if spike_out[j]==1 and inibition_out[j]==False: #se ho avuto una spike inibisco l'otput e aggiorno i pesi sinaprici
        inibition_out[j]=True
        for i in range(Nh):
         w2[i,j]+=lr*(no-n)*a[i,n]*tau/mem_out[j]
        


