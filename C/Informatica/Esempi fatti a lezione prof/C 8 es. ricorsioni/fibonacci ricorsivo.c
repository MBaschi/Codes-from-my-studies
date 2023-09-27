#include <stdio.h>
#define N 100

int fibonacci(int n, int *attivazioni);
int fibonacciConCache(int n, int* attivazioni, int cache[N]);

int main() {
    
    int valoreLetto;
    int risultato;
    int numAttivazioni;
    int cache[N];
    int i;
    
    for (i=2; i<N; i++) {   //la serie di fibonacci la metto in un array
        cache[i] = -1;      //e i primi due elementi cache[0] e cache[1]
    }                       //li inizializzo al valore uno, tutti gli altri
    cache[0] = 1;           //fino a cache[99] valgono -1
    cache[1] = 1;
    
    printf("Inserisci un valore -> ");
    scanf("%d", &valoreLetto);
    
    numAttivazioni=0;
    risultato = fibonacci(valoreLetto, &numAttivazioni);
    printf("Risultato -> %d\n", risultato);
    printf("Numero di attivazioni senza cache -> %d\n", numAttivazioni);
    
    numAttivazioni = 0;
    risultato = fibonacciConCache(valoreLetto, &numAttivazioni, cache);
    printf("Risultato -> %d\n", risultato);
    printf("Numero di attivazioni con cache -> %d\n", numAttivazioni);
    
}

int fibonacci(int n, int *attivazioni) {
    
    *attivazioni = *attivazioni + 1;
    
    //Primo caso base
    if (n==0) {
        return 1;
    }
    //Secondo caso base
    if (n==1) {
        return 1;
    }
    //Passi ricorsivi
    return fibonacci(n-1, attivazioni) + fibonacci(n-2, attivazioni);
}

int fibonacciConCache(int n, int* attivazioni, int cache[N]) {
    
    printf("Attivazione di f(%d).\n", n);
    
    *attivazioni = *attivazioni + 1;
    
    //caso base
    if (cache[n] != -1) {
        return cache[n];
    }
    
    cache[n] = fibonacciConCache(n-1, attivazioni, cache) + cache[n-2];
    
    return cache[n];
}


