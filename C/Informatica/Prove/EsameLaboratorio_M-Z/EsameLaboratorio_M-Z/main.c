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


////FUNZIONI PROTOTIPI////
void stampaLista(ptrParola lista);
ptrParola inserimentoFondo(ptrParola testa,char string[]);
ptrParola removeProibite(ptrParola testa, char *stringa);

/////MAIN/////
int main(int argc, const char * argv[]) {
    int r,i;
    char string[20];
    ptrParola parole = NULL; //inizializzo a NULL
    char proibite[5][20];
    strcpy(proibite[0],"pippo");
    strcpy(proibite[1],"pluto");
    strcpy(proibite[2],"hello");
    strcpy(proibite[3],"paolo");
    strcpy(proibite[4],"ciao");
    
    do{
        printf("MENU\n1) Inserisci nuova parola\n2) Cancella proibite\n3) Stampa lista\n4) Esci\n\n>> ");
        scanf("%d",&r);
        switch (r) {
            case 1:
                printf("\n** Inserisci nuova parola:\n");
                printf("Parola da inserire -> ");
                scanf("%s", string);
                parole = inserimentoFondo(parole,string);
                printf("\n>> Stampa lista:\n");
                stampaLista(parole);
                printf("\n\n");
                break;
                
            case 2:
                printf("Eliminazione parole proibite dalla lista->\n");
                for(i=0; i<5; i++){
                parole = removeProibite(parole,proibite[i]);
                }
                stampaLista(parole);
                printf("\n\n");
                break;
                
            case 3:
                printf("Stampa lista->\n");
                stampaLista(parole);
                printf("\n\n");
                break;
                
            default:
                if (r != 4)
                    printf("\nValore inserito non valido!\n");
                break;
        }
    }while(r!=4);
    return 0;
}


////FUNZIONI////

void stampaLista(ptrParola lista){
    if (lista==NULL)
        return;
    printf("%s ",lista->parola);
    stampaLista(lista->next);
}
    
ptrParola inserimentoFondo(ptrParola testa,char string[]) {
    ptrParola currentTail = testa;
    ptrParola nuovo = (ptrParola) malloc(sizeof(parola));
    nuovo->next = NULL;
    ptrParola nuovoElemento = (ptrParola) malloc(sizeof(parola));
    nuovoElemento->next = NULL;
    strcpy(nuovoElemento->parola, string);
    
    // Caso di lista inizialmente vuota
    if (testa == NULL) {
        strcpy(nuovo->parola, "Sebastiano Scrofani");
        nuovo->next = nuovoElemento;
        return nuovo;
    }
    // Caso di lista non vuota
    while (currentTail->next != NULL) {
        currentTail = currentTail->next;
    }
    currentTail->next = nuovoElemento;
    return testa;
}


ptrParola removeProibite(ptrParola testa, char *stringa) {
        ptrParola previousNode = NULL;
        ptrParola currentNode = testa;
        ptrParola head = testa;
        
        while (currentNode != NULL) {
            if ( (strcmp(currentNode->parola, stringa)==0)) {
                // L'elemento era in prima posizione
                if (previousNode == NULL) {
                    head = currentNode->next;
                }
                // L'elemento NON era in prima posizione
                else {
                    previousNode->next = currentNode->next;
                }
                currentNode = currentNode->next;
            } else {
                previousNode = currentNode;
                currentNode = currentNode->next;
            }
        }
        return head;
}
