import numpy as np
import matplotlib.pyplot as plt

class LIF_neuron: #neurone leaky integrate and fire
    treshold=1
    alfa=0.9 #alfa=dt/tau
    T_refactory=0
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
        
        if self.resting_state==False:
          self.U=self.nextU
          self.U+=(-self.U+I_in)*self.alfa
  
          self.nextU=self.U
          if self.U>=self.treshold:
              spike=1
              self.nextU=0  
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
    
    def reset(self):
        for i in range(self.dim):
            self.neur[i].reset()
    
    def show(self,figure_number=0):
        if self.saveS==0 and self.saveU==0: #non plottare nulla
            print("impossibile plottare perchè non è stato richiesto il salvataggio")

        if self.saveS==1 and self.saveU==0:# plot solo spike
            x=np.arange(0,len(self.neur[0].S_record),1)
            for i in range(self.dim):
             S=[(i+1)*j for j in self.neur[i].S_record]
             plt.plot(x,S,'k.',markersize=3)
            plt.xlabel("Time step")
            plt.ylabel("Neuron Number")
            plt.ylim((0.5,self.dim+0.5))
          
        if self.saveS==0 and self.saveU==1:# plot solo potenziali
            x=np.arange(0,len(self.neur[0].U_record),1)
            v=np.ones(len(self.neur[0].U_record))
            for i in range(self.dim):
              plt.plot(x,self.neur[i].U_record+2*i*self.neur[i].treshold*v)
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            plt.yticks([])
            
        if self.saveS==1 and self.saveU==1:#plot spike e potenziali
            plt.figure(figure_number)
            x=np.arange(0,len(self.neur[0].S_record),1)
            for i in range(self.dim):
             S=[(i+1)*j for j in self.neur[i].S_record]
             plt.plot(x,S,'k.',markersize=3)
            plt.xlabel("Time step")
            plt.ylabel("Neuron Number")
            plt.ylim((0.5,self.dim+0.5))
            
            plt.figure(figure_number+1)
            x=np.arange(0,len(self.neur[0].U_record),1)
            v=np.ones(len(self.neur[0].U_record))
            for i in range(self.dim):
              plt.plot(x,self.neur[i].U_record+2*i*self.neur[i].treshold*v)
            plt.xlabel("Time step")
            plt.ylabel("Neuron ")
            plt.yticks([])
                   
class synapse: #insieme delle sinapsi che collegano il layer l-1 di idmensione dim_pre al layer l di imensione dim_post

    def __init__(self,dim_pre, dim_post,mean,var):
        self.dim_pre=dim_pre 
        self.dim_post=dim_post 
        self.W=np.abs(np.random.normal(loc=mean,scale=var,size=(dim_post,dim_pre))) #pesi sinaptici
        print(self.W)

    def update(self, spike_in): #ottengo il vettore di spike[dim_pre] provenienti dal layer precedente
        I=np.dot(self.W,spike_in)
        return I #calcolo la corrente in uscita, vettore di dimensione dim_post

class Network:
    def __init__(self,dim_in,dim_hid,dim_out,saveU=0,saveS=0,meanW=0,varW=0.5):
        self.dim=[dim_in,dim_hid,dim_out]
        
        #creazione network
        self.layer=[]
        self.synapse=[]
        for l in range(3):
            self.layer.append(LIF_layer(self.dim[l],saveU=saveU,saveS=saveS))
        for l in range(2):
         self.synapse.append(synapse(self.dim[l],self.dim[l+1],mean=meanW,var=varW))
        
       
    def run(self,num_step,I_in): #I_in [neurone,tempo]
        for n in range(num_step):
            S0=self.layer[0].update(I_in[:,n]) 
            I0=self.synapse[0].update(S0)

            S1=self.layer[1].update(I0)
            I2=self.synapse[1].update(S1)

            S_out=self.layer[2].update(I2)
        return S_out

    def show(self):
        in_plot=plt.figure(1)
        in_plot.suptitle("Input spike")
        self.layer[0].show(1)
        hid_plot=plt.figure(3)
        hid_plot.suptitle("hidden spike")
        self.layer[1].show(3)
        out_plot=plt.figure(5)
        out_plot.suptitle("output spike")
        self.layer[2].show(5)



        
            


