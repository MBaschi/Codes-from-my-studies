import numpy as np
import os
from Slayer_class import Neuron_slayer

class Objective_spike_bin: #ATTENZIONE: OBJECTIVE SPIKE SOLO PER DATASET BINARIO
    type=0
    
    Num_label=2
    Num_step=87

    burst_len=[5,2] #nel caso di type=1 il vincitore emette 5 spike i perdenti 2
        
    spike_interval=[30,300] #nel caso type=2 il vincitore emette una spike ogni 2 step invece i perdenti ogni 7 step

    freq_coding=False

    alfa=Neuron_slayer.alfa 
    
    def Calculate(self,label,start,stop): 
        S_obj=np.zeros((self.Num_step,self.Num_label))
               
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
                 S_obj[start:stop,l]=ones_zero(stop-start,self.spike_interval[0])
             if l!=label:
                 S_obj[start:stop,l]=ones_zero(stop-start,self.spike_interval[1])
       
        #spike per tutta la durata del segnale sul della classe, il neurone non della classe non emette spike
        if self.type==3:
           for l in range(self.Num_label):
             if l==label:
                 S_obj[start:stop,l]=ones_zero(stop-start,self.spike_interval[1])

        #spike dal inizio del segnale fino alla fine della registrazione 
        if self.type==4:
           for l in range(self.Num_label):
             if l==label:
                 S_obj[start:,l]=ones_zero(self.Num_step-start,self.spike_interval[0])
             if l!=label:
                 S_obj[start:,l]=ones_zero(self.Num_step-start,self.spike_interval[1])


        return S_obj.T

def total_number_of_file():
 Num_file=0
 for dirpath, dirnames, filenames in os.walk(DATASET_PATH):
    if dirpath is not DATASET_PATH:
     Num_file+=len(filenames)
 return Num_file

def ones_zero(duration,periodicity):# ritorna un vettore di durata duration, sotto tutti 0 tranne ogni periodicity che ho un 1
    v=np.zeros(duration)
    for n in range(duration):
        if n%periodicity==0: v[n]=1
    return v

DATASET_PATH = "yes-no"
JSON_PATH = "dataIII.json"
SAMPLING_FREQUENCY = 22050 # 1 sec. of audio

Num_label=2
Num_step=int(SAMPLING_FREQUENCY)
Num_in_chan=13
Max_freq=10000 #Hz

SHOW_PROCESS=1
SHOW_START_STOP_ANIMATED=0

SPIKE_CALCULATOR=Objective_spike_bin()
SPIKE_CALCULATOR.Num_label=Num_label
SPIKE_CALCULATOR.Num_step=Num_step
SPIKE_CALCULATOR.type=2

Num_file=total_number_of_file()

SHOW_SIGNAL_IMPORT=0