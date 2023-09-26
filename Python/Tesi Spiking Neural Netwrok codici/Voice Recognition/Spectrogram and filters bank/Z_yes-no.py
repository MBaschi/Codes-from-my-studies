#facendo runnare questo codice con

print("______________________________________________________________________________INIZIO")
import numpy as np
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm

from control_variable import SHOW_SIGNAL_IMPORT,SHOW_LEARNING,Show_learn_interval
import image_recognition.network_object as no
from network_creation import Network,EXTENSION,Num_step,N_of_layer,dim_in
from various_function import Calculate_winner_neur,extendI,plot_I_in,plot_network
from signal_import import New_sample_spect,New_sample_filter_bank, Label
from control_variable import SPECTROGRAM


if 0: #verifica che queste condizioni siano presenti 
#control variable
    SPECTROGRAM=True #se falso uso filter bank
    SLAYER=True #se falso uso decolle
    SHOW_SIGNAL_IMPORT=0
    SHOW_LEARNING=0
    Show_learn_interval=501
    Max_freq=8000 #frequenza massima a analizzo il segnale (deve essere minore della metà della frequenza di smpling)
    nperseg=128 #sample per segmento spettrograma
#load signal
    Label=["yes","no"]
# network creation
    if SPECTROGRAM: #se importo con spettro
      S_test,start,stop=New_sample_spect(LABEL=Label[0],show_signal_import=False)
      Num_step=S_test.shape[1]
      dim_in=S_test.shape[0]
      EXTENSION=3
      no.LIF_neuron.treshold=0.009 
      lr=1e-4 #learning rate
    
    if not SPECTROGRAM: #se importo con filter bank
      dim_in=20
      Num_step=22050
      EXTENSION=1
      no.LIF_neuron.treshold=0.007
      lr=1e-1 #learning rate
    
    SAMPLING_FREQUENCY = 22050 # 1 sec. of audio
    tau=0.1 #tau deve essere del ordine di grandezza del tempo di pronuncia di un si o u no, che è circa 0.3s
    tau_step=tau*Num_step*EXTENSION
    #tau=5*dt #cosi lo scelgo io come multiplo di dt
    no.LIF_neuron.alfa=1/tau_step #plottando (1-alfa)^x+ U(0) si puo vedere la risposta al impulso
    no.LIF_neuron.T_refactory=0 #periodo refrattario neuroni 
    no.LIF_neuron.RestingPotential=0
    
    dimhid1=13
    dimhid2=100
    dim_out=2
    dim=[dim_in,dim_out]
    N_of_layer=len(dim)
    
    meanW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.5)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
    varW=(no.LIF_neuron.treshold/no.LIF_neuron.alfa)*(dim_in*0.1)/(np.power(dim_in*0.5,2)-np.power(dim_in*0.1,2))
    
    meanW=0
    #varW=2.5
    
    if SLAYER:
      if SPECTROGRAM:no.Layer_slayer.plot_type=1
      if not SPECTROGRAM:no.Layer_slayer.plot_type=0
      no.Synapse_slayer.lr=lr
      Network=no.Network_slayer(dim=dim,saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)
      NetworkII=no.Network_slayer(dim=[dim_out,dim_out],saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveW=SHOW_LEARNING,meanW=meanW,varW=varW)
      NetworkII.training_mode=True
      NetworkII.Freq_coding=True  
      NetworkII.change_beta(0)
    
    if not SLAYER:
      if SPECTROGRAM:no.Layer_decolle.plot_type=1
      if not SPECTROGRAM:no.Layer_decolle.plot_type=0
    
      no.Synapse_decolle.lr=lr
    
      meanW_int=[]
      varW_int=[]
      for l in range(N_of_layer): #creo medie e varianze per inizzialzzare i pesi sinaptici dei layer d'uscita intermedi
        if l==0 or l==N_of_layer-1:
          meanW_int.append([])
          varW_int.append([])
        else:
         N_medio=dim[l]*0.3 #mediamente il neurone farà una spike se questo numero di neuroni avrà una spike
         N_var=dim[l]*0.1
         no.synapse.only_positive=False
         #meanW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_medio)
         #varW_int.append(((LIF_neuron.treshold/(2*LIF_neuron.alfa))/(np.power(N_medio,2)-np.power(N_var,2)))*N_var)
         
         meanW_int.append(0)
         varW_int.append(np.sqrt(2/(dim[l]+2)))
      
      Network=no.Network_decolle(dim=dim,saveU=SHOW_LEARNING,saveS=SHOW_LEARNING,saveAll=SHOW_LEARNING,saveW=SHOW_LEARNING,meanW=meanW,varW=varW,meanW_int=meanW_int,varW_int=varW_int)
      
    Network.training_mode=True
    Network.Freq_coding=True
    Network.change_beta(0)
    
