//
//  main.c
//  prova
//
//  Created by Anna Maria Nestorov on 27/11/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include<stdio.h>
#include <stdlib.h>


#define false 0
#define true 1

struct nodo{
    int info;
    struct nodo *next;
};

typedef struct nodo elementoLista;
typedef elementoLista *listaDiElem;

void inizializza(listaDiElem *lista)
{
    *lista = NULL;
}

int is_empty(listaDiElem lista)
{
    if (lista == NULL)
        return true;
    else
        return false;
}

void stampa_lista(listaDiElem lista)
{
    if (!is_empty(lista)) {
        printf ("%d -> ", lista->info);
        stampa_lista(lista->next);
    }
    else
        printf ("NULL\n");
}

void inserisciInTesta(listaDiElem *lista , int dato)
{
    elementoLista *punt;
    punt = (elementoLista *)malloc(sizeof(elementoLista));
    punt->next = *lista;
    punt->info = dato;
    *lista = punt;
}
/*
 //VERSIONE ITERATIVA
 int ricercaElemento(int num, listaDiElem lista){
 while (lista!=NULL){
 if(num == lista->info)
 return true;
 else
 lista=lista->next;
 }
 return false;
 }
 */

int ricercaElemento(int num, listaDiElem lista){
    if (lista==NULL)
        return false;
    else{
        if (num == lista->info)
            return true;
        else
            return(ricercaElemento(num, lista->next));
    }
}

/*
 //VERSIONE ITERATIVA
 int calcolaLunghezza(listaDiElem lista){
 int somma=0;
 while (lista!=NULL){
 somma++;
 lista=lista->next;}
 return somma;
 }
 */

int calcolaLunghezza(listaDiElem lista){
    if (lista==NULL)
        return(0);
    else
        return(1 + calcolaLunghezza(lista->next));
    
}

void eliminaInteraLista(listaDiElem *lista){
    elementoLista *prec,*corrente;
    prec = *lista;
    while(prec){
        corrente=prec->next;
        free(prec);
        prec=corrente;
    }
    *lista=NULL;
}

int main(int argc, const char * argv[]) {
    
    listaDiElem miaLista;
    int uscita = false;
    int scelta, dato;
    
    inizializza (&miaLista);
    
    while (!uscita) {
        printf ("\n ****************** MENU ****************** \n");
        printf ("1. Visualizza elementi della lista\n");
        printf ("2. Inserisci elemento in testa alla lista\n");
        printf ("3. Ricerca elemento\n");
        printf ("4. Calcolare la lunghezza della lista\n");
        printf ("5. Elimina lista\n");
        printf ("0. Esci dal programma\n");
        printf ("\nScelta: ");
        scanf ("%d", &scelta);
        
        switch (scelta) {
            case 1: // Visualizza elementi della lista
                printf ("\nStampa della lista:\n");
                stampa_lista(miaLista);
                break;
            case 2:
                printf ("Inserire elemento (numero intero): ");
                scanf ("%d", &dato);
                inserisciInTesta (&miaLista, dato);
                break;
            case 3:
                printf("Inserisci elemento da cercare (numero intero): ");
                scanf("%d", &dato);
                if(ricercaElemento(dato, miaLista))
                    printf("Il numero %d è presente nella lista. \n", dato);
                else
                    printf("Il numero %d NON è presente nella lista. \n", dato);
                break;
            case 4:
                printf("La lunghezza della lista è pari a %d. \n",calcolaLunghezza(miaLista));
                break;
            case 5:
                eliminaInteraLista(&miaLista);
                printf("Lista eliminata con successo!");
                break;
            case 0: // Esci dal programma printf ("Uscita...\n"); uscita = true;
                break;
            default:
                printf ("Opzione non riconosciuta...\n");
                break;
        }
    }
}
