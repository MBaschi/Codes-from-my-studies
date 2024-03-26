from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
data = load_wine()
import matplotlib.pyplot as plt
X_train, X_test, y_train, y_test = train_test_split( data.data, data.target, test_size=0.33, random_state=42)
scaler = MinMaxScaler()
X_scaled=scaler.transform(X_train)
input("bal")
for i in range(1000):
   plt.clf()
   print(y_train[i]) #qualità vino
   plt.plot(X_scaled[i])
   plt.pause(1)

""""
1 - fixed acidity
2 - volatil acidity
3 - citric acid
4 - residual sugar
5 - chlorides
6 - free sulfur dioxide
7 - total sulfur dioxide
8 - density
9 - pH
10 - sulphates
11 - alcohol
Output variable (based on sensory data):
12 - quality (score between 0 and 10)
"""