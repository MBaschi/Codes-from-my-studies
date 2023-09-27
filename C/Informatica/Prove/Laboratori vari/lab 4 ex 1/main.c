#include <stdio.h>
#include <stdlib.h>


int prodotto(int a,int b);

int main() {
    int a;
    int b;
    int risultato;
    
    printf("Inserisci i due numeri naturali->");
    scanf("%d%d", &a, &b);
    
    risultato = prodotto(a,b);
    printf("Il risultato è %d\n", risultato);
}

int prodotto(int a,int b) {
    int risultato;
    if (b==0) {
        return 0;
    }
    risultato = a + prodotto(a, b-1);
    return risultato;
}
