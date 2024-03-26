#in questo codice cotruisco i vari network di decolle
#I-single spike coding, aggiornamento ad ogni istante temporale
#II-single spike coding, aggiornamento ad ogni istante temporale, errore convoluto per l'esponenziale
import numpy as np
import matplotlib.pyplot as plt

class LIF_neuron: #neurone leaky integrate and fire
    treshold=1
    alfa=0.9 #alfa=dt/tau
    def __init__(self,saveU=0,saveS=0): 
        self.U=0 #potenziale di membrana
        self.nextU=0

        self.saveU=saveU
        self.saveS=saveS
        if saveU: #richiesta di salvare i valori del potenzaile (da default falso)       
         self.U_record=[] 
        if saveS: #richiesta di salvare i valori delle spike (da default falso)
         self.S_record=[]
        
    def update(self,I_in): #simula il neurone dal tempo t al t+1 (questa funzione dovrà essere inserita in un for)
        spike=0
        
        self.U=self.nextU
        self.U+=(-self.U+I_in)*self.alfa

        self.nextU=self.U
        if self.U>self.treshold:
            spike=1
            self.nextU=0  
        
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
        plt.show()

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

    def __init__(self,dim_pre, dim_post,mean,var):
        self.dim_pre=dim_pre 
        self.dim_post=dim_post 
        self.W=np.abs(np.random.normal(loc=mean,scale=var,size=(dim_post,dim_pre))) #pesi sinaptici
        
    def update(self, spike_in): #ottengo il vettore di spike[dim_pre] provenienti dal layer precedente
        I=np.dot(self.W,spike_in)
        
        return I #calcolo la corrente in uscita, vettore di dimensione dim_post

def Box_car(U,min,max): #funzione gradiente surrogato box car
   if min<U<max: return 1
   else: return 0

def bell_shape(U,alfa,beta,treshold): #funzione gradiente surrogato
   return alfa*np.exp(-beta*np.abs(U-treshold))
    
class Neuron_decolle (LIF_neuron): #il neurone del network decolle è un neurone LIF normale ma bisogna tener conto della sua attività P e del gradiente surrogato del suo potenziale per poter fare learning

    def __init__(self,saveU=0,saveS=0,saveAll=0):
        super().__init__(saveU,saveS)
        self.P=0
        
        if saveAll:
         self.saveAll=saveAll
         self.grad_record=[]
         self.P_record=[]

    def update_neur(self,I_in):
        spike=self.update(I_in)
        self.P+=-self.P*self.alfa+spike
        #self.grad=Box_car(self.U,nin=0.5,max=1.5) 
        self.grad=bell_shape(self.U,alfa=2,beta=0.01,treshold=self.treshold)

        if self.saveAll:
           self.grad_record.append(self.grad)
           self.P_record.append(self.P)

        return spike

    def reset_neur(self):
        self.U=0
        if self.saveU:
              self.U_record=[]
        if self.saveS:
              self.S_record=[]
        if self.saveAll:
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
        plt.show()

