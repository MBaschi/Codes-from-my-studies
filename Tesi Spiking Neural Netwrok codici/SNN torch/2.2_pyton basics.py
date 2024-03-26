

import torch
import torch.nn as nn

#la rete ha un solo neurone che riceve in ingresso un valore e deve dare in uscita il doppio, inizialmente w=0 
x=torch.tensor([1,2,3,4], dtype=torch.float32)
y=torch.tensor([2,4,6,8], dtype=torch.float32)

w=torch.tensor(0.0, dtype=torch.float32, requires_grad=True)

#funzione forward pass
def forward(x):
    return w*x

#TRAINING

learning_rate=0.01
n_iters=10

loss=nn.MSELoss() #mean square error
optimizer=torch.optim.SGD([w],lr=learning_rate)

for epoch in range(n_iters):
    # calcolo in valore attuale
    y_pred=forward(x) 

    #calcolo la loss
    l=loss(y,y_pred)

    #backward
    l.backward() #esegue il gradiente di l

    #update weigth 
    optimizer.step()

    w.grad.zero_()


    print(f'epoch {epoch+1}:loss={l:.4f}')
