#include <stdio.h>
#include <string.h>
#define N 6

typedef struct{
    char nome[20];
    char cognome[20];
    char sesso[10];
    int NumVoli;
}manager_t;

// FUNZIONI

void scanManager(manager_t * pointer) {
    printf("\nNome->");
    scanf("%s", pointer->nome);
    printf("\nCognome->");
    scanf("%s", pointer->cognome);
    printf("\nSesso->");
    scanf("%s", pointer->sesso);
    printf("\nNumero Voli->");
    scanf("%d", &pointer->NumVoli);
    
}






//MAIN

int main() {
    manager_t array[N];
    int scelta= 0;
    char conferma[3];
    do {printf("***********MENU'************");
        printf("Premere:\n");
        printf("1) Per inserire un nuovo manager nell'array\n");
        printf("2) Per stampare il nome e cognome dei manager che hanno un mumero dei voli maggiore di 20\n");
        printf("3) Per controllare chi tra i manager donna e i manager uomini ha una media complessiva più alta\n->");
        printf("4) Per uscire dal menù\n");
        scanf("%d", &scelta);
        switch (scelta) {
            case 1:
                for (int i=0; strcmp(conferma, "no") != 0 && i<N; i++)
                {
                    printf("Nuovo manager-> ");
                    scanManager(&array[i]);
                    printf("Nuovo manager-> ");                    scanf("%s", conferma);
                }
                break;
          
            default:
                printf("Valore inserito non valido, riprova\n");
                break;
        }
    } while (scelta != 4);
    printf("Fine programma\n");
    return 0;
}
