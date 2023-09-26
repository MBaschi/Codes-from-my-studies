import matplotlib.pyplot as plt
import numpy as np

import os
import random
import librosa
from scipy.signal import butter, lfilter,spectrogram

from Variables import DATASET_PATH,SPIKE_CALCULATOR, Num_in_chan,Max_freq,Num_step,SHOW_SIGNAL_IMPORT

def load_a_signal(LABEL): 
  # seleziona un segnale casuale
  for dirpath, dirnames, filenames in os.walk(DATASET_PATH):
    if dirpath is not DATASET_PATH:
     label = dirpath.split("\\")[-1]
     if label==LABEL:
       f=random.choice(filenames)
       file_path = os.path.join(dirpath, f)
       signal, sample_rate = librosa.load(file_path)
       if len(signal) >=Num_step:
          signal = signal[:Num_step]
       break
  return signal, sample_rate

def New_sample(LABEL): #carica segnale 
  
  while 1: #importa segnale e verifica che non abbi problemi
    signal, sample_rate=load_a_signal(LABEL)
    #trova l'inizio e la fine
    start,stop=Find_Start_stop(signal,sample_rate)
    
    if SHOW_SIGNAL_IMPORT:
     plt.figure("Signal "+LABEL)
     plt.plot(signal)
     plt.axvline(x = start, color = 'g')
     plt.axvline(x = stop, color = 'r')
     plt.xlabel('time[s]')
     plt.show()
    if start>1000 and stop<22000  and stop-start>2000 and  len(signal) >= Num_step: #il segnale inizia dopo un po, non si ferma troppo tardi ed è di una certa lunghezza
      break
               
  #calcola spike obbiettivo 
  label_num=0
  if LABEL=="no": label_num=1
  S_obj=SPIKE_CALCULATOR.Calculate(label=label_num,start=start,stop=stop)

  #calcolo correnti in ingresso ai neuroni
  I_in= current_calculation(signal=signal,num_mfcc= Num_in_chan,fs=sample_rate,max_freq=Max_freq,Show_filtered_signal=SHOW_SIGNAL_IMPORT)
  return I_in, S_obj

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

def Find_Start_stop(signal,fs): #trova inzio e fine del segnale, usata in Preprocess dataset
    
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

    tr_value=0.01 #valore sopra il quale si considera inzio
    T_raise=100 #se rimane sopra/sotto il valore di treshold per T passi allora fissiamo l'inizio/la fine
    T_fall=1500
    start=0 
    stop=0

    filtered_signal=butter_bandpass_filter(signal, lowcut=1, highcut=8000, fs=fs, order=4)
    smoothed_filt_signal=smooth(np.abs(filtered_signal),window_len=100)
    
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
    
    if SHOW_SIGNAL_IMPORT:
     plt.figure('Smooth')
     plt.plot(smoothed_filt_signal)
     plt.axvline(x = start, color = 'g')
     plt.axvline(x = stop, color = 'r')
     plt.xlabel('time[s]')
     plt.figure('Filtered signal')
     plt.plot(filtered_signal)
     plt.xlabel('time[s]')

    return start,stop
    
def butter_bandpass_filter(data, lowcut, highcut, fs, order=5): #filtraggio del segnale, usato in Find_start_stop
    
    def butter_bandpass(lowcut, highcut, fs, order=5):
        return butter(order, [lowcut, highcut], fs=fs, btype='band')

    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y  

def New_spect_sample(LABEL,plot=False):
   index=15
   x,fs=load_a_signal(LABEL)
   f, t, Sxx = spectrogram(x, fs)
   S_log=librosa.power_to_db(Sxx)
   S_cutted=S_log[0:index,:]
   if plot:
    plt.figure(LABEL)
    plt.pcolormesh(t, f[0:index], S_cutted, shading='gouraud')
    plt.ylabel('Frequency [Hz]')
    plt.xlabel('Time [sec]')
    plt.colorbar(format="%+2.f")
    plt.show()
   return Sxx