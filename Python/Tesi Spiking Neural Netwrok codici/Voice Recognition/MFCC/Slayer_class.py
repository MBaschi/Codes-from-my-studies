import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as m_patches

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
    only_positive=True

    def __init__(self,dim_pre, dim_post,mean,var):
        self.dim_pre=dim_pre 
        self.dim_post=dim_post 
        if not self.only_positive:   self.W=np.abs(np.random.normal(loc=mean,scale=var,size=(dim_post,dim_pre))) #pesi sinaptici
        if self.only_positive:       self.W=np.abs(np.random.normal(loc=mean,scale=var,size=(dim_post,dim_pre)))
        
    def update(self, spike_in): #ottengo il vettore di spike[dim_pre] provenienti dal layer precedente
        I=np.dot(self.W,spike_in)
        return I #calcolo la corrente in uscita, vettore di dimensione dim_post

def Box_car(U,min,max): #funzione gradiente surrogato box car
   if min<U<max: return 1
   else: return 0

def bell_shape(U,alfa,beta,treshold): #funzione gradiente surrogato
   return alfa*np.exp(-beta*np.abs(U-treshold))
        
class Neuron_slayer (LIF_neuron): #il neurone del network decolle è un neurone LIF normale ma bisogna tener conto della sua attività P e del gradiente surrogato del suo potenziale per poter fare learning
    beta=0.01

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
    
    def update(self,I): 
        spike=np.zeros(self.dim)
        for i in range(self.dim):
            spike[i]=self.neur[i].update_neur(I[i])
            self.surr_grad[i]=self.neur[i].grad
            self.P[i]=self.neur[i].P
        return spike #ritorno il vettore dei neuroni che hanno avuto una spike
    
    def run(self,Num_step,I):
       for t in range(Num_step):
          self.update([I[:,t]])

    def activity(self): #ritorna il vettore attivita del layer
       v=np.zeros(self.dim)
       for i in range(self.dim):
          v[i]=self.neur[i].a
       return v
       
    def reset_layer(self):
        self.P=np.zeros(self.dim)
        for i in range(self.dim):
            self.neur[i].reset_neur()
    
    def show(self,S_obj='a',fig=0,layer_number=0,int=0):
        if self.saveS==0 and self.saveU==0: #non plottare nulla
            print("impossibile plottare perchè non è stato richiesto il salvataggio")
        
        if self.saveS:# plot solo spike
            if int==1:plt.figure(f"Spike of internal layer {layer_number}")
            else:plt.figure(f"Spike of layer {layer_number}")
            fig+=1
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
            fig+=1
            x=np.arange(0,len(self.neur[0].U_record),1)
            v=np.ones(len(self.neur[0].U_record))
            for i in range(self.dim):
              plt.plot(x,self.neur[i].U_record+4*i*self.neur[i].treshold*v)
              plt.plot(x,self.neur[i].treshold*v+4*i*self.neur[i].treshold*v,'r--')
            plt.suptitle(f"Membrane potential of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            plt.yticks([])
            
        return fig

    def Algorithm_var_plot(self,figure_number=0,layer_number=0, int=0): 
        #plot gradiente surrogato
        if int: plt.figure(f"Surrogate gradient of intermidiate layer {layer_number}") 
        else: plt.figure(f"Surrogate gradient of layer {layer_number}") #se è un layer interno cambio il titolo
    
        for i in range(self.dim):
         plt.plot(self.neur[i].grad_record)
        plt.xlabel("Time step")
        plt.ylabel("Neuron Number")
        figure_number+=1

        #plot traccia neuroni precednti
        if int: pass
        else : 
            plt.figure(f"P of layer {layer_number}")
            x=np.arange(0,len(self.neur[0].P_record),1)
            v=np.ones(len(self.neur[0].P_record))
            for i in range(self.dim):
             plt.plot(self.neur[i].P_record)
            plt.suptitle(f"P of layer {layer_number}")      
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            figure_number+=1
       # plt.yticks([])
        return figure_number
              
class Synapse_slayer(synapse): #la sinapsi in Decolle è identica a una sinapsi normale ma può essere aggiornata utilizzando l'errore del layer sucessivo e alcune informazioni salvate nel layer precedente e quello successivo
   lr=1e-4

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
      #voglio che i pesi sinaptici rimangano positivi
      for i in range(self.dim_post):
         for j in range(self.dim_pre):
            #if self.W[i,j]<0: self.W[i,j]=0.1
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
    
     def __init__(self,dim,saveU=0,saveS=0,saveW=0,meanW=LIF_neuron.treshold,varW=LIF_neuron.treshold):
        #parametri network
        self.dim=[]
        for i in dim:
          self.dim.append(i)
        
        self.output_dim=self.dim[len(self.dim)-1]
        self.num_layer=len(self.dim)
        self.meanW=meanW
        self.varW=varW
        self.num_epoch=0
        
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

     def run(self,num_step,I_in,obj): #I_in [neurone,tempo] obj [neurone] per freq coding e [neurone,tempo] per precice spiking time

        self.e=[]
        self.sigma=[]
        self.P_record=[]
        self.surr_grad_record=[]
        for l in range(self.num_layer):
          self.e.append(np.zeros((self.dim[l],num_step)))
          self.sigma.append(np.zeros((self.dim[l],num_step)))
          self.P_record.append(np.zeros((self.dim[l],num_step)))
          self.surr_grad_record.append(np.zeros((self.dim[l],num_step)))

        self.forward(num_step,I_in,obj)
        if self.training_mode:       
           self.backward(num_step)
           self.num_epoch+=1
        
     def forward(self,num_step,I_in,obj):
        
        for n in range(num_step):
          I=I_in[:,n]
          
          for l in range(self.num_layer):
            #simuala layer 
            S=self.layer[l].update(I)  
            if l!=self.num_layer-1:
             I=self.synapse[l].update(S)
           
            self.P_record[l][:,n]=self.layer[l].P
            self.surr_grad_record[l][:,n]=self.layer[l].surr_grad
           
           #l'errore el layer d'uscita lo calcolo subito
            if self.Freq_coding:
                 self.e[-1][:,n]=obj[:,n]-self.layer[-1].P        
            else: 
                 self.e[-1][:,n]=obj[:,n]-S
     
     def backward(self,num_step):
        #self.kernel=np.power((1-LIF_neuron.alfa),np.arange(0,num_step,1))
        self.sigma[-1]=self.surr_grad_record[-1]*self.e[-1]#self.correlation(self.e[-1],self.kernel)

        for l in range(self.num_layer-2,-1,-1):  
              grad_w=np.matmul(self.sigma[l+1],self.P_record[l].transpose())
              #grad_w=self.Adam_optimizer(grad_w,self.num_epoch,layer=l)
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
        if t==0:
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
          if l==self.num_layer-1:fig=self.layer[l].show(S_obj=S_obj,fig=fig,layer_number=l,int=0) #plot del layer finale
          if l!=self.num_layer-1:fig=self.layer[l].show(fig=fig,layer_number=l,int=0) #plot dei layer interni
        return fig
    
     def Algorithm_var_plot(self,num_fig=0):
         fig=num_fig
         for l in  range(self.num_layer):
           fig=self.layer[l].Algorithm_var_plot(fig,l,int=0)
           if l!=0:
            plt.figure(f"E of layer {l}")
            for e in self.e[l]:
             plt.plot(e.transpose())
            fig+=1
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

class Objective_spike_bin: #ATTENZIONE: OBJECTIVE SPIKE SOLO PER DATASET BINARIO
    type=0
    alfa=0.01

    Num_label=2
    Num_step=87

    burst_len=[5,2] #nel caso di type=1 il vincitore emette 5 spike i perdenti 2   
    spike_interval=[2,5] #nel caso type=2 il vincitore emette una spike ogni 2 step invece i perdenti ogni 7 step
    
    frequency_coding=False
    winner_freq=0.7
    loser_freq=0.2
    baseline_freq=0.1

    def Calculate(self,label,start,stop): 
        S_obj=np.zeros((self.Num_label,self.Num_step))

        if self.frequency_coding:
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
   
        