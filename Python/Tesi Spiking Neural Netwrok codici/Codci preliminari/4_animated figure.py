import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# Fixing random state for reproducibility
np.random.seed(19680801)


# Create new Figure and an Axes which fills it.
fig = plt.figure(figsize=(7, 7))
ax = fig.add_axes([0, 0, 1, 1], frameon=False)
ax.set_xlim(0, 1), ax.set_xticks([])
ax.set_ylim(0, 1), ax.set_yticks([])

# Create rain data
n_drops = 50
rain_drops = np.zeros(n_drops, dtype=[('position', float, (2,)),
                                      ('size',     float),
                                      ('growth',   float),
                                      ('color',    float, (4,))])

# Initialize the raindrops in random positions and with
# random growth rates.
rain_drops['position'] = np.random.uniform(0, 1, (n_drops, 2))
for i in range(n_drops):
    rain_drops['position'][i]=0,1*i

rain_drops['growth'] = np.random.uniform(50, 200, n_drops)
rain_drops['color'] = (0, 0, 0, 1)
# Construct the scatter which we will update during animation
# as the raindrops develop.
scat = ax.scatter(rain_drops['position'][:, 0], rain_drops['position'][:, 1],
                  s=rain_drops['size'], lw=0.5, edgecolors=rain_drops['color'],
                  facecolors='none')
   # Update the scatter collection, with the new colors, sizes and positions.
rain_drops['size'] = 40
rain_drops['color']= (0, 0.5, 1, 1)   
scat.set_edgecolors(rain_drops['color'])
scat.set_sizes(rain_drops['size'])
scat.set_offsets(rain_drops['position'])


def update(frame_number):
  i=0
  
 
   

 

# Construct the animation, using the update function as the animation director.
animation = FuncAnimation(fig, update, interval=10)
plt.show()