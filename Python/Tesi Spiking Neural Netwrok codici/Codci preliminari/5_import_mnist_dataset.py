print("////////////////////////////////")
from keras.datasets import mnist
from matplotlib import pyplot
 
#loading
(train_X, train_y), (test_X, test_y) = mnist.load_data()

#train=foto per l'aellenamento
#test=dataset per il test
#train_x= vettore 6000x24x24=6000 immagine di dimensione 28x28
#train_y=vettore che contiene il numero corrispondente a ciascuna delle 60000 immagini
 


#shape of dataset
print('X_train: ' + str(train_X.shape[0]))
print('Y_train: ' + str(train_y.shape[0]))
print('X_test:  '  + str(test_X.shape[2]))
print('Y_test:  '  + str(test_y.shape))

print(train_X[1])
#plotting
from matplotlib import pyplot
for i in range(9):  
 pyplot.subplot(330 + 1 + i)
 pyplot.imshow(train_X[i],cmap=pyplot.get_cmap('gray') )
pyplot.show()


print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")