#include <stdio.h>

int main() {
    
    int inserito;
    int potenza;
    int numBit;
    int i;
    
    //1. chiedi il valore da convertire
    printf("Inserisci il valore da inserire -> ");
    scanf("%d", &inserito);
    
    //2. calcola numBit
    potenza = 1;
    numBit = 0;
    while(potenza <= inserito) {
        numBit++;
        potenza = potenza*2;
    }
   
    printf("Inserito -> %d\n", inserito);
    printf("NumBit -> %d\n", numBit);
    printf("Potenza -> %d\n", potenza);

    //3. calcola il binario
    potenza = potenza / 2;
   
    i=0;
    while ( i < numBit) {
        
        if (inserito >= potenza) {
            printf("1");
            inserito -= potenza;
        }
        else {
            printf("0");
        }
        
        potenza = potenza / 2;
        i++;
    }
    printf("\n");
    
    return 0;
}
