print("////////////////////////////////")
#in questo programma studio l'encoding in frequenza. Devo fare due cos:provare a decodificare il daset del mnist e provare a vedere la risposta di un neurone ad un ingresso di correne
from keras.datasets import mnist
import numpy as np
import math as m
import matplotlib.pyplot as plt
from Cronometro import ChronoMeter

chrono = ChronoMeter()

chrono.start_chrono()

frequency_response=1  #se uguale a 1 allora sto studiando la risposta in frequenza del neurone altrimenti sto trascrivendo il dataset del mnist

#PARAMETRI SIMULAZIONE

t=0 #istante inizale =0
t_max=1000 #tempo di simuatione in secondi
dt=0.1 #risoluzione temporale del sistema

N_max=int(t_max/dt) #numero di tic della simulazione

#MODELLO NEURONE  

I_t=500  #treshold curretn
tau=5 #time costant

def LIF(mem,I_in):
    mem+=-mem*dt/tau+I_in #la corrente in ingresso è la somma pesata per i pesi sinaptici dei neuroni precedenti( deve essere chiamata in questo modo nel main)

    if mem>I_t:
        mem=0  #questo porta a un piccolo probleminose provo a plottare il potenziale della membrana nel tempo: infatti ammenttiamo che a 10 s arriva un impulso esterno che fa salire il potenziale sopra soglia, se provo a plottare non vedro questa salia a causa di questa sezione. non è un grosso problema ma volevo segnalarlo comunque 
        spike=1
    
    else:
       spike=0
    
    return mem,spike

#IMPORTAZIONE E TRASFORMAZIONE INPUT

if frequency_response==1:
     IN=np.arange(0,255,1) #prendo 255 ingressi corrispondenti ai 155 valori possibili del immagine
     mem_in_read=np.zeros((255,N_max))
     spike_in_read=np.zeros((255,N_max))
     frequency=np.zeros(255)

     for i in range(255): #scorrere dei valori in ingresso
      mem_in=0
      spike_in=0
      counter=0
      a=0 #spiego alla riga 57 a cosa serve
      for n in range(N_max): #scorrere del tempo
        (mem_in,spike_in)=LIF(mem_in,IN[i]) #passo il potenziale attuale e la corrente in ingresso e restituisco il potenziale aggiornato e se ha avuto una spike o no 
        mem_in_read[i,n]=mem_in 
        spike_in_read[i,n]=spike_in
        #voglio calcolare dopo quanti intervalli temporali si presenta laprime spike per poter poi calcolare la frequenza. Siccome si ripeteranno in modo periodico basta che lo faccia una volta sola(a questo serve la variabile a)
        if a==0 and spike_in==0:
         counter+=1
        if a==0 and spike_in!=0: #ho avuto la prima spike 
          frequency[i]=1/counter
          a=1
     
     plot1 = plt.subplot(231)
     plot1.plot(mem_in_read[70,0:50])

     plot2 = plt.subplot(232)
     plot2.plot(mem_in_read[240,0:50])

     plot3 = plt.subplot(233)
     plot3.plot(spike_in_read[70,0:50])

     plot4 = plt.subplot(234)
     plot4.plot(spike_in_read[240,0:50])

     plot5 = plt.subplot(235)
     plot5.plot(frequency)


     plt.show()
    
else:
     
     (train_X, train_y), (test_X, test_y) = mnist.load_data() #206ms
     
     
     #devo trasformare l'input che sono 6000 matrici 28x28 in una matrice 6000x28^2
     IN=np.zeros((train_X.shape[0],train_X.shape[1]*train_X.shape[2])) #matrice vuota in cui mettere i valori
     for i in range(train_X.shape[0]):
         a=0
         for j in range(train_X.shape[1]):
             for k in range(train_X.shape[2]):
                 IN[i,a]=train_X[i,j,k]
                 a+=1
         #questa trasformazione ci mette 17 337 ms=17 secondi
     
     
     
     #L'imput può andareda 0 a 255. voglio che con zero la frquenza con cui spara sia zero mentre se è 255 voglio che la frequenza sia massima
     
     
     #SIMULAZIONE
     
     N=train_X.shape[1]*train_X.shape[2] #numero di neuroni necessari
     
     mem_in=np.zeros(N) #potenziali di membrana neuroni in ingresso
     mem_in_read=np.zeros((N,N_max))
     spike_in=np.zeros(N) #vettore che mi serve per sapere se il neurone del layer al ingresso ha sparato o no
     spike_in_read=np.zeros((N,N_max))
     
     chrono.start_chrono()
     
     #for immagine_n in range(train_X.shape[0]):
     for n in range(N_max):
         for n_neur in range(N):
             (mem_in[n_neur],spike_in[n_neur])=LIF(mem_in[n_neur],IN[1,n_neur]) #passo il potenziale attuale e la corrente in ingresso e restituisco il potenziale aggiornato e se ha avuto una spike o no 
             mem_in_read[n_neur,n]=mem_in[n_neur] #salvo il dato, non posso usare append 
             spike_in_read[n_neur,n]=spike_in[n_neur]
       #il calcolo per 738 neuroni per 1000 secondi è 8030ms=8s cio significa che per elaborare 6000 immagini ci metterebbe 8000 minuti


print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")


            