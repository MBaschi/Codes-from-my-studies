import matplotlib.pyplot as plt
import numpy as np

import os
import random
random.seed(743)
import librosa
from scipy.signal import butter, lfilter,spectrogram
from sklearn import preprocessing as pre

from control_variable import Max_freq,nperseg

#DATASET_PATH = 'yes-no'
#Label=["yes","no"]
DATASET_PATH = "D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\Voice recognition\Dataset"
Label=["happy","cat"]

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

if 0:
  f,t,Sxx=New_sample_spect(LABEL="learn",show_signal=True)
  print(f.shape)
  
  for i in range(10):
     New_sample_spect(LABEL="learn",show_signal=True)
     New_sample_spect(LABEL="follow",show_signal=True)