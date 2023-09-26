
import math as m
import numpy as np
import itertools
import matplotlib.pyplot as plt
import pandas as pd
from copy import copy
from scipy import signal
from matplotlib.animation import FuncAnimation


a=np.ones((3,3))
a[1,:]=2
a[2,:]=3
a[1,1]=5
a[1,2]=6
print(a)
b=[]
b
for i in range(3):
   b.append([])
   for j in range(5):
      b[i].append([])

print(b)