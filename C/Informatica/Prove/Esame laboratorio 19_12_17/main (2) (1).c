/*
 L'esame ha una durata di 1,5 ore.
 
 Partendo dal codice seguente, creare due funzioni per:
 
 1. Inserisci dopo il primo nodo. Il primo nodo contiene sempre il nome dell'autore del programma e viene inserito sempre automaticamente alla creazione di una nuova lista. Questa funzione NON deve essere ricorsiva.
 2. Cancellare dalla lista tutti i nodi che contengono le parole proibite elencate nell'array "proibite".

 Scrivere inoltre tutto il codice necessario per verificare il corretto funzionamento delle funzioni appena create.
 
 
 Valutazione:
 Funzione 1: 1 punto
 Funzione 2: 1 punti
 Implementazione del codice necesario: 1 punti
 
 Per iniziare a lavorare, scaricare uno dei file seguenti (main.c o main.txt); aprirlo (anche con notepad) e copiare il contenuto in Code:blocks (o altri IDE).
 E' possibile copiare anche il codice qui di seguti, copiare da schoology direttamente il testo potrebbe inserire degli errori di battitura (", spazi ecc).
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct nodo{
    char parola[20];
    struct nodo *next;
} parola;
typedef parola *ptrParola;

void stampaLista(ptrParola lista);


int main(int argc, const char * argv[]) {
    int r;
    ptrParola parole = NULL;
    char proibite[5][20];
    strcpy(proibite[0],"pippo");
    strcpy(proibite[1],"pluto");
    strcpy(proibite[2],"hello");
    strcpy(proibite[3],"paolo");
    strcpy(proibite[4],"ciao");
    
    do{
        printf("\nMENU\n1) Inserisci nuova parola\n2) Cancella proibite\n3) Stampa lista\n4) Esci\n\n>> ");
        scanf("%d",&r);
        
                
        
        
        
        
        
        
        
        
        
    }while(r!=4);
    return 0;
}


void stampaLista(ptrParola lista){
    if (lista==NULL)
        return;
    printf("%s ",lista->parola);
    stampaLista(lista->next);
}
