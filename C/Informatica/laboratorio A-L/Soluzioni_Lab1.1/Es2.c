#include <stdio.h>

int main() {
    
    float prezzo;
    float senzaIva, IVA;
    
    printf("Inserisci il prezzo dell'articolo: ");
    scanf("%f",&prezzo);
    
    printf("Il prodotto ha un prezzo %.1f + IVA %.1f", prezzo/1.22, prezzo-prezzo/1.22);
    return 0;
}
