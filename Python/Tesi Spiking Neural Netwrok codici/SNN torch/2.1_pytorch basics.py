
import torch
import numpy as np

#la rete ha un solo neurone che riceve in ingresso un valore e deve dare in uscita il doppio, inizialmente w=0 
x=torch.tensor([1,2,3,4])
y=torch.tensor([2,4,6,8])

w=torch.tensor(0.0, requires_grad=True)

#funzione forward pass
def forward(x):
    return w*x

#funzione che calcola la loss
def loss(y, y_predicted):
    return ((y_predicted-y)**2).mean()



#TRAINING

learning_rate=0.01
n_iters=10

for epoch in range(n_iters):
    # calcolo in valore attuale
    y_pred=forward(x) 

    #calcolo la loss
    l=loss(y,y_pred)

    #backward
    l.backward() #esegue il gradiente di l

    with torch.no_grad(): #prima di eseguire operazioni su w dobbiamo disattivare la funzione autograd altrimenti utilizzera anche queste oiperazioni per il gradiente
        w-=learning_rate*w.grad

    w.grad.zero_()


    print(f'epoch {epoch+1}:loss={l:.4f}')
