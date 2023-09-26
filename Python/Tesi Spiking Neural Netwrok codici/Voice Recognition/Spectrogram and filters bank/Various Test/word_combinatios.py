#accuracy 92.4% primo test con successo

print("______________________________________________________________________________INIZIO")
import numpy as np
import matplotlib.pyplot as plt
from random import randint
from tqdm import tqdm
from scipy.stats import bernoulli
from mpl_toolkits.axes_grid1 import make_axes_locatable
import os
import random
random.seed(743)
import librosa
from scipy.signal import butter, lfilter,spectrogram
from sklearn import preprocessing as pre
import json
import no

JSON_PATH=r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\Voice recognition\Spectrogram, Filter bank\various_test\binary classification.json"
data={
      "Label":[],
      "accuracy":[]
     }   
if 1: #control variable
    SPECTROGRAM=True #se falso uso filter bank
    SLAYER=True #se falso uso decolle
    SHOW_SIGNAL_IMPORT=0
    SHOW_LEARNING=0
    Show_learn_interval=100
    Max_freq=8000 #frequenza massima a analizzo il segnale (deve essere minore della metà della frequenza di smpling)
    nperseg=128 #sample per segmento spettrograma

if 1: #various function   
    def Calculate_winner_neur(Network):
       S_count=0
       neuron_index=0
       dim_out=Network.dim[-1]
       N_of_layer=len(Network.dim)
       for i in range(dim_out):
            if np.count_nonzero(Network.layer[N_of_layer-1].neur[i].S_record)>S_count:
               S_count=np.count_nonzero(Network.layer[N_of_layer-1].neur[i].S_record)
               neuron_index=i
       return neuron_index
    
    def extendI(I,extension,spike_higth):
       I_ex=np.zeros((I.shape[0],extension*I.shape[1]))
       v=np.ones(extension)
       S=np.zeros((I.shape[0],extension*I.shape[1]))
       for t in range(I.shape[1]):
          for j in range(I.shape[0]):
             I_ex[j,t*extension:(t+1)*extension]=I[j,t]*v
             S[j,t*extension:(t+1)*extension]=spike_higth*bernoulli.rvs(I[j,t], size=extension)
       return I_ex,S
    
    def plot_I_in(I_in): #I_in[neur,time]
      Lines=[]
      fig, ax = plt.subplots()
      ax.set_title('Input Current')
      for i in range(I_in.shape[0]):
         line,=ax.plot(I_in[i,:],label=f'Neuron {i+1}')
         Lines.append(line)
      leg = ax.legend(loc='upper left', fancybox=True)
      leg.get_frame().set_alpha(0.4)
     
      # we will set up a dict mapping legend line to orig line, and enable
      # picking on the legend line
      lined = dict()
      for legline, origline in zip(leg.get_lines(), Lines):
          legline.set_picker(5)  # 5 pts tolerance
          lined[legline] = origline
      
      
      def onpick(event):
          # on the pick event, find the orig line corresponding to the
          # legend proxy line, and toggle the visibility
          legline = event.artist
          origline = lined[legline]
          vis = not origline.get_visible()
          origline.set_visible(vis)
          # Change the alpha on the line in the legend so we can see what lines
          # have been toggled
          if vis:
              legline.set_alpha(1.0)
          else:
              legline.set_alpha(0.2)
          fig.canvas.draw()
     
      fig.canvas.mpl_connect('pick_event', onpick)
      
      fig.canvas.manager.set_window_title('Segnali in ingresso')
    
    def plot_network(Network,obj):
       N_of_layer=Network.num_layer
       Network.show(S_obj=obj)
       Network.Algorithm_var_plot()
            
       for l in range(Network.num_layer-2,-1,-1):  
        grad_w=np.matmul(Network.sigma[l+1],Network.P_record[l].transpose()) 
        plt.figure(f"Synaptic grad of layer {l}").set_figheight(2)
      
        ax = plt.gca()
        im = ax.imshow(grad_w)
        divider = make_axes_locatable(ax)
        cax = divider.append_axes("right", size="5%", pad=0.05)
        plt.colorbar(im, cax=cax)
       
       Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2,interactive= False,start_blank=False)
       Network.synapse[N_of_layer-3].show(layer_number=N_of_layer-3,interactive=False,start_blank=False)

