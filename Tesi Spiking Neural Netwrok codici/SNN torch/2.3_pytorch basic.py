

import torch
import torch.nn as nn

#la rete ha un solo neurone che riceve in ingresso un valore e deve dare in uscita il doppio, inizialmente w=0 
x=torch.tensor([[1],[2],[3],[4]], dtype=torch.float32)
y=torch.tensor([[2],[4],[6],[8]], dtype=torch.float32)

n_samples,n_fetaures=x.shape

input_size=n_fetaures
output_size=n_fetaures

model=nn.Linear(input_size, output_size)

#TRAINING

learning_rate=0.01
n_iters=10

loss=nn.MSELoss() #mean square error
optimizer=torch.optim.SGD(model.parameters(),lr=learning_rate)

for epoch in range(n_iters):
    # calcolo in valore attuale
    y_pred=model(x) 

    #calcolo la loss
    l=loss(y,y_pred)

    #backward
    l.backward() #esegue il gradiente di l

    #update weigth 
    optimizer.step()

    optimizer.zero_grad()


    print(f'epoch {epoch+1}:loss={l:.4f}')
