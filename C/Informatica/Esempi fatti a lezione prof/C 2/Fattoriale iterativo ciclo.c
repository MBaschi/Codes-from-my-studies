#include <stdio.h>

int main() {
    
    int n;
    int fattoriale = 1;
    int inserito;
    
    printf("Inserisci un valore -> ");
    scanf("%d", &n);
    while(n<0) {
        printf("Serve un numero maggiore o uguale a zero. Riprova -> ");
        scanf("%d", &n);
    }
    
    inserito = n;
    
    if (n==0 || n==1) {
        printf("Fattoriale di %d -> \n", fattoriale);
        //return 0;
    }
    else {
        //tutto il resto qui...
        fattoriale = n;
        n = n-1;
        while(n>=2) {
            fattoriale = fattoriale * n;
            n = n-1;
        }
        printf("Fattoriale di %d -> %d\n", inserito, fattoriale);
    }
    

    
    
}
