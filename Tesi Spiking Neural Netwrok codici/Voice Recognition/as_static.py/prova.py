import numpy as np

a=np.ones(3)
b=np.ones(4)

c=np.outer(a,b)
print(c)
print(c.shape)