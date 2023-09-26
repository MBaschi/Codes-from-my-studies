#LIBRERIE
import os

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import seaborn as sns

import torch
import torch.nn as nn

from matplotlib.animation import FuncAnimation

dtype = torch.float
device = torch.device("cpu")

nb_inputs  = 4
nb_hidden  = 4
nb_outputs = 2

time_step = 1e-3
nb_steps  = 200

batch_size = 3

freq = 5 # Hz
prob = freq*time_step
mask = torch.rand((batch_size,nb_steps,nb_inputs), device=device, dtype=torch.float32)
x_data = torch.zeros((batch_size,nb_steps,nb_inputs), device=device, dtype=torch.float32, requires_grad=False)
x_data[mask<prob] = 1.0

y_data = torch.tensor(1*(np.random.rand(batch_size)<0.5), device=device, dtype=torch.long)

data_id = 0
plt.figure(1)
plt.imshow(x_data[data_id].cpu().t(), cmap=plt.cm.gray_r, aspect="auto")
plt.xlabel("Time (ms)")
plt.ylabel("Unit")

mask = torch.rand((batch_size,nb_steps,nb_outputs), device=device, dtype=torch.float32)
targets = torch.zeros((batch_size,nb_steps,nb_outputs), device=device, dtype=torch.float32, requires_grad=False)
targets[mask<prob] = 1.0

plt.figure(2)
plt.imshow(targets[data_id].cpu().t(), cmap=plt.cm.gray_r, aspect="auto")
plt.xlabel("Time (ms)")
plt.ylabel("Unit")

#plt.show()
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

class SurrGradSpike(torch.autograd.Function):
    """
    Here we implement our spiking nonlinearity which also implements 
    the surrogate gradient. By subclassing torch.autograd.Function, 
    we will be able to use all of PyTorch's autograd functionality.
    Here we use the normalized negative part of a fast sigmoid 
    as this was done in Zenke & Ganguli (2018).
    """
    
    scale = 100.0 # controls steepness of surrogate gradient

    @staticmethod
    def forward(ctx, input):
        """
        In the forward pass we compute a step function of the input Tensor
        and return it. ctx is a context object that we use to stash information which 
        we need to later backpropagate our error signals. To achieve this we use the 
        ctx.save_for_backward method.
        """
        ctx.save_for_backward(input)
        out = torch.zeros_like(input)
        out[input > 0] = 1.0
        return out

    @staticmethod
    def backward(ctx, grad_output):
        """
        In the backward pass we receive a Tensor we need to compute the 
        surrogate gradient of the loss with respect to the input. 
        Here we use the normalized negative part of a fast sigmoid 
        as this was done in Zenke & Ganguli (2018).
        """
        input, = ctx.saved_tensors
        grad_input = grad_output.clone()
        grad = grad_input/(SurrGradSpike.scale*torch.abs(input)+1.0)**2
        return grad
    
# here we overwrite our naive spike function by the "SurrGradSpike" nonlinearity which implements a surrogate gradient
spike_fn  = SurrGradSpike.apply

params = [w1,w2]
optimizer = torch.optim.Adam(params, lr=2e-3, betas=(0.9,0.999))

log_softmax_fn = nn.LogSoftmax(dim=1)
loss = nn.MSELoss()

loss_hist = []
for e in range(10):
    print(e)
    hidden_rec, out_rec = run_snn(x_data)
   

    
    loss_val = torch.zeros((1), dtype=torch.float, device=device)
    loss_val += loss(out_rec[1], targets)


    optimizer.zero_grad()
    loss_val.backward()
    optimizer.step()
    loss_hist.append(loss_val.item())

plt.figure(figsize=(3.3,2),dpi=150)

fig, ax = plt.subplots()

def animate(mem):
  
    ax.clear()
    ax.plot(mem)
    ax.set_xlim([0,20])
    ax.set_ylim([0,10])

plt.plot(loss_hist, label="Surrogate gradient")
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.legend()
plt.show()

print("fine")


