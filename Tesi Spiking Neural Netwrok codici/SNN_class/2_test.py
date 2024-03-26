from basic_class import LIF_neuron, LIF_layer, Network
import numpy as np
import matplotlib.pyplot as plt

print("inizio")


tau=50
step=1000
LIF_neuron.alfa=1/tau
LIF_neuron.T_refactory=10
LIF_neuron.treshold=0.2
LIF_neuron.RestingPotential=0
if 1: #test LIF_neuron
  
  neurone_gigio=LIF_neuron(saveU=1,saveS=1)
  I_in=np.zeros(step)
  I_in[10]=1
  I_in=1*np.ones(step)
  

  for n in range(step):
      neurone_gigio.update(I_in=I_in[n])
    
  
  neurone_gigio.show()
  plt.show()

if 0: #test LIF_layer
  layer_dim=5
  LIF_neuron.treshold=layer_dim
  layer_pippo=LIF_layer(layer_dim,saveS=1, saveU=1)

  I_in=np.zeros((layer_dim,step))
  for i in range(layer_dim-1):
    I_in[i,:]=i*np.ones(step)

  I_in[4,5]=1

  for n in range(step):
      layer_pippo.update(I_in[:,n])
      print(layer_pippo.neur)
     
  layer_pippo.show()
  plt.show()

if 0: #test network
  dim_in=5
  dim_hid=5
  dim_out=3
  network_banana=Network(dim_in,dim_hid,dim_out,saveU=1,saveS=1)
  Num_step=100

  I_in=np.zeros((dim_in,step))
  """for i in range(dim_in):
    I_in[i,:]=i*np.ones(step)"""
  I_in[2,5]=1.5

  network_banana.run(num_step=Num_step,I_in=I_in)
  network_banana.show()
  plt.show()
print("fine")