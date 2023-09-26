import pyNN.brian2 as sim #importo la libreria
from pyNN.utility.plotting import Figure, Panel
import matplotlib.pyplot as matplotlib
from pyNN.random import RandomDistribution

print("inizio")

#PARAMENTR SIMULAZIONE
n_neurons=100
n_exc=int(round(n_neurons*0.8))
n_inh=int(round(n_neurons*0.2))

simtime=100

sim.setup(timestep=0.1) 

#CONFIGURARE RETE
pop_exc=sim.Population(n_exc,sim.IF_cond_exp(),label='Excitatory') 
pop_inh=sim.Population(n_inh,sim.IF_cond_exp(),label='Inhibitory') 

stim_exc=sim.Population(n_exc,sim.SpikeSourcePoisson(rate=10),label='Stim_exc') 
stim_inh=sim.Population(n_inh,sim.SpikeSourcePoisson(rate=10),label='Stim_inh')  

synapse_exc=sim.StaticSynapse(weight=0.2, delay=2)
synapse_inh=sim.StaticSynapse(weight=1, delay=2)
 #connetto rete
sim.Projection(pop_exc,pop_exc, sim.FixedProbabilityConnector(0.1),synapse_type=synapse_exc, receptor_type='excitatory')
sim.Projection(pop_exc,pop_inh, sim.FixedProbabilityConnector(0.1),synapse_type=synapse_exc, receptor_type='excitatory')
sim.Projection(pop_inh,pop_inh, sim.FixedProbabilityConnector(0.1),synapse_type=synapse_inh, receptor_type='inhibitory')
sim.Projection(pop_inh,pop_exc, sim.FixedProbabilityConnector(0.1),synapse_type=synapse_inh, receptor_type='inhibitory')
 #connetto stimoli
delays=RandomDistribution("uniform", [1,1.6])
synapse_stim=sim.StaticSynapse(weight=2.0,delay=delays)
sim.Projection(stim_exc,pop_exc, sim.OneToOneConnector(),synapse_type=synapse_stim, receptor_type='excitatory')
sim.Projection(stim_inh,pop_inh, sim.OneToOneConnector(),synapse_type=synapse_stim, receptor_type='excitatory')
 #inizzializzo
pop_exc.initialize(v=RandomDistribution("uniform",parameters_pos=[-65.0,-55.0]))
pop_inh.initialize(v=RandomDistribution("uniform",parameters_pos=[-65.0,-55.0]))
pop_exc.record("spikes")

#RUN SIMULAZIONE
sim.run(simtime)

#PLOT
spikes=pop_exc.get_data(variables=['spikes'])
out=spikes.segments[0].spiketrains

Figure(
    Panel(out,xticks=True,yticks=True)
)

matplotlib.show()

sim.end()


print("fine")