Network.Freq_coding=True
Network.spike_conv_mode=True
EPOCH=10

trainSize=int(500)
testSize=int(3000)
#int(X.shape[0])
training="Y" #per poter passare dalla molaità training a quella di prova

SPIKE_CALCULATOR=no.Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=2
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR.frequency_coding=True

SPIKE_CALCULATOR.type=2
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa
SPIKE_CALCULATOR.trh=Network.layer[0].neur[0].treshold

SPIKE_CALCULATOR.spike_interval=[100,300]
SPIKE_CALCULATOR.winner_freq=1.5
SPIKE_CALCULATOR.loser_freq=0.2
SPIKE_CALCULATOR.baseline_freq=0

Network.change_beta(0)

for e in range(EPOCH):
    
    print(f'Epoch {e}')
    
    #FASE DI TRAINING
    print("Training progress")
    Network.training_mode=True
    for i in tqdm(range(trainSize)):
       if i%2==0: 
          label=Label[0]
          winner_neur=0
       else:
          label=Label[1]
          winner_neur=1
       
       if SPECTROGRAM:
          Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  
          I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*no.Neuron_slayer.treshold/no.Neuron_slayer.alfa)
          obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
          Network.reset()
          Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
       
       if not SPECTROGRAM:
          I_in,start,stop=New_sample_filter_bank(LABEL=label,num_filter=dim_in,Max_freq=1e4,show_signal_import=SHOW_SIGNAL_IMPORT)  
          obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
          Network.reset()   
          Network.run(num_step=Num_step*EXTENSION,I_in=I_in,obj=obj) 
     
       #mostra learning 
       if SHOW_LEARNING:
           if i%Show_learn_interval==0 or training=="N" :
             plot_I_in(I_in)
             plt.figure("objective activity")
             plt.plot(obj.T)
             plot_network(Network=Network,obj=obj)
             plt.show()
  
             training=input("Traning? Y/N:") 
             if training=="Y": Network.training_mode=True
             if training=="N": Network.training_mode=False
    
    #FASE DI TEST
    print("Test progress")
    Network.training_mode=False
    correct_guess=0 
    No_guessed=0
    Yes_guessed=0
    for i in tqdm(range(testSize)):
       if i%2==0: 
          label=Label[0]
          winner_neur=0
       else:
          label=Label[1]
          winner_neur=1
       Network.reset()
       Spect,start,stop=New_sample_spect(LABEL=label,show_signal_import=SHOW_SIGNAL_IMPORT)  

       I_in,S=extendI(Spect,EXTENSION,spike_higth=1.1*no.Neuron_slayer.treshold/no.Neuron_slayer.alfa)
       obj=SPIKE_CALCULATOR.Calculate(label=winner_neur,start=start*EXTENSION,stop=stop*EXTENSION)
       Network.run(num_step=Num_step*EXTENSION,I_in=S,obj=obj)
       neur=Network.Calculate_winner_neur(start=start*EXTENSION)
       
       if neur==winner_neur:
            correct_guess+=1
            if label==Label[0]:
               No_guessed+=1
            else:
               Yes_guessed+=1 

    print(f"Accuracy={(correct_guess/testSize)*100}") 
    print(Label[0]+f" guessed={No_guessed}")   
    print(Label[1]+f" guessed={Yes_guessed}")

print("______________________________________________________________________________FINE")        