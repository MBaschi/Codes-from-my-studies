#include <stdio.h>

int main() {

    int numero;
    int totale;
    
    totale = 0;
    
    /* Programa con ciclo a condizione iniziale
    printf("\nDammi il prossimo numero: ");
    scanf("%d",&numero);
    while (numero >= 0) {
        totale = totale + numero;
        printf("\nDammi il prossimo numero: ");
        scanf("%d",&numero);
    }
    */
    
    do {
        printf("\nDammi il prossimo numero: ");
        scanf("%d",&numero);
        if (numero >= 0)
        {
            totale = totale + numero;
        }
    } while (numero >= 0);
    printf("\nLa somma vale: %d \n",totale);
    
}
