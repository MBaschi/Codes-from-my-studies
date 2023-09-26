import pyNN.brian2 as sim #importo la libreria


print("inizio")

sim.setup(timestep=1) #imposto il time step della simulazione

cell_parameter={"tau_m":12.0,"cm":0.8,"v_thresh":-50.0} #parametri del neurone, ce ne sono moltissimi in questo caso sono specificati la costante di tempo la capacità e il treshold

pE=sim.Population(2,sim.IF_curr_exp(**cell_parameter)) #definisco una popolazione di 2 neuroni di tipo IF
pI=sim.Population(5,sim.IF_curr_exp(**cell_parameter)) #definisco una popolazione di 5 neuroni di tipo IF
all=pE+pI # definisco all come popolazione complessiva
input=sim.Population(1,sim.SpikeSourcePoisson(rate=10)) # definisco l'input che sarà una poisson source con rate 10 (ogni 10s arriva un uno credo)

sim.run(100.0)
sim.end()

print("fine")