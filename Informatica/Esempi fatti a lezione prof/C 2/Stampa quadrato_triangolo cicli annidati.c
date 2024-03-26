#include <stdio.h>

int main() {
    
    int n;
    int i; //variabile contatore
    int j;
    int numSpazi;
    int numAsterischi;
    
    printf("Inserisci il valore di n -> ");
    scanf("%d", &n);
    
    //stampo un quadrato nxn
    
    i=0;
    while (i<n) {
        //stampa 1 riga
        j=0;
        while (j<n) {
            //stampo '*'
            printf(" * ");
            j++;
        }
        //stampo '\n'
        printf("\n");
        i++;
    }
    
    
    // stampo un triangolo
    
    i=0;
    while (i<6) {
        //stampo riga i-esima
        numSpazi = 5-i;
        numAsterischi = 11 - 2*numSpazi;
        j=0;
        while (j<numSpazi) {
            printf("   ");
            j++;
        }
        j=0;
        while (j<numAsterischi) {
            printf(" * ");
            j++;
        }
        printf("\n");
        i++;
    }
}
