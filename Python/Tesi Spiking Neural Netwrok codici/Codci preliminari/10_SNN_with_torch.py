#LIBRERIE
import os

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import seaborn as sns

import torch
import torch.nn as nn

dtype = torch.float
device = torch.device("cpu")

nb_inputs  = 4
nb_hidden  = 4
nb_outputs = 2

time_step = 1e-3
nb_steps  = 200

batch_size = 1

freq = 5 # Hz
prob = freq*time_step
mask = torch.rand((batch_size,nb_steps,nb_inputs), device=device, dtype=torch.float32)

x_data = torch.zeros((batch_size,nb_steps,nb_inputs), device=device, dtype=torch.float32, requires_grad=False)
x_data[mask<prob] = 1.0
print(x_data[0])
data_id = 0
plt.figure(1)
plt.imshow(x_data[data_id].cpu().t(), cmap=plt.cm.gray_r, aspect="auto")
plt.xlabel("Time (ms)")
plt.ylabel("Unit")

y_data = torch.tensor(1*(np.random.rand(batch_size)<0.5), device=device, dtype=torch.float32)

#Setup of the spiking network model

tau_mem = 10e-3
tau_syn = 5e-3

alpha   = float(np.exp(-time_step/tau_syn))
beta    = float(np.exp(-time_step/tau_mem))

weight_scale = 7*(1.0-beta) # this should give us some spikes to begin with

w1 = torch.empty((nb_inputs, nb_hidden),  device=device, dtype=torch.float32, requires_grad=True)
torch.nn.init.normal_(w1, mean=0.0, std=weight_scale/np.sqrt(nb_inputs))


w2 = torch.empty((nb_hidden, nb_outputs), device=device, dtype=torch.float32, requires_grad=True)
torch.nn.init.normal_(w2, mean=0.0, std=weight_scale/np.sqrt(nb_hidden))
print(w2)

def plot_voltage_traces(mem, spk=None, dim=(3,5), spike_height=5):
    gs=GridSpec(*dim)
    if spk is not None:
        dat = 1.0*mem
        dat[spk>0.0] = spike_height
        dat = dat.detach().cpu().numpy()
    else:
        dat = mem.detach().cpu().numpy()
    for i in range(np.prod(dim)):
        if i==0: a0=ax=plt.subplot(gs[i])
        else: ax=plt.subplot(gs[i],sharey=a0)
        ax.plot(dat[i])
        ax.axis("on")

def run_layer(inputs_spike,l_dim,w):
    h = torch.einsum("abc,cd->abd", (inputs_spike, w))
    In_current = torch.zeros((batch_size,l_dim), device=device, dtype=dtype)
    mem = torch.zeros((batch_size,l_dim), device=device, dtype=dtype)

    mem_rec = []
    spk_rec = []

    treshold=1
    
    for t in range(nb_steps):
        spike = torch.zeros_like(mem)
        spike[mem-treshold > 0] = 1
        rst = spike.detach() # We do not want to backprop through the reset

        new_In_current = alpha*In_current +h[:,t]
        new_mem = (beta*mem +In_current)*(1.0-rst)

        mem_rec.append(mem)
        spk_rec.append(spike)
        
        mem = new_mem
        In_current = new_In_current

    mem_rec = torch.stack(mem_rec,dim=1)
    spk_rec = torch.stack(spk_rec,dim=1)

    return mem_rec,spk_rec

def run_snn(inputs):

    mem_rec_h,spk_rec_h=run_layer(inputs,nb_hidden,w1)
    mem_rec_o,spk_rec_o=run_layer(spk_rec_h,nb_outputs,w2)
    
    hidden_rec=[mem_rec_h,spk_rec_h]
    out_rec=[mem_rec_o,spk_rec_o]

    return hidden_rec, out_rec

hidden_rec, out_rec = run_snn(x_data)
#fig=plt.figure(dpi=100)
plt.figure(2)
plot_voltage_traces(hidden_rec[0],hidden_rec[1],dim=(1,1))
plt.figure(3)
plot_voltage_traces(out_rec[0],out_rec[1],dim=(1,1))
plt.show()
print("init done")
