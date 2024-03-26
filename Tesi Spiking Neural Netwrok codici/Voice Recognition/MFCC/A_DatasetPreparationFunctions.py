import numpy as np
from scipy.signal import butter, lfilter
from scipy.fft import fft
import matplotlib.pyplot as plt
from sklearn.preprocessing import normalize

def Find_Start_stop(signal,fs): #trova inzio e fine del segnale, usata in Preprocess dataset
    tr_value=0.008 #valore sopra il quale si considera inzio
    T=100 #se rimane sopra/sotto il valore di treshold per T passi allora fissiamo l'inizio/la fine
    start=0 
    stop=0

    filtered_signal=butter_bandpass_filter(signal, lowcut=50, highcut=1000, fs=fs, order=4)
    smoothed_filt_signal=smooth(np.abs(filtered_signal),window_len=401)
    
    count=0
    for index,val in enumerate(smoothed_filt_signal):
        if val>tr_value: count+=1
        else:count=0
        if count==T: 
            start=index
            break
    
    count=0
    for index,val in enumerate(smoothed_filt_signal):
        if index>start and val<tr_value: count+=1
        else:count=0
        if count==T: 
            stop=index
            break

    return start,stop

def smooth(x,window_len=11,window='hanning'):
    """smooth the data using a window with requested size.
    
    This method is based on the convolution of a scaled window with the signal.
    The signal is prepared by introducing reflected copies of the signal 
    (with the window size) in both ends so that transient parts are minimized
    in the begining and end part of the output signal.
    
    input:
        x: the input signal 
        window_len: the dimension of the smoothing window; should be an odd integer
        window: the type of window from 'flat', 'hanning', 'hamming', 'bartlett', 'blackman'
            flat window will produce a moving average smoothing.

    output:
        the smoothed signal
        
    example:

    t=linspace(-2,2,0.1)
    x=sin(t)+randn(len(t))*0.1
    y=smooth(x)
    
    see also: 
    
    numpy.hanning, numpy.hamming, numpy.bartlett, numpy.blackman, numpy.convolve
    scipy.signal.lfilter
 
    TODO: the window parameter could be the window itself if an array instead of a string
    NOTE: length(output) != length(input), to correct this: return y[(window_len/2-1):-(window_len/2)] instead of just y.
    """

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

def butter_bandpass_filter(data, lowcut, highcut, fs, order=5): #filtraggio del segnale, usato in Find_start_stop
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y

def butter_bandpass(lowcut, highcut, fs, order=5):
    return butter(order, [lowcut, highcut], fs=fs, btype='band')

def show_process(signal,start,stop,sample_rate,MFCCs,N,S_obj):
    
    plt.figure("0 signal")
    Time=np.linspace(0.0, N/sample_rate, N, endpoint=False)
    plt.plot(Time,signal)
    #plt.axvline(x = start, color = 'g')
    #plt.axvline(x = stop, color = 'r')
    plt.xlabel('time[s]')

    plt.figure("1 fft")
    Sf=fft(signal)
    xf=(sample_rate/N)*np.arange(0,Sf.shape[0])
    plt.plot(xf,np.abs(Sf))
    plt.xlabel('frequency[Hx]')

    plt.figure('2 Filtered signal')
    y = butter_bandpass_filter(signal, lowcut=30, highcut=1000, fs=sample_rate, order=4)
    plt.plot(Time,y)
    plt.xlabel('time[s]')

    plt.figure('3 Filtered signal fft')
    plt.plot(xf,np.abs(fft(y)))
    plt.xlabel('frequency[Hx]')

    plt.figure('4 Smooth')
    plt.plot(smooth(np.abs(y),window_len=401))
    plt.axvline(x = start, color = 'g')
    plt.axvline(x = stop, color = 'r')
    plt.xlabel('time[s]')

    plt.figure("5 MFCC")
    Num_step=MFCCs.shape[1]
    t=np.arange(start=0,stop=Num_step,step=1)/Num_step
    plt.plot(t,MFCCs.T)
    #plt.imshow(MFCCs)
    """for j in np.where(S_obj==1):
        plt.axvline(x=j,color='black', ls=':', lw=2, label="Objective Spike")"""
    #plt.vlines(x=np.where(S_obj[:,0]==1),ymin=-600, ymax=0,colors='black', ls=':', lw=2, label="Objective Spike neuron 0")
    #plt.vlines(x=np.where(S_obj[:,1]==1),ymin=0, ymax=300,colors='red', ls=':', lw=2, label="Objective Spike neuron 1")
    plt.xlabel('Time [s]')
    #plt.legend(bbox_to_anchor=(1.0, 1), loc='upper left')

    plt.show()