if 1: #signal import 
    DATASET_PATH = r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\Voice recognition\Dataset"
    
    def load_a_signal(LABEL): 
      # seleziona un segnale casuale
      for dirpath, dirnames, filenames in os.walk(DATASET_PATH):   
        if dirpath is not DATASET_PATH:
         label = dirpath.split("\\")[-1] 
         if label==LABEL:
           f=random.choice(filenames)
           file_path = os.path.join(dirpath, f)
           signal, sample_rate = librosa.load(file_path)
           if len(signal) >=int(sample_rate):
              signal = signal[:int(sample_rate)]
           break
      
      return signal, sample_rate
    
    def New_sample_spect(LABEL,show_signal_import=False): #carica segnale 
      #import segnale
      while 1: 
        #import segnale
        signal, sample_rate=load_a_signal(LABEL)
        #trova l'inizio e la fine
        start,stop=Find_Start_stop(signal,sample_rate,show=show_signal_import)
        #verifica alcune condizioni
        if start>1000 and stop<22000  and stop-start>2000 and  len(signal) >= 22050: #il segnale inizia dopo un po, non si ferma troppo tardi ed è di una certa lunghezza allora possiamo prenderlo
          break
      #calcola spettrogramma
      f, t,S_log=Log_spect(signal,sample_rate)
      #plotta
      if show_signal_import:
       plt.figure("Signal "+LABEL)
       plt.plot(signal)
       plt.axvline(x = start, color = 'g')
       plt.axvline(x = stop, color = 'r')
       plt.xlabel('time[s]')
       plt.figure("Spectrogram")
       plt.pcolormesh(t, f,S_log, shading='auto')
       plt.ylabel('Frequency [Hz]')
       plt.xlabel('Time [sec]')
       plt.colorbar(format="%+2.f")
       plt.show()    
      #normalizzazione
      S_log=normalize(S_log)
      #ritorna risultati
      wind_len=sample_rate/t.shape[0]
      return S_log,int(start/wind_len),int(stop/wind_len)
    
    def New_sample_filter_bank(LABEL,num_filter,Max_freq,show_signal_import=False): #carica segnale 
      
      while 1: #importa segnale e verifica che non abbi problemi
        signal, sample_rate=load_a_signal(LABEL)
        #trova l'inizio e la fine
        start,stop=Find_Start_stop(signal,sample_rate,show=show_signal_import)
        
        if show_signal_import:
         plt.figure("Signal "+LABEL)
         plt.plot(signal)
         plt.axvline(x = start, color = 'g')
         plt.axvline(x = stop, color = 'r')
         plt.xlabel('time[s]')
         plt.show()
        if start>1000 and stop<22000  and stop-start>2000 and  len(signal) >= 22050: #il segnale inizia dopo un po, non si ferma troppo tardi ed è di una certa lunghezza
          break
        
      if show_signal_import:
         plt.figure("Signal "+LABEL)
         plt.plot(signal)
         plt.axvline(x = start, color = 'g')
         plt.axvline(x = stop, color = 'r')
         plt.xlabel('time[s]')
         plt.show()
      
      #calcolo correnti in ingresso ai neuroni
      I_in= current_calculation(signal=signal,num_mfcc= num_filter,fs=sample_rate,max_freq=Max_freq,Show_filtered_signal=show_signal_import)
      return I_in,start,stop
    
    def current_calculation(signal,num_mfcc,fs,max_freq,Show_filtered_signal=False):
       I=np.zeros((num_mfcc,signal.shape[0]))
       filter_size=max_freq/num_mfcc
       for n in range(num_mfcc):
           I[n,:]=butter_bandpass_filter(signal, lowcut=n*filter_size+1, highcut=(n+1)*filter_size, fs=fs, order=2)
           if Show_filtered_signal:
            plt.figure(f"Signal filtered between freq {n*filter_size} and {(n+1)*filter_size}")
            plt.plot(I[n,:]) 
           I[n,:]=np.abs(I[n,:])
           I[n,:]=(I[n,:]-np.min(I[n,:]))/(np.max(I[n,:])-np.min(I[n,:]))
             
       if Show_filtered_signal:plt.show()
       return I
    
    def Find_Start_stop(signal,fs,show=False): #trova inzio e fine del segnale, usata in Preprocess dataset
        
        def smooth(x,window_len=11,window='hanning'):
     
          if x.ndim != 1:
      
           if x.size < window_len:
               raise ValueError
       
           if window_len<3:
               return x
       
       
           if not window in ['flat', 'hanning', 'hamming', 'bartlett', 'blackman']:
               raise ValueError
      
          s=np.r_[x[window_len-1:0:-1],x,x[-2:-window_len-1:-1]]
          #print(len(s))
          if window == 'flat': #moving average
              w=np.ones(window_len,'d')
          else:
              w=eval('np.'+window+'(window_len)')
      
          y=np.convolve(w/w.sum(),s,mode='valid')
          return y
    
        tr_value=0.003 #valore sopra il quale si considera inzio
        T_raise=100 #se rimane sopra/sotto il valore di treshold per T passi allora fissiamo l'inizio/la fine
        T_fall=400
        start=0 
        stop=0
    
        #filtered_signal=butter_bandpass_filter(signal, lowcut=50, highcut=4000, fs=fs, order=4) #si potrebbe filtrare ma in realtà ho visto che è inutile
        smoothed_filt_signal=smooth(np.abs(signal),window_len=500)
        
        count=0
        for index,val in enumerate(smoothed_filt_signal):
            if val>tr_value: count+=1
            else:count=0
            if count==T_raise: 
                start=index
                break
        
        count=0
        for index,val in enumerate(smoothed_filt_signal):
            if index>start and val<tr_value: count+=1
            else:count=0
            if count==T_fall: 
                stop=index
                break
            
        if show:
         plt.figure('Start-stop :smoothing')
         plt.clf()
         plt.plot(smoothed_filt_signal)
         plt.axvline(x = start, color = 'g')
         plt.axvline(x = stop, color = 'r')
         plt.xlabel('time[s]')
    
        return start,stop
        
    def butter_bandpass_filter(data, lowcut, highcut, fs, order=5): #filtraggio del segnale, usato in Find_start_stop
        
        def butter_bandpass(lowcut, highcut, fs, order=5):
            return butter(order, [lowcut, highcut], fs=fs, btype='band')
    
        b, a = butter_bandpass(lowcut, highcut, fs, order=order)
        y = lfilter(b, a, data)
        return y  
    
    def Log_spect(signal,sample_rate):
        f, t, Sxx = spectrogram(signal,sample_rate,nperseg=nperseg)
        fmin =0 # Hz
        fmax = Max_freq # Hz
        freq_slice = np.where((f >= fmin) & (f <= fmax)) 
        f   = f[freq_slice]
        Sxx = Sxx[freq_slice,:][0]  
        S_log=librosa.power_to_db(Sxx)
        return  f, t,S_log
    
    def normalize(x):
       for n in range(x.shape[0]):
           a=(np.max(x[n,:])-np.min(x[n,:]))
           if np.max(x[n,:])==np.min(x[n,:]):
              a=1
           x[n,:]=(x[n,:]-np.min(x[n,:]))/a
       return x

