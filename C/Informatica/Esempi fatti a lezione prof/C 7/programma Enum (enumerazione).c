#include <stdio.h>

typedef enum {blu=1, nera, rossa, verde} penna;
//typedef enum {falso, vero} booleano;


int main() {
    
    penna p1;
    
    do {
        
        printf("Inserisci un numero compreso tra 1 e 4 -> ");
        scanf("%d", &p1);
        
        switch (p1) {
            case blu:
                printf("Blu\n");
                break;
            case nera:
                printf("Nera\n");
                break;
            case rossa:
                printf("Rossa\n");
                break;
            case verde:
                printf("Verde\n");
                break;
            default:
                printf("Inserimento non valido\n");
        }
    } while (p1 >= blu && p1 <= verde);
}
