import numpy as np
import matplotlib.pyplot as plt
import json
from sklearn.metrics import ConfusionMatrixDisplay

conf_matrix=[[25 , 0,  1,  7], 
 [20 , 0,  0, 14],
 [17  ,0  ,6 ,10],
 [ 0 , 0  ,0 , 0]] 


disp=ConfusionMatrixDisplay(np.array(conf_matrix))
disp.plot()
plt.show()
DATA_PATH = r"C:\Users\mbasc\OneDrive - Politecnico di Milano\Tesi\image_recognition\FA test\Decolle.json"

with open(DATA_PATH, "r") as fp:
    data = json.load(fp)
accuracy = np.array(data["accuracy"])


e=0
for i in range(5):
    plt.plot(e,np.array(data["accuracy"][i]))
    plt.xlabel("Epoch")
    plt.ylabel("Accuracy")
    plt.xticks(e)

plt.show()