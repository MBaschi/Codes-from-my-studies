import numpy as np

#la rete ha un solo neurone che riceve in ingresso un valore e deve dare in uscita il doppio, inizialmente w=0 
x=np.array([1,2,3,4])
y=np.array([2,4,6,8])

w=0

#funzione forward pass
def forward(x):
    return w*x

#funzione che calcola la loss
def loss(y, y_predicted):
    return ((y_predicted-y)**2).mean()

#gradiente calcolato analiticamente
def gradient(x,y,y_predicted):
    return np.dot(2*x, y_predicted-y).mean()

#TRAINING

learning_rate=0.01
n_iters=10

for epoch in range(n_iters):
    # calcolo in valore attuale
    y_pred=forward(x) 

    #calcolo la loss
    l=loss(y,y_pred)

    #gradiente
    dw=gradient(x,y,y_pred)

    #aggiorno w
    w-=learning_rate*dw

    print(f'epoch {epoch+1}:loss={l:.4f}')
