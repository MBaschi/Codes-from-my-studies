# e praticamente identico al 4.1 ma ilo segnale è ripetuto in modo periodico, così la rete può riazzerarsi, questa pausa è un po come avere delle epoch

#Vorrei creare una rete che con l'algortmo decolle riconosca i massi di un segnale somma di più segnali sinosoidali
from Decolle_class import LIF_neuron, Network_decolle_II,Synapse_decolle
import numpy as np
import matplotlib.pyplot as plt



#Segnale
from signal_creation import signal,show_signal,Num_step
show_signal(True)

#Parametri network e neurone
from network_creation import Network,N_of_layer

#Correnti in ingresso ai vari neuroni del network
from CurrentIn_creation import I_in, S_obj

#simulazione
epoch=100
Network.training_mode=False
Network.training_mode=True


for e in range(epoch):
 print(e)
 if e==72: Network.training_mode=False
 Network.reset()
 
 Network.run(num_step=Num_step,I_in=I_in,S_obj=S_obj)


 if e>2:
   input("next")
   plt.close('all')
   #Network.layer[N_of_layer-1].show(layer_number=N_of_layer-1,int=0,S_obj=S_obj)
   #if Network.training_mode==True: Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2)
   Network.show(fig=0,S_obj=S_obj)
   Network.Algorithm_var_plot(0)
   Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2)
   Network.synapse[N_of_layer-3].show(layer_number=N_of_layer-3)
   plt.pause(0.5)
   
plt.show()

Network.show(0,S_obj=S_obj)
Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2)
Network.synapse[N_of_layer-3].show(layer_number=N_of_layer-3)
plt.show()
 


