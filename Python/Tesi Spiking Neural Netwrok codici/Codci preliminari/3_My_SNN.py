#Desidero creare un network con n neuroni in imput e m in output e un hidden layer di idmensione k
#uso un neurone di tipo LIF, l'imput saraà casuale e la rete non verrà allenata

print ("___________________________________________________________")

import numpy as np
import math as m
import matplotlib.pyplot as plt

#PARAMETRI SIMULAZIONE
t=0 #istante inizale =0
t_max=100 #tempo di simuatione in secondi
dt=0.1 #risoluzione temporale del sistema

#MODELLO NEURONE
# Prima definisco una funzione per il neurone, riceverà in ingresso il potenziale attuale e la corrente in ingresso
# resistituisce il potenziale futuro e 1 se è avvenuta ua spike 0 altrimenti. se avviene una spike il potenziale viene resettato a 0
I_t=10  #treshold curretn
tau=1  #time costant

def LIF(mem,I_in):
    mem+=-mem*dt/tau+I_in #la corrente in ingresso è la somma pesata per i pesi sinaptici dei neuroni precedenti( deve essere chiamata in questo modo nel main)

    if mem>I_t:
        #mem=0  #questo porta a un piccolo probleminose provo a plottare il potenziale della membrana nel tempo: infatti ammenttiamo che a 10 s arriva un impulso esterno che fa salire il potenziale sopra soglia, se provo a plottare non vedro questa salia a causa di questa sezione. non è un grosso problema ma volevo segnalarlo comunque 
        spike=1
    
    else:
       spike=0
    
    return mem,spike

#STRUTTURA RETE 
N=10 #dimensione rete in ingresso
K=5  #dimensione rete intermedio
M=2  #dimensione rete in uscita

w_1=15*np.random.rand(N,K) #pesi sinaptici primo layer=matrice NxK di numeri casuali tra 0 e 15
w_2=15*np.random.rand(K,M) #pesi sinaptici primo layer=matrice KxM di numeri casuali tra 0 e 15

mem_in=np.zeros(N) #potenziali di membrana neuroni in ingresso
mem_hl=np.zeros(K) #potenziali di membrana hidden layer
mem_out=np.zeros(M) #potenziali di membrana neuroni in uscita
#print(w_1) #funziona come desiderato

#INPUT
 #ora voglio provare l'input in cui tutti i neuroni in ingresso si attivano a 10 secondi
IN=np.zeros((N,int(t_max/dt))) #l'input è una matrice di dimensione 10 (numero di neuroni)xt_max/dt (numero di intervalli tenporali della simulazione)
IN[:,int(10/dt)]=(I_t+1)*np.ones(N) 
#print(IN[:,int(10/dt)])
#print(IN[:,int(13/dt)])


#SIMULAZIONE
mem_in_read=np.zeros((N,int(t_max/dt))) #vettore in cui salvo l'andamento nel tempo del potenziale di membrana dei N neuroni in ingresso 
mem_hl_read=np.zeros((K,int(t_max/dt))) #vettore in cui salvo l'andamento nel tempo del potenziale di membrana dei K neuroni nascosti
mem_out_read=np.zeros((M,int(t_max/dt))) #vettore in cui salvo l'andamento nel tempo del potenziale di membrana dei M neuroni in uscita 

spike_in=np.zeros(N) #vettore che mi serve per sapere se il neurone del layer al ingresso ha sparato o no
spike_hl=np.zeros(K) #vettore che mi serve per sapere se il neurone del hidden layer ha sparato o no
spike_out=np.zeros(M) #vettore che mi serve per sapere se il neurone del layer al uscita ha sparato o no

spike_in_read=np.zeros((N,int(t_max/dt)))
spike_hl_read=np.zeros((K,int(t_max/dt)))
spike_out_read=np.zeros((M,int(t_max/dt)))

n=0;#count number 

while(t<t_max):
   for i in range(N):
    (mem_in[i],spike_in[i])=LIF(mem_in[i],IN[i,n]) #passo il potenziale attuale e la corrente in ingresso e restituisco il potenziale aggiornato e se ha avuto una spike o no 
    mem_in_read[i,n]=mem_in[i] #salvo il dato, non posso usare append 
    spike_in_read[i,n]=spike_in[i]
   
   I_in_hl=np.dot(spike_in,w_1) #vettore di dimensione k con corrente il ingreso il neurone kappessimo
   for i in range(K):
     (mem_hl[i],spike_hl[i])=LIF(mem_hl[i],I_in_hl[i])
     mem_hl_read[i,n]=mem_hl[i] 
     spike_hl_read[i,n]=spike_hl[i]
   
   I_in_out=np.dot(spike_hl,w_2)
   for i in range(M):
     (mem_out[i],spike_out[i])=LIF(mem_out[i],I_in_out[i])
     mem_out_read[i,n]=mem_out[i]
     spike_out_read[i,n]=spike_out[i]
   n=int(t/dt)

   t=t+dt

plt.plot(spike_in_read[2,:])
plt.show()

print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
