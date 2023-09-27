#include <stdio.h>
int main() {
    int base;
    int altezza;
    float area;
    printf("Inserisci una base strettamente positiva -> ");
    scanf("%d", &base);
    while (base <= 0) {
        printf("%d\n", base);
        printf("Somaro! Base positiva! \n");
        printf("Riprova, sarai più fortunato... ");
        scanf("%d", &base);
    }
    do {
        printf("Inserisci un'altezza strettamente positiva -> ");
        scanf("%d", &altezza);
        if (altezza <= 0) {
            printf("Somaro! Altezza positiva!\n");
            printf("Riprova, sarai più fortunato...\n");
        }
    } while (altezza<=0);
    printf("Valori inseriti: %d %d \n", base, altezza);
    area = (base*altezza)/2.0;
    printf("Area calcolata: %.1f\n", area);
}
