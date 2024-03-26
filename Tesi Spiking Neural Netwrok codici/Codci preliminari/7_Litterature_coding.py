import numpy as np
import math as m
import matplotlib.pyplot as plt
from scipy.stats import bernoulli
#voglio testare i diversi tipi di coding esistenti per vederli: https://www.frontiersin.org/articles/10.3389/fnins.2021.638474/full#:~:text=Time%20to%20first%20spike%20(TTFS,a%20super%2Dfast%20transmission%20speed.
#considero come input 100 neuroni a ciascuno verra dato in input il suo numero: il neurone 50 ricevera in ingresso 50, il neurone 32 avra in input 32 ecc ecc. 
# il codice sarà il più generale possibile quindi:
n_neuroni=100 #n_neuroni
In=np.arange(0,n_neuroni,1)#input array
In=In/np.amax(In) #input normalizzato

I_t=np.amax(In) #facciamo che il treshold è il valore massimo degli input
T=1000 #durata simulazione
dt=0.1 #risoluzione temporale del sistema
N_max=int(T/dt) #numero di tic della simulazione
tau=3

#voglio plottare le spike di ciascun neurone nel tempo
coded_input=np.zeros((n_neuroni,N_max))

type_of_coding='TF' # B=bernulli, TF=time to first spike, P=phase coding,BU=burst coding

#BERNOULLI CODING
if  type_of_coding=='B':
   for n in range(n_neuroni):
       coded_input[n,:] = bernoulli.rvs(In[n], size=N_max) #bernoulli.rvc(p,size=N) resistuisce un vettore di dimensione N che corrisponde a N prove ripetute con probabilità p (quindi un vettore di 0 e 1 di cui il p% sono 1)
#TIME TO FIRST SPIKE CODING: da risolvere:quale costante porre davanti alla funzione log? cosa cambia? 
if type_of_coding=='TF':
    for n in range(n_neuroni):
        if In[n]!=0: #se In=0 non può fare il logaritmo, in tal caso l'imput rimane sempre 0
         delay=int(-T*m.log(In[n])) #in questo caso ho usato un dipendenza logaritmica come indicato da ssn torch immagino si possano usare altre funzioni
         coded_input[n,delay] = 1 #calcolo dopo quanto tempo ho una spike e lo pongo 
  
#non implemento gli altri perchè non credo siano interessanti       

for n in range(n):
  plt.plot(n*coded_input[n,:],'k.',markersize=1)

plt.title("Input Layer")
plt.xlabel("Time step")
plt.ylabel("Neuron Number")
plt.show()
