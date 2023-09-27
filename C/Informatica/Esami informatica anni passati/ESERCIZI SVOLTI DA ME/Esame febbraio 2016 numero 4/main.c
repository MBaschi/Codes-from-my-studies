#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct bike_s {
    int inizioUtilizzo;  //AAAAMMGG
    int fineUtilizzo;
    int stazionePartenza;
    int stazioneArrivo;
    int idBici;
    int annoUtente;
    struct bike_s* next;
} node_t;

typedef node_t* ptrNode;

typedef struct{
    int etaMinima;
    int etaMassima;
    int numeroUtilizzi;
    int mediaUtilizzi;
    ptrNode listaUtilizzi;
}fasciaEta;


ptrNode inizializzaLista(ptrNode testa, int inizioutilizzo);


void stampalista(ptrNode testa);


void generaArray(ptrNode testa, fasciaEta arr[]);


int main() {
    
    int inizioUtilizzo;
    ptrNode testa = NULL;
    char boole[3];
    fasciaEta array[6];
    
    printf("Si desidera inserire i dati per una nuova bici? Digitare 'si' o 'no':\n");
    scanf("%s", boole);
    while(boole[0] == 'S' || boole[0] == 's') {
        printf("Inserisci l'inizio utilizzo della bici che vuoi inserire ->");
        scanf("%d", &inizioUtilizzo);
        testa = inizializzaLista(testa, inizioUtilizzo);
        printf("Si desidera inserire i dati per una nuova bici? Digitare 'si' o 'no':\n");
        scanf("%s", boole);
    }
    
    stampalista(testa) ;
    
    generarray(testa, array);
    
    return 0;
}



ptrNode inizializzaLista(ptrNode testa, int inizioUtilizzo) {
        ptrNode nuovoElemento;
        if (testa != NULL && testa->inizioUtilizzo < inizioUtilizzo) {
            testa->next = inizializzaLista(testa->next, inizioUtilizzo);
            return testa;
        } else {
            nuovoElemento = (ptrNode)malloc(sizeof(node_t));
            nuovoElemento->inizioUtilizzo = inizioUtilizzo;
            printf("Inserisci la fine dell'utilizzo della bici ->");
            scanf("%d", &nuovoElemento->fineUtilizzo);
            printf("Inserisci la stazione di partenza della bici ->");
            scanf("%d", &nuovoElemento->stazionePartenza);
            printf("Inserisci la stazione di arrivo della bici ->");
            scanf("%d", &nuovoElemento->stazioneArrivo);
            printf("Inserisci l'ID della bici usata->");
            scanf("%d", &nuovoElemento->idBici);
            printf("Inserisci la data di nascita di chi l'ha usata ->");
            scanf("%d", &nuovoElemento->annoUtente);
            
            if (testa != NULL) {
                nuovoElemento->next = testa;
            } else {
                nuovoElemento->next = NULL;
            }
            return nuovoElemento;
        }
}

void stampalista(ptrNode testa) {
    if (testa!=NULL) {
        printf ("BICICLETTA:\n");
        printf ("inizio utilizzo  -> %d \n", testa->inizioUtilizzo);
        printf ("fine utilizzo    -> %d \n", testa->fineUtilizzo);
        printf ("stazione partenza-> %d \n", testa->stazionePartenza);
        printf ("stazione arrivo  -> %d \n", testa->stazioneArrivo);
        printf ("ID bici          -> %d \n", testa->idBici);
        printf ("data nascita     -> %d \n", testa->annoUtente);
        
        if (testa->next != NULL) {
            printf("\n\n--> altra bici -->\n\n");
            }
            stampalista(testa->next);
        } else {
            printf("-------END-------\n Fine bici inserite.\n");
        }
}

void generaArray(ptrNode testa, fasciaEta arr[]){
    arr[0].etaMinima = 16;
    arr[0].etaMassima = 19;
    arr[0].listaUtilizzi = creaLista(testa);
        
        
        
    }
}