def Animation(signal,start,stop,pause=0.7): #fa vedere in successione i plot dei segnali mi serve per vedere se sta strovando in modo corretto gli inizi e la fine    
      plt.clf()
      plt.plot(signal)
      plt.axvline(x = start, color = 'g')
      plt.axvline(x = stop, color = 'r')
      plt.pause(pause)
        
def my_MFCC(signal,num_mfcc,fs,max_freq):
    I=np.zeros((num_mfcc,signal.shape[0]))
    filter_size=max_freq/num_mfcc
    for n in range(num_mfcc):
        I[n,:]=butter_bandpass_filter(signal, lowcut=n*filter_size+1, highcut=(n+1)*filter_size, fs=fs, order=2)
        I[n,:]=(I[n,:]-np.min(I[n,:]))/(np.max(I[n,:])-np.min(I[n,:]))
        """plt.figure(f"Signal filtered between freq {n*filter_size} and {(n+1)*filter_size}")
        plt.plot(I[n,:])   
        plt.show()"""
    return I[n,:]

def ones_zero(duration,periodicity):# ritorna un vettore di durata duration, sotto tutti 0 tranne ogni periodicity che ho un 1
    v=np.zeros(duration)
    for n in range(duration):
        if n%periodicity==0: v[n]=1
    return v

class Objective_spike_bin: #ATTENZIONE: OBJECTIVE SPIKE SOLO PER DATASET BINARIO
    type=0

    Num_label=2
    Num_step=87

    burst_len=[5,2] #nel caso di type=1 il vincitore emette 5 spike i perdenti 2   
    spike_interval=[2,5] #nel caso type=2 il vincitore emette una spike ogni 2 step invece i perdenti ogni 7 step
    
    frequency_coding=False
    winner_freq=0.7
    loser_freq=0.2
    baseline_freq=0.1

    def Calculate(self,label,start,stop): 
        S_obj=np.zeros((self.Num_step,self.Num_label))

        if self.frequency_coding:
            S_obj_winner=np.zeros(self.Num_step)
            S_obj_loser=np.zeros(self.Num_step)
            for n in range(self.Num_step):
               S_obj_winner[n]
            for l in range(self.Num_label):
             if l==label:
                 S_obj[start:stop,l]=self.winner_freq*np.ones(stop-start)
             if l!=label:
                 S_obj[stop:stop,l]=self.loser_freq*np.ones(stop-start)

        if not self.frequency_coding:
         #ho una sola spike alla fine del segnale obbiettivo
         if self.type==0: 
           S_obj[stop,label]=1
         
         #ho burst di spike alla fine del segnale
         if self.type==1:
           for l in range(self.Num_label):
             if l==label:
                 S_obj[stop-self.burst_len[0]:stop,l]=np.ones(self.burst_len[0])
             if l!=label:
                 S_obj[stop-self.burst_len[1]:stop,l]=np.ones(self.burst_len[1])
         
         #spike per tutta la durata del segnale, la classe vincente ha una frequenza di spike maggiore
         if self.type==2:
            for l in range(self.Num_label):
              if l==label:
                  S_obj[start:stop,l]=ones_zero(stop-start,int(self.spike_interval[0]))
              if l!=label:
                  S_obj[start:stop,l]=ones_zero(stop-start,int(self.spike_interval[1]))
        
         #spike per tutta la durata del segnale sul della classe, il neurone non della classe non emette spike
         if self.type==3:
            for l in range(self.Num_label):
              if l==label:
                  S_obj[start:stop,l]=ones_zero(stop-start,int(self.spike_interval[1]))
 
         #spike dal inizio del segnale fino alla fine della registrazione 
         if self.type==4:
            for l in range(self.Num_label):
              if l==label:
                  S_obj[start:,l]=ones_zero(self.Num_step-start,int(self.spike_interval[0]))
              if l!=label:
                  S_obj[start:,l]=ones_zero(self.Num_step-start,int(self.spike_interval[1]))
 
         return S_obj.T        