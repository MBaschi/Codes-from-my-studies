from scipy.stats import bernoulli
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable


def spike_calculator(I,extension,spike_higth):
   v=np.ones(extension)
   S=np.zeros((I.shape[0],extension*I.shape[1]))
   for t in range(I.shape[1]):
      for j in range(I.shape[0]):      
         S[j,t*extension:(t+1)*extension]=spike_higth*bernoulli.rvs(I[j,t], size=extension)
   return S

def plot_I_in(I_in): #I_in[neur,time]
  Lines=[]
  fig, ax = plt.subplots()
  ax.set_title('Input Current')
  for i in range(I_in.shape[0]):
     line,=ax.plot(I_in[i,:],label=f'Neuron {i+1}')
     Lines.append(line)
  leg = ax.legend(loc='upper left', fancybox=True)
  leg.get_frame().set_alpha(0.4)
 
  # we will set up a dict mapping legend line to orig line, and enable
  # picking on the legend line
  lined = dict()
  for legline, origline in zip(leg.get_lines(), Lines):
      legline.set_picker(5)  # 5 pts tolerance
      lined[legline] = origline
  
  
  def onpick(event):
      # on the pick event, find the orig line corresponding to the
      # legend proxy line, and toggle the visibility
      legline = event.artist
      origline = lined[legline]
      vis = not origline.get_visible()
      origline.set_visible(vis)
      # Change the alpha on the line in the legend so we can see what lines
      # have been toggled
      if vis:
          legline.set_alpha(1.0)
      else:
          legline.set_alpha(0.2)
      fig.canvas.draw()
 
  fig.canvas.mpl_connect('pick_event', onpick)
  
  fig.canvas.manager.set_window_title('Segnali in ingresso')

def plot_network(Network,obj):
   N_of_layer=Network.num_layer

   if Network.saveS==True:Network.show(S_obj=obj)
   if Network.saveU==True: Network.Algorithm_var_plot()
        
   for l in range(Network.num_layer-2,-1,-1):  
    grad_w=np.matmul(Network.sigma[l+1],Network.P_record[l].transpose()) 
    plt.figure(f"Synaptic grad of layer {l}").set_figheight(2)
  
    ax = plt.gca()
    im = ax.imshow(grad_w)
    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    plt.colorbar(im, cax=cax)
   interactive=False
   start_blank=True
   Network.synapse[N_of_layer-2].show(layer_number=N_of_layer-2,interactive= interactive,start_blank=start_blank)
   Network.synapse[N_of_layer-3].show(layer_number=N_of_layer-3,interactive= interactive,start_blank=start_blank)
   Network.synapse[N_of_layer-4].show(layer_number=N_of_layer-4,interactive= interactive,start_blank=start_blank)
