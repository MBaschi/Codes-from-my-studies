import matplotlib.pyplot as plt
import numpy as np

import os
import random
random.seed(743)
import librosa
from scipy.signal import butter, lfilter,spectrogram
from sklearn import preprocessing as pre
from mpl_toolkits.axes_grid1 import make_axes_locatable
from scipy.stats import bernoulli

Max_freq=8000

DATASET_PATH = r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\Voice recognition\Dataset"
LABELS=["backward", "bed", "bird", "cat", "dog", "down", "eight", "five", "follow", "forward", "four", "go", "happy", "house", "learn", "left", "marvin", 
        "nine", "no", "off", "on", "one", "right", "seven", "sheila", "six", "stop", "three", "tree", "two", "up", "visual", "wow", "yes", "zero"]
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
    
def Log_spect(signal,sample_rate):
    f, t, Sxx = spectrogram(signal,sample_rate,nperseg=128)
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
   x=np.arange(start=0,stop=22050,step=1)/22050
   plt.plot(x,signal)
   plt.axvline(x = start/22050, color = 'g')
   plt.axvline(x = stop/22050, color = 'r')
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


def extendI(I,extension,spike_higth):
   I_ex=np.zeros((I.shape[0],extension*I.shape[1]))
   v=np.ones(extension)
   S=np.zeros((I.shape[0],extension*I.shape[1]))
   for t in range(I.shape[1]):
      for j in range(I.shape[0]):
         I_ex[j,t*extension:(t+1)*extension]=I[j,t]*v
         S[j,t*extension:(t+1)*extension]=spike_higth*bernoulli.rvs(I[j,t], size=extension)
   return I_ex,S


def plot_I_in(I_in,start_blank): #I_in[neur,time]
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
  if start_blank:
             for l in Lines:
              l.set_visible(False)
              
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