class Layer_decolle(): #il layer decolle è fatto di neuroni decolle quindi terrà conto delle variabili aggiunte nel neurone decolle

    def __init__(self,dim,saveU=0,saveS=0,saveAll=0):
        self.dim=dim 
        self.saveS=saveS
        self.saveU=saveU
        self.saveAll=saveAll
        self.neur=[]
        for i in range(dim):
            self.neur.append(Neuron_decolle(saveU,saveS,saveAll))
        self.surr_grad=np.zeros(dim)
        self.P=np.zeros(dim)
    
    def update(self,I): 
        spike=np.zeros(self.dim)
        for i in range(self.dim):
            spike[i]=self.neur[i].update_neur(I[i])
            self.surr_grad[i]=self.neur[i].grad
            self.P[i]=self.neur[i].P
        return spike #ritorno il vettore dei neuroni che hanno avuto una spike
    
    def activity(self): #ritorna il vettore attivita del layer
       v=np.zeros(self.dim)
       for i in range(self.dim):
          v[i]=self.neur[i].a
       return v
       
    def reset_layer(self):
        for i in range(self.dim):
            self.neur[i].reset_neur()
    
    def show(self,S_obj=['a'],fig=0,layer_number=0,int=0):
        if self.saveS==0 and self.saveU==0: #non plottare nulla
            print("impossibile plottare perchè non è stato richiesto il salvataggio")
        
        if self.saveS:# plot solo spike
            if int==1:plt.figure(f"Spike of internal layer {layer_number}")
            else:plt.figure(f"Spike of layer {layer_number}")
            fig+=1
            x=np.arange(0,len(self.neur[0].S_record),1)
            for i in range(self.dim):
             S=[(i+1)*j for j in self.neur[i].S_record]
             plt.plot(x,S,'k.',markersize=3)
             if S_obj[0]!='a':
                S=[(i+1)*j for j in S_obj[i]]
                plt.plot(x,S,'r.',markersize=3)
            plt.suptitle(f"Spike of layer {layer_number}")
            plt.xlabel("Time step")
            plt.ylabel("Neuron Number")
            plt.ylim((0.5,self.dim+0.5))
          
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
        if int: plt.figure(f"Surrogate gradient of intermidiate layer {layer_number}") 
        else: plt.figure(f"Surrogate gradient of layer {layer_number}")
        x=np.arange(0,len(self.neur[0].grad_record),1)
        for i in range(self.dim):
         S=[(i+1)*j for j in self.neur[i].grad_record]
         plt.plot(x,S)
        if int: plt.suptitle(f"Surrogate gradient of intermidiate layer {layer_number}") #se è un layer interno cambio il titolo
        else: plt.suptitle(f"Surrogate gradient of layer {layer_number}")
        plt.xlabel("Time step")
        plt.ylabel("Neuron Number")
        figure_number+=1

        if int: pass
        else : 
            plt.figure(f"P of layer {layer_number}")
            x=np.arange(0,len(self.neur[0].P_record),1)
            v=np.ones(len(self.neur[0].P_record))
            for i in range(self.dim):
             plt.plot(x,self.neur[i].P_record+1.5*v)
            plt.suptitle(f"P of layer {layer_number}")      
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            figure_number+=1
       # plt.yticks([])
        return figure_number
              
class Synapse_decolle(synapse): #la sinapsi in Decolle è identica a una sinapsi normale ma può essere aggiornata utilizzando l'errore del layer sucessivo e alcune informazioni salvate nel layer precedente e quello successivo
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

   def update_val(self,E,layer_prec,layer_post):
      self.W+=self.lr*np.outer(E*layer_post.surr_grad,layer_prec.P)
      #voglio che i pesi sinaptici rimangano positivi
      for i in range(self.dim_post):
         for j in range(self.dim_pre):
            if self.W[i,j]<0: self.W[i,j]=0.1
            if self.save: self.W_record[i][j].append(self.W[i,j])

   def reset(self):
      if self.save:
           self.W_record=[]
           for i in range(self.dim_post):
              self.W_record.append([])
              for j in range(self.dim_pre):
                 self.W_record[i].append([])    

   def show(self,layer_number=0):
      if not self.save:
         print("Richiesta di stampare i pesi sinaptici senza aver slavato i valori, porre save=1")
      if self.save:
         t=len(self.W_record)
         plt.figure(f"Synaptic weight of layer {layer_number}")
         plt.suptitle(f"Synaptic weight of layer {layer_number}")
         plt.xlabel("Time step")
         plt.ylabel("Synaptic weight")

         for i in range(self.dim_post):
            for j in range(self.dim_pre):
              plt.plot(self.W_record[i][j])

