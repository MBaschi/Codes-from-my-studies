
#include <stdio.h>

int main() {
    int base, esp, risultato;
    
    risultato = 0;
    printf("Inserisci base: ");
    scanf("%d",&base);
    printf("Inserisci esponente: ");
    scanf("%d",&esp);
    
    if (esp == 0)
        risultato = 1;
    else if (esp == 1)
        risultato = base;
    else{
        risultato = base;
        for (int i=1; i<esp; i++)
            risultato = risultato * base;
    }
    printf ("Il risultato è: %d\n", risultato);
    return 0;
}
