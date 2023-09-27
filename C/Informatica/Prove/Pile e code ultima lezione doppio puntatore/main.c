/* #include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define N 20

typedef struct elem {
    char lettera;
    struct elem* next;
} elemento;

typedef elemento* ptrElemento;

void visualizzaPila(ptrElemento testa);
void push(ptrElemento *testa, char daInserire);      ///doppio puntatore
char pop(ptrElemento *testa, int *error);

int main() {
    char parola[N] = "xabbac";
    ptrElemento testaMain = NULL;
    int i;
    int len;
    int error;
    char restituito;
    
    
    len = (int)strlen(parola);
    for (i=0; i<len; i++) {
        push(&testaMain, parola[i]);
    }
    
    visualizzaPila(testaMain);
    printf("\n");
    
    restituito = pop(&testaMain, &error);
    
    if (error == 0) {
        printf("restituito -> %c \n", restituito);
        visualizzaPila(testaMain);
        printf("\n");
    } else {   //gestisco l'errore
        printf("C'è stato un errore. Restituito-> %c \n", restituito);
    }
    
    return 0;
}

void visualizzaPila(ptrElemento testa) {
    if (testa == NULL) {
        return;
    }
    printf(" %c ", testa->lettera);
    visualizzaPila(testa->next);
}

void push(ptrElemento *testa, char daInserire) {   //inserisci un elemento in prima posizione
    ptrElemento nuovoElemento;
    nuovoElemento = malloc(sizeof(elemento));
    nuovoElemento->lettera = daInserire;
    nuovoElemento->next = *testa;                  //ora il nuovo puntatore punta come testa
    
    *testa = nuovoElemento;
}

char pop(ptrElemento *testa, int *error) {         //rimuovi il primo elemento puntato da testa
    
    char daRestituire;
    ptrElemento temp;
    
    if (*testa == NULL) {                          //gestione caso NULL e restituisco l'errore
        *error = 1;
        return 'z';
    }
    
    daRestituire = (*testa)->lettera;              //daRestitiure = (*(*testa)).lettera;
    temp =  (*testa)->next;                        //temp = (*(*testa)).next
    free(*testa);
    *error = 0;
    *testa = temp;
    return daRestituire;
}*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define N 20

typedef struct elem {
    char lettera;
    struct elem* next;
} elemento;

typedef elemento* ptrElemento;

void visualizzaPila(ptrElemento testa);
void push(ptrElemento *testa, char daInserire);      ///doppio puntatore
char pop(ptrElemento *testa, int *error);

void main(void) {
    char parola[N] = "xabbac";
    ptrElemento testaMain = NULL;
    int i;
    int len;
    int error=0;
    char restituito;
    
    
    len = (int)strlen(parola);
    for (i=0; i<len; i++) {
        push(&testaMain, parola[i]);
    }
    
    visualizzaPila(testaMain);
    printf("\n");
    
    
    for (i=0; i<len; i++) {
        restituito= pop(&testaMain, &error);
        if (error ==1 || parola[i] != restituito) {
            printf("La parola NON è palindroma!\n");
            return;
        }
    }
    if (error==0) {
    printf("La parola è palindroma!\n");
    }
}

void visualizzaPila(ptrElemento testa) {
    if (testa == NULL) {
        return;
    }
    printf(" %c ", testa->lettera);
    visualizzaPila(testa->next);
}

void push(ptrElemento *testa, char daInserire) {   //inserisci un elemento in prima posizione
    ptrElemento nuovoElemento;
    nuovoElemento = malloc(sizeof(elemento));
    nuovoElemento->lettera = daInserire;
    nuovoElemento->next = *testa;                  //ora il nuovo puntatore punta come testa
    
    *testa = nuovoElemento;
}

char pop(ptrElemento *testa, int *error) {         //rimuovi il primo elemento puntato da testa
    
    char daRestituire;
    ptrElemento temp;
    
    if (*testa == NULL) {                          //gestione caso NULL e restituisco l'errore
        *error = 1;
        return 'z';
    }
    
    daRestituire = (*testa)->lettera;              //daRestitiure = (*(*testa)).lettera;
    temp =  (*testa)->next;                        //temp = (*(*testa)).next
    free(*testa);
    *error = 0;
    *testa = temp;
    return daRestituire;
}
