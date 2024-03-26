#include <stdio.h>
#include <stdlib.h>

typedef struct node{
    int numero;
    struct node*next;
}nodo_t;

typedef nodo_t*ptrNodo;
ptrNodo inserimento(ptrNodo testa);

int main(){
    
    ptrNodo testaLista = NULL;
    
    testaLista = inserimento(testaLista);
}
    ptrNodo inserimento(ptrNodo testa)
    {
    ptrNodo nuovoElemento;
        int ins;
    
    printf("Inserisci un numero da salvare nella lista->");
    scanf("%d", &ins);
        
        nuovoElemento=(ptrNodo)malloc(sizeof(nodo_t));
        nuovoElemento->numero=ins;
        nuovoElemento->next=testa;
        
        return nuovoElemento;
    }
