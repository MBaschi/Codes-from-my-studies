#include <stdio.h>
#include <stdlib.h>

typedef struct nodo {
    int dato;
    struct nodo *next;
} node;

typedef node *ptrNode;

void stampaLista(ptrNode testa);

ptrNode inserimentoInTesta(ptrNode testa, int num);
void inserimentoInTestaDoppioPunt(ptrNode *testa, int num);
int dimensione(ptrNode testa);
ptrNode inserimentoInFondo(ptrNode testa, int num);
ptrNode inserimentoOrdinato(ptrNode testa, int num);
ptrNode rimuovi(ptrNode testa, int num);
ptrNode rimuoviPrimoElemento(ptrNode testa, int num);
ptrNode invertiLista(ptrNode testa);

int main() {
    
    ptrNode testaMain = NULL;
    /*
    testaMain = inserimentoInTesta(testaMain, 5);
    testaMain = inserimentoInTesta(testaMain, 3);
    testaMain = inserimentoInTesta(testaMain, 7);
    inserimentoInTestaDoppioPunt(&testaMain, 10);
    testaMain = inserimentoInFondo(testaMain, 15);*/
    
    testaMain = inserimentoOrdinato(testaMain, 3);
    testaMain = inserimentoOrdinato(testaMain, 1);
    testaMain = inserimentoOrdinato(testaMain, 10);
    testaMain = inserimentoOrdinato(testaMain, 7);
    testaMain = inserimentoOrdinato(testaMain, 3);
    testaMain = rimuovi(testaMain, 3);
    testaMain = invertiLista(testaMain);
    
    stampaLista(testaMain);
    printf("\nLunghezza della lista -> %d\n", dimensione(testaMain));
    
    printf("\n");
 
}

void stampaLista(ptrNode testa) {
    if (testa == NULL) {
        return;
    }
    printf(" %d ", testa->dato); //(*testa).dato
    stampaLista(testa->next);
}

ptrNode inserimentoInTesta(ptrNode testa, int num) {
    ptrNode nuovoElemento;
    nuovoElemento = malloc(sizeof(node));
    nuovoElemento->dato = num;
    nuovoElemento->next = testa;
    return nuovoElemento;
}

void inserimentoInTestaDoppioPunt(ptrNode *testa, int num) {
    ptrNode nuovoElemento;
    nuovoElemento = malloc(sizeof(node));
    nuovoElemento->dato = num;
    nuovoElemento->next = *testa;
    *testa = nuovoElemento;
}

int dimensione(ptrNode testa) {
    if (testa == NULL) {
        return 0;
    }
    return 1 + dimensione(testa->next);
}

ptrNode inserimentoInFondo(ptrNode testa, int num) {
    ptrNode nuovoElemento = NULL;
    //caso base
    if (testa==NULL) {
        nuovoElemento = (ptrNode)malloc(sizeof(node));
        nuovoElemento->dato = num;
        nuovoElemento->next = NULL;
        return nuovoElemento;
    }
    //passo ricorsivo
    testa->next = inserimentoInFondo(testa->next, num);
    return testa;
}

ptrNode inserimentoOrdinato(ptrNode testa, int num) {
    
    ptrNode scorri;
    ptrNode prec;
    ptrNode nuovoElemento = NULL;
    
    nuovoElemento = malloc(sizeof(node));
    nuovoElemento->dato = num;
    
    prec = NULL;
    scorri = testa;
    
    while (scorri!=NULL && num>scorri->dato) {
        prec = scorri;
        scorri = scorri->next;
    }
    
    if (prec==NULL) {
        //inserimento in testa
        //inserimento in lista vuota -> anche scorri è NULL
        nuovoElemento->next = scorri;
        return nuovoElemento;
    }
    
    //inserimento in mezzo
    //inserimento in fondo -> scorri è NULL e prec non lo è
    
    nuovoElemento->next = scorri;
    prec->next = nuovoElemento;
    return testa;
}


ptrNode rimuovi(ptrNode testa, int num) {
    ptrNode nuovaTestaSottolista = NULL;
    //caso base
    if (testa == NULL) {
        return NULL;
    }
    
    nuovaTestaSottolista = rimuovi(testa->next, num);
    
    if (testa->dato==num) {
        //devo cancellare il primo elemento
        free(testa);
        return nuovaTestaSottolista;
    }
    else {
        //NON devo cancellare il primo elemento
        testa->next = nuovaTestaSottolista;
        return testa;
    }
}

ptrNode rimuoviPrimoElemento(ptrNode testa, int num) {
    ptrNode temp = NULL;
    //caso base
    if (testa == NULL) {
        return NULL;
    }
    if (testa->dato==num) {
        //devo cancellare il primo elemento
        temp = testa->next;
        free(testa);
        return temp;
    }
    else {
        //NON devo cancellare il primo elemento
        testa->next = rimuoviPrimoElemento(testa->next, num);
        return testa;
    }
}

ptrNode invertiLista(ptrNode testa) {
    
    ptrNode vecchiaTesta =  NULL;
    ptrNode nuovaTesta = NULL;
    //caso base
    if (testa == NULL || testa->next == NULL) {
        return testa;
    }
    vecchiaTesta = testa->next; //vecchiaTesta della sottolista
    nuovaTesta = invertiLista(testa->next);
    vecchiaTesta->next = testa;
    testa->next = NULL;
    return nuovaTesta;
}
