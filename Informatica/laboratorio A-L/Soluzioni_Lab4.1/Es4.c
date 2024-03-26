/*
Definire una lista contenente solo un numero intero (e tutto il necessario per essere una lista). Scrivere un programma (con menu) che permetta:
1. Inserire un numero intero;
2. Eliminare l’ultimo numero inserito
3. Sommare tutti i numeri (scrivere sia la funzione ricorsiva che iterativa).
*/

#include <stdio.h>
#include <stdlib.h>

typedef struct nodeLista{
  int value;
  struct nodeLista *next;
} nodeLista;

typedef nodeLista *pnodeLista;

pnodeLista inserisciInTesta(pnodeLista lista);
pnodeLista eliminaUltimo(pnodeLista lista);
int sommaLista(pnodeLista lista);
int sommaListaRic(pnodeLista lista);


int main(){
  int r;
  pnodeLista lista = NULL;
  
  do{
    printf("MENU\n\n1) Inserisci un numero intero\n2) Eliminare l'ultimo numero inserito\n3) Sommare tutti i numeri\n4) Esci\n\n>> ");
    scanf("%d",&r);
    switch(r){
      case 1:
        lista = inserisciInTesta(lista);
        break;
      case 2:
      lista = eliminaUltimoInserito(lista);
        break;
      case 3:
        printf("La somma ricorsiva dei numeri inseriti è: %d\n",sommaListaRic(lista));
        printf("La somma dei numeri inseriti è: %d\n",sommaLista(lista));
        break;
      
    }
    
  }while(r!=4);
  return 0;
}

pnodeLista inserisciInTesta(pnodeLista list){
  pnodeLista newNode = (pnodeLista)malloc(sizeof(nodeLista));
  
  printf("Inserisci il numero: ");
  scanf("%d",&newNode->value);
  newNode->next = list;
  return newNode;
}

pnodeLista eliminaUltimoInserito(pnodeLista lista){
  pnodeLista tempNode = lista;
  lista = lista->next;
  free(tempNode);
  return lista;
}

int sommaLista(pnodeLista lista){
  int somma = 0;
  while(lista!=NULL){
    somma += lista->value;
    lista = lista->next;
  }
  return somma;
}

int sommaListaRic(pnodeLista lista){
  if (lista==NULL)
    return 0;
  else
    return lista->value + sommaListaRic(lista->next);
}
