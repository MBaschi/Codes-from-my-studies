
#include <stdio.h>

int main() {
    
    int nuovo_numero;
    double media;
    int posizione_numero;
    
    posizione_numero=0;
    media=0;
    nuovo_numero = 0;
    
    while (nuovo_numero>=0) {
        printf("inserisci il numero ->");
        scanf("%d", &nuovo_numero);
        if (nuovo_numero<0) {
            break;
        }
       posizione_numero = posizione_numero +1;
       media= (nuovo_numero + media*(posizione_numero-1))/posizione_numero;
       
       printf("La media dei numeri inseriti è %f e i numeri introdotti fino ad ora sono %d\n",media,posizione_numero);
    }
    return 0;
}
