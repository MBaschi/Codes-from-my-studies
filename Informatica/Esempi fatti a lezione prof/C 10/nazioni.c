#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct el{
    char nome[20];
    char nazione[20];
    int popolazione;
    struct el *next;
} elemento;
typedef elemento *ptrElemento;

int confronto(elemento citta1, elemento citta2);
ptrElemento inserimento(ptrElemento testa, elemento nuovaCitta);
ptrElemento rimuovi(ptrElemento testa, char *nazione);
void visualizzaLista(ptrElemento testa);

int main() {
    elemento temp1;
    elemento temp2;
    //int ris;
    ptrElemento testaMain = NULL;
    
    strcpy(temp1.nazione, "Grecia");
    strcpy(temp1.nome, "Atene");
    temp1.popolazione = 1000;
    
    strcpy(temp2.nazione, "Italia");
    strcpy(temp2.nome, "Bergamo");
    temp2.popolazione = 800;
    
    //ris = confronto(temp2, temp1);
    //printf("%d\n", ris);
    
    testaMain = inserimento(testaMain, temp1);
    strcpy(temp1.nazione, "Italia");
    strcpy(temp1.nome, "Milano");
    temp1.popolazione = 1000;
    testaMain = inserimento(testaMain, temp1);
    
    strcpy(temp1.nazione, "Italia");
    strcpy(temp1.nome, "Roma");
    temp1.popolazione = 1000;
    testaMain = inserimento(testaMain, temp1);
    
    strcpy(temp1.nazione, "Italia");
    strcpy(temp1.nome, "Bergamo");
    temp1.popolazione = 1000;
    testaMain = inserimento(testaMain, temp1);
    
    strcpy(temp1.nazione, "Grecia");
    strcpy(temp1.nome, "Sparta");
    temp1.popolazione = 1000;
    testaMain = inserimento(testaMain, temp1);
    
    testaMain = rimuovi(testaMain, "Italia");
    
    visualizzaLista(testaMain);
    
    
}

int confronto(elemento citta1, elemento citta2) {
    
    int val;
    /*
    if (strcmp(citta1.nazione, citta2.nazione)==0 && strcmp(citta1.nome, citta2.nome)==0) {
        return 0;
    }
     */
    
    val = strcmp(citta1.nazione, citta2.nazione);
    
    if (val<0) {
        return -1;
    }
    else if (val >0) {
        return 1;
    }
    else {
        val = strcmp(citta1.nome, citta2.nome);
        if (val<0) {
            return -1;
        }
        else if (val > 0){
            return 1;
        }
        else {
            return 0;
        }
    }
    
}

void visualizzaLista(ptrElemento testa) {
    if (testa!=NULL) {
        printf("%s\n", testa->nazione);
        printf("%s\n", testa->nome);
        printf("(%d)\n\n", testa->popolazione);
        visualizzaLista(testa->next);
    }
}

ptrElemento inserimento(ptrElemento testa, elemento nuovaCitta) {
    
    ptrElemento prec = NULL;
    ptrElemento scorre = testa;
    ptrElemento nuovoElemento;
    
    nuovoElemento = malloc(sizeof(elemento));
    /*
     nuovoElemento->popolazione = nuovaCitta.popolazione;
     strcpy(nuovoElemento->nazione, nuovaCitta.nazione);
     strcpy(nuovoElemento->nome, nuovaCitta.nome);
    */
    *nuovoElemento = nuovaCitta;
    
    if (scorre==NULL) {
        //la lista originale è vuota
        nuovoElemento->next = NULL;
        return nuovoElemento;
    }
    
    while (scorre!=NULL && confronto(*nuovoElemento, *scorre)>0) {
        prec = scorre;
        scorre = scorre->next;
    }
    
    if (prec == NULL) {
        //inserimento in testa
        nuovoElemento->next = testa;
        return nuovoElemento;
    }
    
    if (scorre==NULL) {
        //inserimento in fondo
        nuovoElemento->next = NULL;
        prec->next = nuovoElemento;
        return testa;
    }
    
    if (confronto(*nuovoElemento, *scorre)==0) {
        //tentativo di inserire un doppione
        free(nuovoElemento);
        return testa;
    }
    
    //inserimento in mezzo...
    
    prec->next = nuovoElemento;
    nuovoElemento->next = scorre;
    return testa;
}

ptrElemento rimuovi(ptrElemento testa, char *nazione) {
    ptrElemento temp;
    if (testa == NULL) {
        return testa;
    }
    if (strcmp(testa->nazione, nazione)==0) {
        //l'elemento in testa è da togliere
        temp = rimuovi(testa->next, nazione);
        free(testa);
        return temp;
    }
    else {
        //l'elemento in testa NON è da togliere
        testa->next = rimuovi(testa->next, nazione);
        return testa;
    }
}


