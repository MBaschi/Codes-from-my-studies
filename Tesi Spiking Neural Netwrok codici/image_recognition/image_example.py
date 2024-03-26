from sklearn.datasets import load_digits
from sklearn.model_selection import train_test_split
digits = load_digits()
print(digits.data.shape)

import matplotlib.pyplot as plt
X_train, X_test, y_train, y_test = train_test_split( digits.data, digits.target, test_size=0.33, random_state=42)
#plt.gray() 
for i in range(1000):
   plt.clf()
   print(y_train[i])
   plt.imshow(X_train[i].reshape((8,8)))
   plt.show()
   #plt.pause(2)