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
 
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct nodo{
    char parola[20];
    struct nodo *next;
} parola;

typedef parola *ptrParola;


// Funzioni
ptrParola inserimemtoFondo (ptrParola testa, char string[]);
int crea_stringa (ptrParola testa_parole, ptrParola testa_proibite, char text[]);
void stampa_lista (ptrParola testa);




int main(int argc, const char * argv[]) {
    ptrParola parole = NULL; // testa della lista parole inserite
    ptrParola proibite = NULL; // testa della lista parole proibite
    int r;
    char newText[1000];
    char string[20]; //Questa è la stringa da riempire
    
    newText [0] = '\0'; // all'inizio metto il terminatore alla stringa
    
    char paroleProibite[5][20] = {"mondo","ciao","pippo","pluto","cane"};
    ptrParola temp;
    
    //Riempie la lista di parole proibite
    for (int i=0; i<5; i++)
    {
        temp = (ptrParola)malloc(sizeof(parola));
        strcpy(temp->parola,paroleProibite[i]);
        temp->next = proibite;
        proibite = temp;
    }
    
    do{
        printf("MENU\n1) Inserisci nuova parola\n2) Crea stringa\n3) Stampa stringa\n4) Esci\n\n>> ");
        scanf("%d",&r);
        
        switch (r) {
            case 1:
                printf("\n** Inserisci nuova parola:\n");
                printf("Parola da inserire -> ");
                scanf("%s", string);
                
                parole = inserimemtoFondo(parole, string);
                printf("\n>> Stampa lista:\n");
                stampa_lista(parole);
                printf("\n\n\n");
                break;
                
            case 2:
                printf("\n** Crea stringa:\n");
                if (crea_stringa(parole, proibite, newText)) // controlla che la stringa sia stata creata con successo
                    printf("\nStringa creata!\n\n\n");
                
                break;
                
            case 3:
                
                printf("\n>> Stampa stringa newText:\n\n%s.\n\n", newText);
                break;
                
            default:
                if (r != 4)
                    printf("\nValore inserito non valido!\n\n");
                break;
        }
    }while(r!=4);
    return 0;
}

// ********************FUNZIONI*********************



// Funzione 1: Inserimento in coda
ptrParola inserimemtoFondo (ptrParola testa, char string[])
{
    ptrParola nuovo_elemento = NULL;
    
    if (testa == NULL) // caso base, lista vuota o arrivati in fondo
    {
        nuovo_elemento = (ptrParola)malloc(sizeof(parola));
        strcpy(nuovo_elemento->parola, string);
        nuovo_elemento->next = NULL; //il nuovo elemento è la coda
        return nuovo_elemento;
    }
    //passo ricorsivo, scorro fino ad arrivare in fondo
    testa->next = inserimemtoFondo(testa->next, string);
    return testa;
}


// Funzione 2: creare stringa
int crea_stringa (ptrParola testa_parole, ptrParola testa_proibite, char text[])
{
    int len, trovata = 0;
    ptrParola pointer_1, pointer_2;
    
    for (pointer_1 = testa_parole; pointer_1 != NULL; pointer_1 = pointer_1->next)
    {
        for (pointer_2 = testa_proibite; pointer_2 != NULL; pointer_2 = pointer_2->next)
        {
            if (strcmp(pointer_1->parola, pointer_2->parola) == 0)
                trovata++;
        }
        if (!trovata)
        {
            len = (int)strlen(text);
            text[len] = ' ';
            strcpy(text + len + 1, pointer_1->parola);
        }
        trovata = 0;
    }
    return 1;
}


// Stampa lista
void stampa_lista (ptrParola testa)
{
    if (testa == NULL) // caso base
        return;
    printf("%s\n", testa->parola);
    stampa_lista(testa->next); // passo ricorsivo, stampa dalla testa alla coda
}
