/*
 L'esame ha una durata di 1,5 ore.
 
 Partendo dal codice seguente, creare due funzioni per:
 
 1. Con funzione ricorsiva, crea una nuova lista con le parole della prima sostituendo le parole contenute nell'array dizionario.
 2. Ordina in ordine alfabetico la lista appena creata (può essere fatta ricorsiva o iterativa)
 
 Scrivere inoltre tutto il codice necessario per verificare il corretto funzionamento delle funzioni appena create.
 
 Attenzione, per semplificare, la seconda funzione può essere divisa in due funzioni (Eg. creaLista, ordinaLista).
 
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

typedef struct diz{
    char daSostituire[20];
    char conCuiSostituire[20];
} diz;


void stampaLista(ptrParola lista);
ptrParola inserisciInTesta(ptrParola parole, char text[20]);

int main(int argc, const char * argv[]) {
    ptrParola parole = NULL;
    ptrParola listaOrdinata = NULL;
    char testo[20];
    int r;
    
    //Creazione array dizionario
    diz diz1[5];
    
    strcpy(diz1[0].daSostituire,"mondo");
    strcpy(diz1[1].daSostituire,"ciao");
    strcpy(diz1[2].daSostituire,"pippo");
    strcpy(diz1[3].daSostituire,"pluto");
    strcpy(diz1[4].daSostituire,"cane");
    
    strcpy(diz1[0].conCuiSostituire,"terra");
    strcpy(diz1[1].conCuiSostituire,"saluti");
    strcpy(diz1[2].conCuiSostituire,"topolino");
    strcpy(diz1[3].conCuiSostituire,"paperino");
    strcpy(diz1[4].conCuiSostituire,"gatto");
    
    do{
        printf("\nMENU\n1) Inserisci nuova parola\n2) Crea lista non ordinata\n3) Ordina lista\n4) Esci\n\n>> ");
        scanf("%d",&r);
        
        
        
        
        
        
        
        
       
    }while(r!=4);
    return 0;
}

ptrParola inserisciInTesta(ptrParola parole, char text[20]){
    ptrParola temp = (ptrParola)malloc(sizeof(parola));
    strcpy(temp->parola,text);
    temp->next = parole;
    return temp;
}

void stampaLista(ptrParola lista){
    if (lista==NULL)
        return;
    printf("%s ",lista->parola);
    stampaLista(lista->next);
}

