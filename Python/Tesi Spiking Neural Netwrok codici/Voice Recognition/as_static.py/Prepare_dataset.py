import librosa
import os
import json
import matplotlib.pyplot as plt
import numpy as np
import sys

DATASET_PATH = "D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\Voice recognition\Dataset"
LABEL=["bed","five","go","seven"] #ATTENZIONE SCRIVILI NEL ORDINE ALFABETICO
JSON_PATH="D:\Matteo Baschieri\OneDrive - Politecnico di Milano\Tesi\Voice recognition\JSON"
SAMPLING_FREQUENCY = 22050 # 1 sec. of audio
hop_length=512

Num_label=len(LABEL)
Num_step=int(SAMPLING_FREQUENCY/hop_length)
Num_mfcc=13

Num_file=0
for l in LABEL:
  Num_file+=len([name for name in os.listdir(DATASET_PATH+"\\"+l)])

def progressBar(count_value, total, suffix=''):
    bar_length = 100
    filled_up_Length = int(round(bar_length* count_value / float(total)))
    percentage = round(100.0 * count_value/float(total),1)
    bar = '=' * filled_up_Length + '-' * (bar_length - filled_up_Length)
    sys.stdout.write('[%s] %s%s ...%s\r' %(bar, percentage, '%', suffix))
    sys.stdout.flush()

def preprocess_dataset(dataset_path, json_path, num_mfcc=Num_mfcc, n_fft=2048, hop_length=hop_length): #funzione principale
    """Extracts MFCCs from music dataset and saves them into a json file.
    :param dataset_path (str): Path to dataset
    :param json_path (str): Path to json file used to save MFCCs
    :param num_mfcc (int): Number of coefficients to extract
    :param n_fft (int): Interval we consider to apply FFT. Measured in # of samples
    :param hop_length (int): Sliding window for FFT. Measured in # of samples
    :return:
    """
    progress=0
    saved_file=0
    removed_file=0
    # dictionary where we'll store mapping, labels, MFCCs and filenames
    data = {
        "mapping": [],
        "labels": [],
        "MFCCs": [],
        "files": []
    }
    l=0

    # loop through all sub-dirs
    for i, (dirpath, dirnames, filenames) in enumerate(os.walk(dataset_path)):

        # ensure we're at sub-folder level
        if dirpath is not dataset_path:

            # save label (i.e., sub-folder name) in the mapping
            label = dirpath.split("\\")[-1]
            if label==LABEL[l]:
                
                data["mapping"].append(label)
                print("\nProcessing: '{}'".format(label))
    
                # process all audio files in sub-dir and store MFCCs
                for f in filenames:
                    file_path = os.path.join(dirpath, f)
    
                    # load audio file and slice it to ensure length consistency among different files
                    signal, sample_rate = librosa.load(file_path)
    
                    # drop audio files with less than pre-decided number of samples
                    if len(signal) >= SAMPLING_FREQUENCY:
    
                        # ensure consistency of the length of the signal
                        signal = signal[:SAMPLING_FREQUENCY]
                     
                        # extract MFCCs
                        MFCCs = librosa.feature.mfcc(y=signal,sr=sample_rate, n_mfcc=num_mfcc, n_fft=n_fft,
                                                     hop_length=hop_length)
        
                   
                        # store data for analysed track
                        data["MFCCs"].append(MFCCs.T.tolist())
                        data["labels"].append(l)
                        data["files"].append(file_path)
        
                        #print("{}: {}".format(file_path, i-1))
                    progressBar(progress,Num_file)
                    progress+=1
                if l<Num_label-1:l+=1         

    with open(json_path, "w") as fp:
           json.dump(data, fp, indent=4)
  
if __name__ == "__main__":
    preprocess_dataset(DATASET_PATH, JSON_PATH)

    print("FINE")