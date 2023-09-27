/*
Scrivere una funzione ricorsiva (in C) che, avendo in input un array di n interi, dia in output il numero degli elementi positivi della lista.


Suggerimento: pensare sempre al caso base e al passo ricorsivo per ottenere la soluzione.
*/

#define N 100
#include <stdio.h>

int elementiPositivi(int array[], int n);

int main() {
    int array[N];
    int n;
    printf("Quanti valori vuoi inserire? ");
    scanf("%d",&n);
    
    for (int i=0; i<n; i++)
        scanf("%d", &array[i]);
    
    printf("Il numero di numeri positivi è %d\n",elementiPositivi(array, n));
    
    return 0;
}

int elementiPositivi(int array[], int n){
    if (n==0)
        return 0;
    else{
        if (array[n-1]>0)
            return 1+elementiPositivi(array, n-1);
        else
            return elementiPositivi(array, n-1);
    }
}
