import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as m_patches
from scipy.signal import convolve2d

from mpl_toolkits.axes_grid1 import make_axes_locatable

class LIF_neuron: #neurone leaky integrate and fire
    treshold=1
    alfa=0.9 #alfa=dt/tau
    T_refactory=0
    RestingPotential=0
    def __init__(self,saveU=0,saveS=0): 
        self.U=0 #potenziale di membrana
        self.nextU=0
        self.refct_counter=0
        self.resting_state=False

        self.saveU=saveU
        self.saveS=saveS
        if saveU: #richiesta di salvare i valori del potenzaile (da default falso)       
         self.U_record=[] 
        if saveS: #richiesta di salvare i valori delle spike (da default falso)
         self.S_record=[]
        
    def update(self,I_in): #simula il neurone dal tempo t al t+1 (questa funzione dovrà essere inserita in un for)
        spike=0
        self.U=self.nextU

        if self.resting_state==False:
          self.U+=(-self.U+I_in)*self.alfa
  
          self.nextU=self.U
          if self.U>=self.treshold:
              spike=1
              self.nextU=self.RestingPotential
              self.resting_state=True
        
        if self.resting_state==True:
           self.refct_counter+=1
           if self.refct_counter>=self.T_refactory:
              self.refct_counter=0
              self.resting_state=False
        
        if 1: #salvataggio
          if self.saveU:
              self.U_record.append(self.U)
          if self.saveS:
              self.S_record.append(spike)

        return spike

    def reset(self):
        self.U=0
        if self.saveU:
              self.U_record=[]
        if self.saveS:
              self.S_record=[]
    
    def show(self): #plotta il potenziale o le spike a seconda se sono state richieste o no
        if self.saveU==0 and self.saveS==0:
            print("plot non non abilitato")
        
        if self.saveU==1 and self.saveS==1:
         step=np.size(np.array(self.U_record))
         x=range(step)
         plt.plot(x,self.U_record,x,self.treshold*np.ones(step),'r--',x,1.1*self.treshold*np.array(self.S_record),'o')
        
        if self.saveU==0 and self.saveS==1:
         step=np.size(np.array(self.S_record))
         plt.plot(self.S_record,'o')
        
        if self.saveU==1 and self.saveS==0:
         step=np.size(np.array(self.U_record))
         x=range(step)
         plt.plot(x,self.U_record,x,self.treshold*np.ones(step),'r--')

        plt.xlabel("Time step")
      
