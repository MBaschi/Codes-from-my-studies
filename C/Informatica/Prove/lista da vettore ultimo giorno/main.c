#include <stdio.h>
#include <stdlib.h>
#define N 10

typedef struct elem{
    int val;
    int num;
    struct elem* next;
}elemento;

typedef elemento* ptrElemento;

void zip(ptrElemento *testa, int v[]);
void addToList(ptrElemento *testa, int val, int num);

int main() {
    int v[N] = {3,3,3,4,4,1,2,5,5,5};
    
   
    
    
    return 0;
}


void addToList(ptrElemento *testa, int val, int num) {  ///
    ptrElemento nuovoElemento;
    ptrElemento scorri;
    nuovoElemento = malloc(sizeof(elemento));
    nuovoElemento->num = num;
    nuovoElemento->val = val;
    nuovoElemento->next = NULL;
    
    if (*testa == NULL) {
        *testa = nuovoElemento;
        return;
    }
    
    scorri = *testa;
    while (scorri->next != NULL) {
        scorri = scorri->next;
    }
    scorri->next = nuovoElemento;
}


void zip(ptrElemento *testa, int v[]) {
    int i;
    int cont;
    
    i=0;
    cont=1;
    
    while (i<N-1) {
        if (v[i]==v[i+1]) {
            cont++;
        } else {
            addToList(testa, v[i], cont);
            cont = 1;
        }
        i++;
    }
    addToList(testa, v[i], cont);      ////l'ultimo numero rischio di non controllarlo!!}







