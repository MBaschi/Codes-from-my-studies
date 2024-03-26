#include <stdio.h>

double modulo(double variabile) {
    if (variabile < 0) variabile = -variabile;
    return variabile;
}

int main() {
    
    double x; // Variabile che conterrà il numero fornito dall'utente
    // double risultato; // Variabile che conterrà il risultato -> Modulo
    
    /* Primo codice che abbiamo scritto: così così
    // 1. Acquisire il numero dall'utente
    printf("Dammi il numero per il quale calcolare il modulo: ");
    scanf("%lf",&x);
    // printf("\n x = %f\n",x);
    
    // 2. È maggiore o uguale a zero?
    if (x >= 0)
    //   2.1 Se sì, il modulo è uguale al numero dato dall'utente
        risultato = x;
    //   2.2 Se no, il modulo è pari a - il numero dato dall'utente
      else
        risultato = - x;
    // 3. Stampa il risultato
    printf("\nIl modulo di %f è %f.\n",x,risultato);
 */
    // Secondo codice

    // 1. Acquisire il numero dall'utente
    printf("Dammi il numero per il quale calcolare il modulo: ");
    scanf("%lf",&x);

    // 2. Se minore di zero, cambia segno
    // if (x < 0) x = - x;

    x = modulo(x);
    
    // 3. Stampa il risultato
    printf("\nIl modulo è %f.\n",x);
    
}
