

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct element {
    char nazione[20];
    char nome[20];
    int popolazione;
    struct element *next;
} elemento;

typedef elemento *ptrElement;

int confronto(elemento citta1, elemento citta2);
void visualizzaLista(ptrElement testa);
ptrElement inserisciCitta(ptrElement testa, char *nazione, char *nome, int popolazione);
ptrElement eliminaNazione(ptrElement testa, char *nazione);

int main() {
    ptrElement testaLista = NULL;
    testaLista = inserisciCitta(testaLista, "Italia", "Milano", 15);
    testaLista = inserisciCitta(testaLista, "Italia", "Bergamo", 10);
    testaLista = inserisciCitta(testaLista, "Italia", "Roma", 20);
    testaLista = inserisciCitta(testaLista, "Italia", "Palermo", 11);
    testaLista = inserisciCitta(testaLista, "Grecia", "Sparta", 8);
    
    testaLista = eliminaNazione(testaLista, "Italia");
    //testaLista = eliminaNazione(testaLista, "Grecia");
    //testaLista = eliminaNazione(testaLista, "Spagna");
    
    visualizzaLista(testaLista);
    
    
    
}

int confronto(elemento citta1, elemento citta2) {
    
    if (strcmp(citta1.nazione, citta2.nazione) == 0 && strcmp(citta1.nome, citta2.nome)==0) {
        //i due elementi sono uguali secondo il criterio indicato
        return 0;
    }
    
    if (strcmp(citta1.nazione, citta2.nazione)<0) {
        return -1;
    }
    else if (strcmp(citta1.nazione, citta2.nazione)>0){
        return 1;
    }
    
    //qui le due nazioni sono uguali e le due città sono diverse...
    
    if (strcmp(citta1.nome, citta2.nome)<0) {
        return -1;
    }
    else {
        return 1;
    }
    
}

void visualizzaLista(ptrElement testa) {
    
    //caso base
    if (testa == NULL) {
        return;
    }
    
    // stampo me stesso (nodo puntato da testa)
    // e ricorsivamente chiedo la stampa del resto della lista (testa->next)
    
    printf("Nazione: %s\n", testa->nazione);
    if (strcmp(testa->nome, "Sparta")==0) {
        printf("Citta': Questa è Sparta!!!!\n");
    }
    else {
        printf("Citta': %s\n", testa->nome);
    }
    printf("Popolazione: %d\n", testa->popolazione);
    printf("######################\n");
    
    visualizzaLista(testa->next);
    
}

ptrElement inserisciCitta(ptrElement testa, char *nazione, char *nome, int popolazione) {
    
    //restituisco la testa della lista modificata...
    
    ptrElement prec;
    ptrElement scorri;
    ptrElement newElem;
    
    prec = NULL;
    scorri = testa;
    
    newElem = (ptrElement)malloc(sizeof(elemento));
    strcpy(newElem->nazione, nazione);
    strcpy(newElem->nome, nome);
    newElem->popolazione = popolazione;
    //manca decidere cosa fare con il suo next...
    
    if (testa==NULL) {
        // la lista è vuota...
        // newElem diventa il primo elemento della lista (ma anche l'ultimo)
        // cambia così la testa della lista
        newElem->next = NULL; // perché è l'ultimo
        return newElem;
    }
    
    while (scorri != NULL && confronto(*newElem, *scorri) > 0) {
        prec = scorri;
        scorri = scorri->next;
    }
    
    if (scorri == NULL) {
        //sono in fondo alla lista
        prec->next = newElem;
        newElem->next = NULL;
        return testa;
    }
    
    if (confronto(*newElem, *scorri)==0) {
        //sto cercando di inserire un doppione
        return testa;
    }
    
    // se sono qui il confronto era negativo
    
    if (prec == NULL) {
        // sto facendo un inserimento in testa
        // non sono mai entrato nel ciclo while
        newElem->next = testa;
        return newElem;
    }
    
    // se sono qui ho un inserimento in mezzo
    
    prec->next = newElem;
    newElem->next = scorri;
    return testa;
  
}

ptrElement eliminaNazione(ptrElement testa, char *nazione) {
    ptrElement temp;

    //caso base
    if (testa == NULL) {
        return testa;
    }
    
    if (strcmp(testa->nazione, nazione)==0) {
        // devo eliminare l'elemento puntato da testa
        temp = testa->next;
        free(testa);
        return eliminaNazione(temp, nazione);
    }
    
    testa->next = eliminaNazione(testa->next, nazione);
    return testa;
}

















