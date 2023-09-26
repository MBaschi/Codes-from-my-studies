import numpy as np
from scipy import signal
from scipy.fft import fftshift
import matplotlib.pyplot as plt
from F_functions import load_a_signal
import librosa

x,fs=load_a_signal(LABEL="yes")

if 0: #LIBROSA
 #devo vedere come fare lo spettrogramma dei segnali
 def plot_spectrogram_librosa(Y, sr, hop_length, y_axis="linear"):
       
       librosa.display.specshow(Y, 
                                sr=sr, 
                                hop_length=hop_length, 
                                x_axis="time", 
                                y_axis=y_axis)
       plt.colorbar(format="%+2.f")
 
 FRAME_SIZE=2**10
 HOP_SIZE=2**8
 S_scale=librosa.stft(x, n_fft=FRAME_SIZE, hop_length=HOP_SIZE)
 Y_scale = np.abs(S_scale) ** 2
 Y_log_scale = librosa.power_to_db(Y_scale)
 plt.figure("yes",figsize=(12, 5))
 plot_spectrogram_librosa(Y_log_scale, fs, HOP_SIZE)
 
 if 0: #per testare cosa cambia cambiano l'hop length e  il frame size
   for i in range(6):
     S_scale=librosa.stft(x, n_fft=FRAME_SIZE, hop_length=HOP_SIZE)
     Y_scale = np.abs(S_scale) ** 2
     Y_log_scale = librosa.power_to_db(Y_scale)
     plt.figure("yes",figsize=(12, 5))
     plot_spectrogram_librosa(Y_log_scale, fs, HOP_SIZE, y_axis="log")
     plt.show()
     FRAME_SIZE=FRAME_SIZE*2

def plot_spectrogram(t, f, Sxx):
    plt.pcolormesh(t, f, Sxx, shading='gouraud')
    plt.ylabel('Frequency [Hz]')
    plt.xlabel('Time [sec]')
    plt.colorbar(format="%+2.f")
    #plt.yscale('symlog') #per plottare le frequenze in scala logaritimica ma è meglio lineare
   
if 1: #SCIPY-> mi piace di più
   f, t, Sxx = signal.spectrogram(x, fs,)
   if 0: #spetrogramma non in scala logaritimica
    plot_spectrogram(t, f, Sxx)
    plt.show()
   Sxx=librosa.power_to_db(Sxx)
   print(f.shape, t.shape,Sxx.shape)
   plt.figure(2)
   plot_spectrogram(t, f, Sxx)
   plt.show()
   
#siccome l voce umana va dai 60 ai 300 hz prendiamo solo quella parte di spettro
f, t, Sxx = signal.spectrogram(x, fs)
index=15
print(f[index])
S_log=librosa.power_to_db(Sxx)
S_Human_voice=S_log[0:index,:]
plot_spectrogram(t, f[0:index], S_Human_voice)
plt.show()

if 1:
   for j in range(10):
      for a in ["yes","no"]:
       x,fs=load_a_signal(LABEL=a)
       f, t, Sxx = signal.spectrogram(x, fs,nperseg=256) #nperseg=128-> risoluzione in frequenza troppo bassa, nperseg=256 ->ancora bassa ma meglio, nperseg=512 -> bassa risoluzione temporaòle
       
       S_log=librosa.power_to_db(Sxx)
       S_Human_voice=S_log[0:index,:]
       print(f.shape, t.shape,Sxx.shape)
       plt.figure(a+" "+str(j))
       plot_spectrogram(t, f[0:index], S_Human_voice)
   plt.show()