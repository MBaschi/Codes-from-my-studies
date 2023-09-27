/*
 L'esame ha una durata di 1,5 ore.

 Partendo dal codice seguente, creare due funzioni per:
 1. Inserisci in coda un nuovo nodo per la lista parole (funzione ricorsiva);
 2. Creare una stringa di lunghezza massimo 1000 attraverso uno funzione che accoda tutte le stringhe, eccetto alcune parole inserite in una seconda lista già riempita denominata "vietate". Le parole devo essere intervallate da degli spazi " ".
 Scrivere inoltre tutto il codice necessario per verificare il corretto funzionamento delle funzioni appena create.
 
 Valutazione:
 Funzione 1: 1 punto
 Funzione 2: 1,5 punti
 Implementazione del codice necesario: 0,5 punti

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

int main(int argc, const char * argv[]) {
    ptrParola parole = NULL;
    ptrParola proibite = NULL;
    int r;
    char newText[1000]; //Questa è la stringa da riempire
    
    char paroleProibite[5][20] = {"mondo","ciao","pippo","pluto","cane"};
    ptrParola temp;
    
    //Riempie la lista di parole proibite
    for (int i=0; i<5; i++)
    {
        temp = (ptrParola)malloc(sizeof(parola));
        strcpy(temp->parola,paroleProibite[i]);
        temp->next=proibite;
        proibite = temp;
    }
    
    do{
        printf("MENU\n1) Inserisci nuova parola\n2) Crea stringa\n3) Stampa stringa\n4) Esci\n\n>> ");
        scanf("%d",&r);
        
        
        
        
        
        
        
    }while(r!=4);
    return 0;
}


