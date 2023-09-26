


    
class Network_decolle_I: 
     lr=1e-4
     debug=1

     def __init__(self,dim_in,dim_hid,dim_out,saveU=0,saveS=0,meanW=0,varW=0.5):
        self.dim=[dim_in,dim_hid,dim_out]

        #creazione network
        self.layer=[]
        self.synapse=[]
        for l in range(3): #attacco layer
            if l==2:
                saveS=1
            self.layer.append(LIF_layer(self.dim[l],saveU=saveU,saveS=saveS))
        for l in range(2): #attacco sinapsi
           self.synapse.append(synapse(self.dim[l],self.dim[l+1],mean=meanW,var=varW))

        #layer di output intermedi per learing locale
        self.int_layer=LIF_layer(self.dim[2],saveU=saveU,saveS=saveS)
        self.int_syn=synapse(self.dim[1],self.dim[2],mean=meanW,var=varW)

        if self.debug:
           self.E0_record=[]
           self.activity0_record=[]
           self.B1_record=[]
           for i in range(self.dim[1]):
              self.E0_record.append([])
              self.activity0_record.append([])
              self.B1_record.append([])

           self.E1_record=[]
           self.activity1_record=[]
           self.B2_record=[]
           self.Bint_record=[]
           for i in range(self.dim[2]):
              self.E1_record.append([])
              self.activity1_record.append([])
              self.B2_record.append([])
              self.Bint_record.append([])

           self.grad0_record=[]
           self.grad1_record=[]                               
                      
     def run(self,num_step,I_in,S_obj): #I_in e S_obj sono di tipo [neurone,tempo]

        def B(layer): #riceve un oggetto layer e restiuisce un vettore con il surrogate gradient del potenziale di ogni neurone
            v=np.zeros(layer.dim)
            for i in range(layer.dim):
                if 0.5<layer.neur[i].U<1.5: #box car surrogate gradient
                    v[i]=1
            return v
        
        for n in range(num_step):
          
            S0=self.layer[0].update(I_in[:,n]) 
            I0=self.synapse[0].update(S0)
            
            S1=self.layer[1].update(I0) 
        
            I_int=self.int_syn.update(S1) #layer intermedio
            S_int=self.int_layer.update(I_int)  
            
            E0=np.matmul((S_int-S_obj[:,n])*B(self.int_layer),self.int_syn.W)
            self.synapse[0].W-=self.lr*np.outer(E0*B(self.layer[1]),self.layer[0].activity())

            I1=self.synapse[1].update(S1)
            S2=self.layer[2].update(I1) #spike in uscita dalla rete

            E=(S2-S_obj[:,n])
            self.synapse[1].W-=self.lr*np.outer(E*B(self.layer[2]),self.layer[1].activity())

            if self.debug:
              self.grad0_record.append(self.lr*np.outer(E0*B(self.layer[1]),self.layer[0].activity()))
              self.grad1_record.append(self.lr*np.outer(E*B(self.layer[2]),self.layer[1].activity()))

              for i in range(self.dim[1]):
                 self.E0_record[i].append(E0[i])
                 self.B1_record[i].append(B(self.layer[1])[i])
              
              for i in range(self.dim[2]):
                 self.E1_record[i].append(E[i])
                 self.Bint_record[i].append(B(self.int_layer)[i])
                 self.B2_record[i].append(B(self.layer[2])[i])
                          
     def reset(self):
        for l in range(3):
            self.layer[l].reset()

     def show(self):
        
        for i in  range(3):
          self.layer[i].show(0+2*i,i)
    
     def debug_plot(self,num_fig,numstep):
        def rearrange_list(list, dim_subArr):
           v=[]
           for j in range(dim_subArr):
            for i in list:
              v.append(i[j])
           return v
        #B
        """self.Bint_record=rearrange_list(self.Bint_record,self.dim[2])
        plt.plot(self.Bint_record[0])
        
        self.B1_record=rearrange_list(self.B1_record,self.dim[1])
        self.B2_record=rearrange_list(self.B2_record,self.dim[2])"""
        m=1
        plt.figure(num_fig)
        for i in range(self.dim[2]):
             S=[(i+1)*j for j in self.Bint_record[i]]
             plt.plot(S,'.',markersize=m)
        plt.suptitle("B int")

        plt.figure(num_fig+1)
        for i in range(self.dim[1]):
             S=[(i+1)*j for j in self.B1_record[i]]
             plt.plot(S,'.',markersize=m)
        plt.suptitle("B 1")
        
        plt.figure(num_fig+2)
        for i in range(self.dim[2]):
             S=[(i+1)*j for j in self.B2_record[i]]
             plt.plot(S,'.',markersize=m)
        plt.suptitle("B 2")
     #E
        plt.figure(num_fig+3)
        for i in range(self.dim[2]):
             S=[j+3*i for j in self.E1_record[i]]
             plt.plot(S,'.',markersize=m)
        plt.suptitle("E1")

        plt.figure(num_fig+4)
        for i in range(self.dim[1]):
             S=[j+3*i for j in self.E0_record[i]]
             plt.plot(S,'.',markersize=m)
        plt.suptitle("E0")
        