class Network_decolle_II: 

     training_mode=False   

     def __init__(self,dim,saveU=0,saveS=0,saveAll=0,meanW=LIF_neuron.treshold,varW=LIF_neuron.treshold,meanW_int=LIF_neuron.treshold,varW_int=LIF_neuron.treshold):
        #parametri network
        self.dim=[]
        for i in dim:
          self.dim.append(i)
        
        self.output_dim=self.dim[len(self.dim)-1]
        self.num_layer=len(self.dim)
        self.E_max=2*(meanW_int+varW_int) #l'errore massimo dei layer interni è il massimo della funzione di gradiente surrogato (in questo caso=alfa=2) per il peso sinaptico massimo
        self.meanW=meanW
        self.varW=varW
        self.meanW_int=meanW_int
        self.varW_int=varW_int
        
        #salvataggio
        self.saveS=saveS
        self.saveU=saveU
        self.saveAll=saveAll

        #creazione network
        self.layer=[]
        self.synapse=[]
        self.attach_layers()

        #layer di output intermedi per learing locale
        self.int_layer=[]
        self.int_syn=[]
        self.attach_int_layers()
                  
     def attach_layers(self):
        for l in range(len(self.dim)): #attacco layer
            saveS=self.saveS
            if l==self.dim:
                saveS=1
            self.layer.append(Layer_decolle(self.dim[l],saveU=self.saveU,saveS=saveS,saveAll=self.saveAll))
        for l in range(self.num_layer-1): #attacco sinapsi
           self.synapse.append(Synapse_decolle(self.dim[l],self.dim[l+1],mean=self.meanW,var=self.varW,save=self.saveAll))

     def attach_int_layers(self):
        for l in range(self.num_layer): 
             if l==0 or l==self.num_layer-1: #se il layer è quello di ingresso o finale appendiamo una lista vuota
                self.int_syn.append([])
                self.int_layer.append([])
             else:
               self.int_syn.append(Synapse_decolle(self.dim[l],self.output_dim,mean=self.meanW_int,var=self.varW_int,save=0))
               self.int_layer.append(Layer_decolle(self.output_dim,saveU=self.saveU,saveS=self.saveS,saveAll=self.saveAll))

     def run(self,num_step,I_in,S_obj): #I_in e S_obj sono di tipo [neurone,tempo]

        if self.saveAll:
           self.E_record=[]
           E=[]
           for l in range(self.num_layer):
              self.E_record.append(np.zeros((self.dim[l],num_step)))
              E.append(np.zeros(self.dim[l]))

        for n in range(num_step):
          I=I_in[:,n]
          
          for l in range(self.num_layer):
            #simuala layer 
            S=self.layer[l].update(I)  
            if l!=self.num_layer-1:
             I=self.synapse[l].update(S)
           
            #calcola errore
            if l!=0 and l!=self.num_layer-1:       
              I_int=self.int_syn[l].update(S) #layer intermedio
              S_int=self.int_layer[l].update(I_int) 
              E[l]=np.matmul((S_obj[:,n]-S_int)*self.int_layer[l].surr_grad,self.int_syn[l].W)/self.E_max
              
            if l==self.num_layer-1:
               E[l]=S_obj[:,n]-S
              
            #aggiorna pesi sinaptici
            if l!=0 and self.training_mode==True:
             self.synapse[l-1].update_val(E[l],self.layer[l-1],self.layer[l])
             
           #salva l'errore
            if self.saveAll:
             if l!=0: 
              self.E_record[l][:,n]=E[l]

     def reset(self):
        for l in range(self.num_layer):
            self.layer[l].reset_layer() #reset layer network
            if l!=0 and l!=self.num_layer-1:
             self.int_layer[l].reset_layer() #reset layer di uscita intermedi
            if l!=0:
             self.synapse[l-1].reset()
 
     def show(self,fig,S_obj):
        for l in  range(self.num_layer):
          if l==self.num_layer-1:fig=self.layer[l].show(S_obj=S_obj,fig=fig,layer_number=l,int=0) #plot del layer finale
          if l!=self.num_layer-1:fig=self.layer[l].show(fig=fig,layer_number=l,int=0) #plot dei layer interni
          if l!=0 and l!=self.num_layer-1: #plot dei layer intermedi
             self.int_layer[l].show(S_obj=S_obj,fig=fig,layer_number=l,int=1)
        return fig
    
     def Algorithm_var_plot(self,num_fig):
        if self.saveAll==0:
           print("Hai richiesto il plot ma non ho slavato i dati, metti saveAll=1")

        if self.saveAll:
         fig=num_fig
         for l in  range(self.num_layer):
           fig=self.layer[l].Algorithm_var_plot(fig,l,int=0)
           if l!=0 and l!=self.num_layer-1: 
            fig=self.int_layer[l].Algorithm_var_plot(fig,l,int=1)
           if l!=0:
            plt.figure(f"E of layer {l}")
            a=self.E_record[l]
            for e in a:
             plt.plot(e)
            fig+=1
            plt.suptitle(f"E of layer {l}")
            plt.xlabel("Time step")