if 1: # network creation 
    if SPECTROGRAM: #se importo con spettro
      S_test,start,stop=New_sample_spect(LABEL="yes",show_signal_import=False)
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

trainSize=int(200)
testSize=int(100)
training="Y" #per poter passare dalla molaità training a quella di prova

SPIKE_CALCULATOR=no.Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=2
SPIKE_CALCULATOR.Num_step=EXTENSION*Num_step
SPIKE_CALCULATOR.frequency_coding=True

SPIKE_CALCULATOR.type=0
SPIKE_CALCULATOR.alfa=Network.layer[0].neur[0].alfa
SPIKE_CALCULATOR.trh=Network.layer[0].neur[0].treshold

SPIKE_CALCULATOR.spike_interval=[100,300]
SPIKE_CALCULATOR.winner_freq=1.5
SPIKE_CALCULATOR.loser_freq=0.2
SPIKE_CALCULATOR.baseline_freq=0

Network.change_beta(0)

def run(Label):
    accuracy=[]
    for e in tqdm(range(EPOCH)):
        
        #FASE DI TRAINING
        Network.training_mode=True
        for i in (range(trainSize)):
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
      
                 training=input("\n Continue training? Y/N:") 
                 #if training=="Y": Network.training_mode=True
                 #if training=="N": Network.training_mode=False
        
        #FASE DI TEST
        Network.training_mode=False
        correct_guess=0 
        No_guessed=0
        Yes_guessed=0
        for i in (range(testSize)):
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
    
        accuracy.append((correct_guess/testSize)*100)
        if accuracy[-1]>90:
           print(accuracy)
           return accuracy
    return accuracy       

Label_lsit=[["yes","no"],
            ["on","off"],
            ["right","left"],
            ["five","follow"],
            ["on","no"]]
for label in Label_lsit:
    data["Label"].append(label)
    print(f"Test: {label[0]},{label[1]}")
    data["accuracy"].append(run(label))

with open(JSON_PATH, "w") as fp:
         json.dump(data, fp, indent=4)
   
print("______________________________________________________________________________FINE")        