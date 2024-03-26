
print("BEGIN_____________________________")

import matplotlib.pyplot as plt
import numpy as np
import os
import librosa
from scipy.signal import butter, lfilter,spectrogram
import json

DATASET_PATH = 'inbox-wav'
json_path="Data.json"

def Log_spect(signal,sample_rate,show=False):
    f, t, Sxx = spectrogram(signal,sample_rate,nperseg=512)
    fmin =0 # Hz
    fmax = 80000 # Hz
    freq_slice = np.where((f >= fmin) & (f <= fmax)) 
    f   = f[freq_slice]
    Sxx = Sxx[freq_slice,:][0]  
    S_log=librosa.power_to_db(Sxx)
    
    if show:
      plt.figure("Spectrogram")
      plt.pcolormesh(t, freq,S_log, shading='auto')
      plt.ylabel('Frequency [Hz]')
      plt.xlabel('Time [sec]')
      plt.colorbar(format="%+2.f")
      plt.show()    

    return  f, t,S_log

def Find_Start_stop_multiple(signal,fs,show=False): #trova inzio e fine del segnale, usata in Preprocess dataset
    
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

    tr_value_raise=0.8 #valore sopra il quale si considera inzio
    tr_value_fall=0.03
    T_raise=300 #se rimane sopra/sotto il valore di treshold per T passi allora fissiamo l'inizio/la fine
    T_fall=600
    start=0 
    stop=0

    #filtered_signal=butter_bandpass_filter(signal, lowcut=50, highcut=4000, fs=fs, order=4) #si potrebbe filtrare ma in realtà ho visto che è inutile
    smoothed_filt_signal=smooth(np.abs(signal),window_len=500)
    
    t=0
    counter=0
    start=[]
    stop=[]
    while t<signal.shape[0]:
       
        a=smoothed_filt_signal[t]
        if len(start)==len(stop):
            if smoothed_filt_signal[t]>tr_value_raise: 
                counter+=1
                if counter==T_raise: 
                     start.append(t-T_raise)
                     counter=0
            else:counter=0
    
        if len(start)>len(stop):
            if smoothed_filt_signal[t]<tr_value_fall: 
                counter+=1
                if  counter==T_fall: 
                    stop.append(t-T_fall)
                    counter=0
            else: counter=0
        
        t+=1

    if show:
     plt.figure('Start-stop :smoothing')
     plt.clf()
     plt.plot(smoothed_filt_signal)
     for i in range(len(start)):
       plt.axvline(x = start[i],color = 'g')
       plt.axvline(x = stop[i], color = 'r')
     plt.xlabel('time[s]')
     plt.show()

    return start,stop
    
data = {
        "labels": [],
        "mapping": [],
        "spect": []
    }

for dirpath, dirnames, filenames in os.walk(DATASET_PATH):   
     for f in filenames:
       file_path = os.path.join(dirpath, f)
       signal, sample_rate = librosa.load(file_path)
       freq, t,S_log=Log_spect(signal,sample_rate,show=False)
       Find_Start_stop_multiple(signal,sample_rate,show=True)


with open(json_path, "w") as fp:
         json.dump(data, fp, indent=4)      

print("END _____________________________")