class LIF_layer: #layer con "dim" neuroni 

    def __init__(self,dim,saveU=0,saveS=0):
        self.dim=dim 
        self.neur=[]
        for i in range(dim):
            self.neur.append(LIF_neuron(saveU,saveS))
        
        self.saveS=saveS
        self.saveU=saveU
    
    def update(self,I): #ricevo in ingresso il vettore I[i] che è la corrente in ingresso al neurone i 
        spike=np.zeros(self.dim)
        for i in range(self.dim):
            spike[i]=self.neur[i].update(I[i])  
        return spike #ritorno il vettore dei neuroni che hanno avuto una spike
    
    def activity(self): #ritorna il vettore attivita del layer
       v=np.zeros(self.dim)
       for i in range(self.dim):
          v[i]=self.neur[i].a
       return v
       
    def reset(self):
        for i in range(self.dim):
            self.neur[i].reset()
    
    def show(self,figure_number=0,layer_number=0):
        if self.saveS==0 and self.saveU==0: #non plottare nulla
            print("impossibile plottare perchè non è stato richiesto il salvataggio")

        if self.saveS==1 and self.saveU==0:# plot solo spike
            x=np.arange(0,len(self.neur[0].S_record),1)
            for i in range(self.dim):
             S=[(i+1)*j for j in self.neur[i].S_record]
             plt.plot(x,S,'k.',markersize=3)
            plt.suptitle(f"Spike of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron Number")
            plt.ylim((0.5,self.dim+0.5))
          
        if self.saveS==0 and self.saveU==1:# plot solo potenziali
            x=np.arange(0,len(self.neur[0].U_record),1)
            v=np.ones(len(self.neur[0].U_record))
            for i in range(self.dim):
              plt.plot(x,self.neur[i].U_record+2*i*self.neur[i].treshold*v)
            plt.suptitle(f"Membrane potential of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            plt.yticks([])
            
        if self.saveS==1 and self.saveU==1:#plot spike e potenziali
            plt.figure(figure_number)
            x=np.arange(0,len(self.neur[0].S_record),1)
            for i in range(self.dim):
             S=[(i+1)*j for j in self.neur[i].S_record]
             plt.plot(x,S,'k.',markersize=3)
            plt.suptitle(f"Spike of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron Number")
            plt.ylim((0.5,self.dim+0.5))
            
            
            plt.figure(figure_number+1)
            x=np.arange(0,len(self.neur[0].U_record),1)
            v=np.ones(len(self.neur[0].U_record))
            for i in range(self.dim):
              plt.plot(x,self.neur[i].U_record+4*i*self.neur[i].treshold*v)
              plt.plot(x,self.neur[i].treshold*v+4*i*self.neur[i].treshold*v,'r--')
            plt.suptitle(f"Membrane potential of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            plt.yticks([])
                              
class synapse: #insieme delle sinapsi che collegano il layer l-1 di idmensione dim_pre al layer l di imensione dim_post
    only_positive=False

    def __init__(self,dim_pre, dim_post,mean,var):
        self.dim_pre=dim_pre 
        self.dim_post=dim_post 
        if self.only_positive:   self.W=np.abs(np.random.normal(loc=mean,scale=var,size=(dim_post,dim_pre))) #pesi sinaptici
        if not self.only_positive:       self.W=(np.random.normal(loc=mean,scale=var,size=(dim_post,dim_pre)))
        
    def update(self, spike_in): #ottengo il vettore di spike[dim_pre] provenienti dal layer precedente
        I=np.dot(self.W,spike_in)
        return I #calcolo la corrente in uscita, vettore di dimensione dim_post

def Box_car(U,min,max): #funzione gradiente surrogato box car
   if min<U<max: return 1
   else: return 0

def bell_shape(U,alfa,beta,treshold): #funzione gradiente surrogato

   return alfa*np.exp(-beta*np.abs(U-treshold))
        
class Neuron_slayer (LIF_neuron): #il neurone del network decolle è un neurone LIF normale ma bisogna tener conto della sua attività P e del gradiente surrogato del suo potenziale per poter fare learning
    beta=8

    def __init__(self,saveU=0,saveS=0):
        super().__init__(saveU,saveS)
        self.P=0
        self.grad_record=[]
        self.P_record=[]

    def update_neur(self,I_in):
        spike=self.update(I_in)
        self.P+=(-self.P+spike)*self.alfa
        #self.grad=Box_car(self.U,nin=0.5,max=1.5) 
        self.grad=bell_shape(self.U,alfa=1,beta=self.beta,treshold=self.treshold)

        self.grad_record.append(self.grad)
        self.P_record.append(self.P)

        return spike

    def reset_neur(self):
        self.U=0
        if self.saveU:
              self.U_record=[]
        if self.saveS:
              self.S_record=[]
        
        self.P=0
        self.grad_record=[]
        self.P_record=[]
    
    def show(self): #plotta il potenziale o le spike a seconda se sono state richieste o no
        if self.saveU==0 and self.saveS==0:
            print("plot non non abilitato")
        
        if self.saveU==1 and self.saveS==1:
         step=np.size(np.array(self.U_record))
         x=range(step)
         plt.plot(x,self.U_record,x,self.treshold*np.ones(step),'r--',x,1.1*self.treshold*np.array(self.S_record),'o')
        
        if self.saveU==0 and self.saveS==1:
         step=np.size(np.array(self.S_record))
         plt.plot(self.S_record,'o')
        
        if self.saveU==1 and self.saveS==0:
         step=np.size(np.array(self.U_record))
         x=range(step)
         plt.plot(x,self.U_record,x,self.treshold*np.ones(step),'r--')

        plt.xlabel("Time step")
        
class Layer_slayer(): #il layer decolle è fatto di neuroni decolle quindi terrà conto delle variabili aggiunte nel neurone decolle
    plot_type=0

    def __init__(self,dim,saveU=0,saveS=0):
        self.dim=dim 
        self.saveS=saveS
        self.saveU=saveU
        self.neur=[]
        for i in range(dim):
            self.neur.append(Neuron_slayer(saveU,saveS))
        self.surr_grad=np.zeros(dim)
        self.P=np.zeros(dim)
    
    def update_layer(self,I): 
        spike=np.zeros(self.dim)
        for i in range(self.dim):
            spike[i]=self.neur[i].update_neur(I[i])
            self.surr_grad[i]=self.neur[i].grad
            self.P[i]=self.neur[i].P
        return spike #ritorno il vettore dei neuroni che hanno avuto una spike
    
    def run(self,Num_step,I):
       for t in range(Num_step):
          self.update_layer([I[:,t]])

    def activity(self): #ritorna il vettore attivita del layer
       v=np.zeros(self.dim)
       for i in range(self.dim):
          v[i]=self.neur[i].a
       return v
       
    def reset_layer(self):
        self.P=np.zeros(self.dim)
        self.surr_grad=np.zeros(self.dim)
        for i in range(self.dim):
            self.neur[i].reset_neur()
    
    def change_beta(self,beta_val):
       for i in range(self.dim):
            self.neur[i].beta=beta_val
       
    def show(self,S_obj='a',layer_number=0,int=0):
        if self.saveS==0 and self.saveU==0: #non plottare nulla
            print("impossibile plottare perchè non è stato richiesto il salvataggio")
        
        if self.saveS:# plot solo spike
            if int==1:plt.figure(f"Spike of internal layer {layer_number}")
            else:plt.figure(f"Spike of layer {layer_number}")
          
            x=np.arange(0,len(self.neur[0].S_record),1)

            if self.plot_type==0:
             for i in range(self.dim):
              S=np.array([(i+1)*j for j in self.neur[i].S_record])
              plt.plot(x,S,'k.',markersize=3,label=f'{i+1}:{np.count_nonzero(S==(i+1))}')
              
              if not isinstance(S_obj, str):
                 S=[(i+1.1)*j for j in S_obj[i]]
                 plt.plot(x,S,'r.',markersize=3)
              plt.ylim((0.5,self.dim+0.5))
              plt.legend(bbox_to_anchor=(1.0, 1), loc='upper left',title='Spike count')

            else:
              S=[]
              for i in range(self.dim):
                 #S.append(np.array([(i+1)*j for j in self.neur[i].S_record]))
                 S.append(self.neur[i].S_record)
              plt.imshow(S, aspect="auto")
              
            plt.suptitle(f"Spike of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron Number")
           
          
        if self.saveU:# plot solo potenziali
            if int==1:plt.figure(f"Membrane potential of internal layer {layer_number}")
            else:plt.figure(f"Membrane potential of layer {layer_number}")
            
            x=np.arange(0,len(self.neur[0].U_record),1)
            v=np.ones(len(self.neur[0].U_record))
            for i in range(self.dim):
              plt.plot(x,self.neur[i].U_record+4*i*self.neur[i].treshold*v)
              plt.plot(x,self.neur[i].treshold*v+4*i*self.neur[i].treshold*v,'r--')
            plt.suptitle(f"Membrane potential of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            plt.yticks([])
            
    def Algorithm_var_plot(self,layer_number=0): 
        #plot gradiente surrogato
        if 0:
          plt.figure(f"Surrogate gradient of layer {layer_number}") 
          for i in range(self.dim):
           plt.plot(self.neur[i].grad_record)
          plt.xlabel("Time step")

        #plot traccia neuroni precednti
        plt.figure(f"P of layer {layer_number}")
        x=np.arange(0,len(self.neur[0].P_record),1)
        v=np.ones(len(self.neur[0].P_record))
        for i in range(self.dim):
         plt.plot(self.neur[i].P_record)
        plt.suptitle(f"P of layer {layer_number}")      
        plt.xlabel("Time step")
        plt.ylabel("Neuron ")

class Synapse_slayer(synapse): #la sinapsi in Decolle è identica a una sinapsi normale ma può essere aggiornata utilizzando l'errore del layer sucessivo e alcune informazioni salvate nel layer precedente e quello successivo
   lr=1e-4
   only_positive=False #i pesi siaptici rimangno solo positivi
   confine_val=True #se questa variabile è vera allora la sinapsi può avere solo valore compreso tra max_val e min_val
   max_val=1
   min_val=0

   def __init__(self,dim_pre, dim_post,mean,var,save): 
      super().__init__(dim_pre, dim_post,mean,var)
      self.save=save
      if save:
           self.W_record=[]
           for i in range(self.dim_post):
              self.W_record.append([])
              for j in range(self.dim_pre):
                 self.W_record[i].append([])

   def update_val(self,grad):
      self.W+=self.lr*grad
      
      #if self.only_positive: self.W[self.W<0]=self.min_val
      if self.confine_val:
             self.W[self.W<self.min_val]=self.min_val
             self.W[self.W>self.max_val]=self.max_val
     
      for i in range(self.dim_post):
         for j in range(self.dim_pre):
            if self.save: self.W_record[i][j].append(self.W[i,j])

   def reset(self):
      if self.save:
           self.W_record=[]
           for i in range(self.dim_post):
              self.W_record.append([])
              for j in range(self.dim_pre):
                 self.W_record[i].append([])    

   def show(self,layer_number=0,interactive=False,start_blank=False):
      if not self.save:
         print("Richiesta di stampare i pesi sinaptici senza aver slavato i valori, porre save=1")
      if self.save:
        if interactive:
           Lines=[]
           fig, ax = plt.subplots()
           ax.set_title(f"Synaptic weight of layer {layer_number}")
  
           patches = list()
           patches_column1 = [m_patches.Patch(color="w", label=f'')]
           for j in range(self.dim_pre):
            patches_column1.append(m_patches.Patch(color='none', label=f'{j+1}'))
  
           patches.extend(patches_column1)
  
           for i in range(self.dim_post):
              patches_columni = [m_patches.Patch(color="none", label=f'{i+1}')]
              for j in range(self.dim_pre):
  
                line,=ax.plot(self.W_record[i][j],label=".") #f'[{i+1}],[{j+1}]'
                Lines.append(line)
                patches_columni.append(line)
             
              patches.extend(patches_columni)
           
           leg =ax.legend(loc='upper left',
                ncol=self.dim_post+1,bbox_to_anchor=(1.0, 0.0, 1, 1), handles=patches,fancybox=True,numpoints=1)
           #leg = ax.legend(loc='upper left', fancybox=True)
           leg.get_frame().set_alpha(0.4)
           
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
           fig.canvas.manager.set_window_title(f"Synaptic weight of layer {layer_number}")

           if start_blank:
             for l in Lines:
              l.set_visible(False)
  
        if not interactive:
           plt.figure(f"Synaptic weight of layer {layer_number}")
           plt.suptitle(f"Synaptic weight of layer {layer_number}")
           plt.xlabel("run number")
           plt.ylabel("Synaptic weight")
  
           for i in range(self.dim_post):
              for j in range(self.dim_pre):
                plt.plot(self.W_record[i][j])
    
   def plot_val(self,layer_number=0):
         fig=plt.figure(f"Synaptic weight of layer {layer_number}")
         plt.suptitle(f"Synaptic weight of layer {layer_number}")
         im=plt.imshow(self.W)
         fig.colorbar(im)
                
class Network_slayer: 

     training_mode=False   
     Freq_coding=True
     spike_conv_mode=False
     statitc_dataset=True

     def __init__(self,dim,saveU=0,saveS=0,saveW=0,meanW=LIF_neuron.treshold,varW=LIF_neuron.treshold):
        #parametri network
        self.dim=[]
        for i in dim:
          self.dim.append(i)
        
        self.output_dim=self.dim[len(self.dim)-1]
        self.num_layer=len(self.dim)
        self.meanW=meanW
        self.varW=varW
        #self.num_epoch=1
        
        #salvataggio
        self.saveS=saveS
        self.saveU=saveU
        self.saveW=saveW

        #creazione network
        self.layer=[]
        self.synapse=[]
        self.attach_layers()

     def attach_layers(self):
        for l in range(self.num_layer): #attacco layer
            saveS=self.saveS
            if l==self.num_layer-1:
                saveS=1
            self.layer.append(Layer_slayer(self.dim[l],saveU=self.saveU,saveS=saveS))
        for l in range(self.num_layer-1): #attacco sinapsi
           self.synapse.append(Synapse_slayer(self.dim[l],self.dim[l+1],mean=self.meanW,var=self.varW,save=self.saveW))

     def run(self,num_step,I_in,obj,winner_neur=0): #I_in [neurone,tempo] obj [neurone] per freq coding e [neurone,tempo] per precice spiking time

        self.initialize_run(num_step)

        self.forward(num_step,I_in)

        if self.training_mode:       
           self.backward(num_step,obj,winner_neur=winner_neur)
           #self.num_epoch+=1

     def initialize_run(self,num_step):
        self.e=[]
        self.sigma=[]
        self.P_record=[]
        self.surr_grad_record=[]
        self.S_out_record=np.zeros((self.dim[-1],num_step))
        self.conv=np.zeros((self.dim[-1],num_step))
        for l in range(self.num_layer):
          self.e.append(np.zeros((self.dim[l],num_step)))
          self.sigma.append(np.zeros((self.dim[l],num_step)))
          self.P_record.append(np.zeros((self.dim[l],num_step)))
          self.surr_grad_record.append(np.zeros((self.dim[l],num_step)))
        
        if self.spike_conv_mode:
           self.flip_spike_response=np.flip(np.power((1-self.layer[-1].neur[0].alfa),np.arange(num_step)))       

     def forward(self,num_step,I_in):
        
        for n in range(num_step):
          if self.statitc_dataset: I=I_in
          if not self.statitc_dataset:I=I_in[:,n]
           
          for l in range(self.num_layer):
            #simuala layer 
            S=self.layer[l].update_layer(I)  
            if l!=self.num_layer-1:
             I=self.synapse[l].update(S)

            self.P_record[l][:,n]=self.layer[l].P
            self.surr_grad_record[l][:,n]=self.layer[l].surr_grad
          self.S_out_record[:,n]=S
           
     def backward(self,Num_step,obj,winner_neur):
        #l'errore  layer d'uscita lo calcolo subito
        if self.Freq_coding:
             self.e[-1]=(obj-self.P_record[-1])      
        else: 
             if self.spike_conv_mode:
                for neur in range(self.dim[-1]):
                  self.conv[neur,:]=np.convolve(obj[neur,:]-self.S_out_record[neur,:],self.flip_spike_response)[Num_step-1:] 
                #self.e[-1]=np.power(self.conv,3)#elevo alla terza perche la differenza deve passare una funzione non lineare dispari      
                self.e[-1][winner_neur,:]=np.power(self.conv[winner_neur,:],3)              
             else:
                self.e[-1]=obj-self.S_out_record 

        #self.kernel=np.power((1-LIF_neuron.alfa),np.arange(0,Num_step,1))
        self.sigma[-1]=self.surr_grad_record[-1]*self.e[-1]#self.correlation(self.e[-1],self.kernel)

        for l in range(self.num_layer-2,-1,-1):  
              grad_w=np.matmul(self.sigma[l+1],self.P_record[l].transpose())
              #grad_w=self.Adam_optimizer(grad_w,self.num_epoch,layer=l)
              #if l==1: grad_w=grad_w/10
              self.synapse[l].update_val(grad_w)
             
              self.e[l]=np.matmul( self.synapse[l].W.transpose(),self.sigma[l+1])
              self.sigma[l]= self.surr_grad_record[l]*self.e[l]
              
     def correlation(signal,kernell): #calcola la cross correlation di due vettori
       size=signal.shape[1]
       num_neur=signal.shape[0]
       Corr=np.zeros((num_neur,2*size)) 
       signal_extended=np.zeros((num_neur,2*size)) #siccome A e B è di dimensione Num_step per fare la cross correlation devo renderlo di dimensione 2*Num_step
       signal_extended[:,0:size]=signal
       for t in range(size):
         s2=np.zeros((num_neur,2*size))
         for n in range(num_neur):
            s2[n,t:t+size]=kernell
         Corr[:,t]=sum(signal_extended*s2)
       return Corr         

     def Adam_optimizer(self,grad,t,layer,b1=0.9,b2=0.999,eps=1e-8):
        if t==1:
           self.m=[]
           self.v=[]
           for l in range(self.num_layer-1):
            self.m.append(np.zeros((self.dim[l+1],self.dim[l])))
            self.v.append(np.zeros((self.dim[l+1],self.dim[l])))

        self.m[layer]=b1*self.m[layer]+(1-b1)*grad
        self.v[layer]=b2*self.v[layer]+(1-b2)*np.square(grad)
        m_cap=self.m[layer]/(1-np.power(b1,t))
        v_cap=self.v[layer]/(1-np.power(b2,t))
        return m_cap/(np.sqrt(v_cap)+eps*np.ones(grad.shape))

     def reset(self):
        for l in range(self.num_layer):
            self.layer[l].reset_layer() #reset layer network
 
     def show(self,fig=0,S_obj='a'):
        for l in  range(self.num_layer):
          if l==self.num_layer-1:self.layer[l].show(S_obj=S_obj,layer_number=l) #plot del layer finale
          if l!=self.num_layer-1:self.layer[l].show(layer_number=l) #plot dei layer interni
          
     def Algorithm_var_plot(self):
        
         for l in  range(self.num_layer):
           self.layer[l].Algorithm_var_plot(l)
           if l!=0:
            plt.figure(f"E of layer {l}")
            for e in self.e[l]:
             plt.plot(e.transpose())
            plt.suptitle(f"E of layer {l}")
            plt.xlabel("Time step")

     def Calculate_winner_neur(self,start=0):
       P_max=-1
       winner_neur=-1
       for i in range(self.output_dim):
          P=np.sum(self.layer[-1].neur[i].P_record[int(start):])
          if P>P_max:
             P_max=P
             winner_neur=i
       if winner_neur==-1:print("ERRORE: non ho trovato il neurone vincente")
       else: return winner_neur  
    
     def change_beta(self,beta_val):
       for i in range(self.num_layer):
            self.layer[i].change_beta(beta_val)

class Objective_spike_bin: 
    type=0
    alfa=0.01
    trh=1

    Num_label=2
    Num_step=87

    burst_len=[5,2] #nel caso di type=1 il vincitore emette 5 spike i perdenti 2   
    spike_interval=[2,5] #nel caso type=2 il vincitore emette una spike ogni 2 step invece i perdenti ogni 7 step
    
    frequency_coding=False
    winner_freq=0.7
    loser_freq=0.2
    baseline_freq=0.1

    c=1.5

    def Calculate(self,label,start,stop): 
        S_obj=np.zeros((self.Num_label,self.Num_step))

        if self.frequency_coding:
            if self.type==0: #ottengo l'obbiettivo facendo la convoluzione tra la risposta l impulso e lo scalino
              S_obj_winner=self.baseline_freq*np.ones(self.Num_step)
              S_obj_loser=self.baseline_freq*np.ones(self.Num_step)
              S_obj_winner[start:stop]=self.winner_freq
              S_obj_loser[start:stop]=self.loser_freq
              spike_response=np.power((1-self.alfa),np.arange(self.Num_step))
          
              for l in range(self.Num_label):
               if l==label:
                   S_obj[l,:]=np.convolve(S_obj_winner,spike_response)[0:self.Num_step]/100
               if l!=label:
                   S_obj[l,:]=np.convolve(S_obj_loser,spike_response)[0:self.Num_step]/100

            if self.type==1: #simulo i neuroni dando un intervallo obbiettivo
               neur=Neuron_slayer(0,0) 
               neur.alfa=self.alfa           
               neur.treshold=self.trh
              
               for l in range(self.Num_label):
                  neur.reset_neur()
                  if l==label:a=0   
                  else:a=1   
                  for n in range(self.Num_step):
                     if n>start and n<stop and n%self.spike_interval[a]==0:
                       neur.update_neur(1.1*self.trh/self.alfa)
                     else: neur.update_neur(0)
                  S_obj[l,:]=np.array(neur.P_record)
            
            if self.type==2: #simulo i neuroni una spike sul finale per il neurone vincente però flippo l'attività
               for n in range(self.Num_step):
                  if n>start and n<stop:
                    S_obj[label,n]=S_obj[label,n-1]*(1+self.alfa)+self.alfa
               S_obj=self.winner_freq*S_obj/np.power((1+self.alfa),stop-start)
               print(np.max(S_obj))
        

        if not self.frequency_coding:
         #ho una sola spike alla fine del segnale obbiettivo
         if self.type==0: 
           S_obj[label,stop]=1
         
         #ho burst di spike alla fine del segnale
         if self.type==1:
           for l in range(self.Num_label):
             if l==label:
                 S_obj[l,stop-self.burst_len[0]:stop]=np.ones(self.burst_len[0])
             if l!=label:
                 S_obj[l,stop-self.burst_len[1]:stop]=np.ones(self.burst_len[1])
         
         #spike per tutta la durata del segnale, la classe vincente ha una frequenza di spike maggiore
         if self.type==2:
            for l in range(self.Num_label):
              if l==label:
                  S_obj[l,start:stop]=self.ones_zero(stop-start,int(self.spike_interval[0]))
              if l!=label:
                  S_obj[l,start:stop]=self.ones_zero(stop-start,int(self.spike_interval[1]))
        
         #spike per tutta la durata del segnale sul della classe, il neurone non della classe non emette spike
         if self.type==3:
            for l in range(self.Num_label):
              if l==label:
                  S_obj[l,start:stop]=self.ones_zero(stop-start,int(self.spike_interval[1]))
 
         #spike dal inizio del segnale fino alla fine della registrazione 
         if self.type==4:
            for l in range(self.Num_label):
              if l==label:
                  S_obj[l,start:]=self.ones_zero(self.Num_step-start,int(self.spike_interval[0]))
              if l!=label:
                  S_obj[l,start:]=self.ones_zero(self.Num_step-start,int(self.spike_interval[1]))
        
        return S_obj     
     
    def ones_zero(duration,periodicity):# ritorna un vettore di durata duration, sotto tutti 0 tranne ogni periodicity che ho un 1
        v=np.zeros(duration)
        for n in range(duration):
            if n%periodicity==0: v[n]=1
        return v
  
class Network_slayer_FA: 

     training_mode=False   
     Freq_coding=True
     spike_conv_mode=False
     statitc_dataset=True
     type_FA="FA" #uSF,brSF,frSF,DFA

     def __init__(self,dim,saveU=0,saveS=0,saveW=0,meanW=LIF_neuron.treshold,varW=LIF_neuron.treshold):
        #parametri network
        self.dim=[]
        for i in dim:
          self.dim.append(i)
        
        self.output_dim=self.dim[len(self.dim)-1]
        self.num_layer=len(self.dim)
        self.meanW=meanW
        self.varW=varW
        #self.num_epoch=1
        
        #salvataggio
        self.saveS=saveS
        self.saveU=saveU
        self.saveW=saveW

        #creazione network
        self.layer=[]
        self.synapse=[]
        self.attach_layers()

        #creazione matrici di feeback
        self.B=[]
        self.Create_Backward_matrix()

     def attach_layers(self):
        for l in range(self.num_layer): #attacco layer
            saveS=self.saveS
            if l==self.num_layer-1:
                saveS=1
            self.layer.append(Layer_slayer(self.dim[l],saveU=self.saveU,saveS=saveS))
        for l in range(self.num_layer-1): #attacco sinapsi
           self.synapse.append(Synapse_slayer(self.dim[l],self.dim[l+1],mean=self.meanW,var=self.varW,save=self.saveW))

     def run(self,num_step,I_in,obj,winner_neur=0): #I_in [neurone,tempo] obj [neurone] per freq coding e [neurone,tempo] per precice spiking time

        self.initialize_run(num_step)

        self.forward(num_step,I_in)

        if self.training_mode:       
           self.backward(num_step,obj,winner_neur=winner_neur)
           #self.num_epoch+=1

     def initialize_run(self,num_step):
        self.e=[]
        self.sigma=[]
        self.P_record=[]
        self.surr_grad_record=[]
        self.S_out_record=np.zeros((self.dim[-1],num_step))
        self.conv=np.zeros((self.dim[-1],num_step))
        for l in range(self.num_layer):
          self.e.append(np.zeros((self.dim[l],num_step)))
          self.sigma.append(np.zeros((self.dim[l],num_step)))
          self.P_record.append(np.zeros((self.dim[l],num_step)))
          self.surr_grad_record.append(np.zeros((self.dim[l],num_step)))
        
        if self.spike_conv_mode:
           self.flip_spike_response=np.flip(np.power((1-self.layer[-1].neur[0].alfa),np.arange(num_step)))       

     def forward(self,num_step,I_in):
        
        for n in range(num_step):
          if self.statitc_dataset: I=I_in
          if not self.statitc_dataset:I=I_in[:,n]
           
          for l in range(self.num_layer):
            #simuala layer 
            S=self.layer[l].update_layer(I)  
            if l!=self.num_layer-1:
             I=self.synapse[l].update(S)

            self.P_record[l][:,n]=self.layer[l].P
            self.surr_grad_record[l][:,n]=self.layer[l].surr_grad
          self.S_out_record[:,n]=S
     
     def Create_Backward_matrix(self):
        for l in range(self.num_layer-1): #attacco sinapsi
           if self.type_FA=="FA": self.B.append(np.random.normal(loc=self.meanW,scale=self.varW,size=(self.dim[l],self.dim[l+1])))
           if self.type_FA=="uSF": self.B.append(np.sign(self.synapse[l].W))
           
     def backward(self,Num_step,obj,winner_neur):
        #l'errore  layer d'uscita lo calcolo subito
        self.e[-1]=(obj-self.P_record[-1])      
        self.sigma[-1]=self.surr_grad_record[-1]*self.e[-1]#self.correlation(self.e[-1],self.kernel)

        for l in range(self.num_layer-2,-1,-1):  
              grad_w=np.matmul(self.sigma[l+1],self.P_record[l].transpose())
              self.synapse[l].update_val(grad_w)
              self.e[l]=np.matmul( self.B[l],self.sigma[l+1])
              self.sigma[l]= self.surr_grad_record[l]*self.e[l]
                
     def correlation(signal,kernell): #calcola la cross correlation di due vettori
       size=signal.shape[1]
       num_neur=signal.shape[0]
       Corr=np.zeros((num_neur,2*size)) 
       signal_extended=np.zeros((num_neur,2*size)) #siccome A e B è di dimensione Num_step per fare la cross correlation devo renderlo di dimensione 2*Num_step
       signal_extended[:,0:size]=signal
       for t in range(size):
         s2=np.zeros((num_neur,2*size))
         for n in range(num_neur):
            s2[n,t:t+size]=kernell
         Corr[:,t]=sum(signal_extended*s2)
       return Corr         

     def Adam_optimizer(self,grad,t,layer,b1=0.9,b2=0.999,eps=1e-8):
        if t==1:
           self.m=[]
           self.v=[]
           for l in range(self.num_layer-1):
            self.m.append(np.zeros((self.dim[l+1],self.dim[l])))
            self.v.append(np.zeros((self.dim[l+1],self.dim[l])))

        self.m[layer]=b1*self.m[layer]+(1-b1)*grad
        self.v[layer]=b2*self.v[layer]+(1-b2)*np.square(grad)
        m_cap=self.m[layer]/(1-np.power(b1,t))
        v_cap=self.v[layer]/(1-np.power(b2,t))
        return m_cap/(np.sqrt(v_cap)+eps*np.ones(grad.shape))

     def reset(self):
        for l in range(self.num_layer):
            self.layer[l].reset_layer() #reset layer network
 
     def show(self,fig=0,S_obj='a'):
        for l in  range(self.num_layer):
          if l==self.num_layer-1:self.layer[l].show(S_obj=S_obj,layer_number=l) #plot del layer finale
          if l!=self.num_layer-1:self.layer[l].show(layer_number=l) #plot dei layer interni
          
     def Algorithm_var_plot(self):
        
         for l in  range(self.num_layer):
           self.layer[l].Algorithm_var_plot(l)
           if l!=0:
            plt.figure(f"E of layer {l}")
            for e in self.e[l]:
             plt.plot(e.transpose())
            plt.suptitle(f"E of layer {l}")
            plt.xlabel("Time step")

     def Calculate_winner_neur(self,start=0):
       P_max=-1
       winner_neur=-1
       for i in range(self.output_dim):
          P=np.sum(self.layer[-1].neur[i].P_record[int(start):])
          if P>P_max:
             P_max=P
             winner_neur=i
       if winner_neur==-1:print("ERRORE: non ho trovato il neurone vincente")
       else: return winner_neur  
    
     def change_beta(self,beta_val):
       for i in range(self.num_layer):
            self.layer[i].change_beta(beta_val)



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
