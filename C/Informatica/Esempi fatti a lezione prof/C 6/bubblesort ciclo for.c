#include <stdio.h>
#define N 10


int main() {
    int dato[N] = {7, 8, 15, 2, 28, 1, 11, 34, 13, 22};
    int i;
    int j;
    int temp;
    
    for(i=0; i<N-1; i++) {
        for (j=0; j<N-1-i; j++) {
            if (dato[j] > dato[j+1]) {
                temp      = dato[j];
                dato[j]   = dato[j+1];
                dato[j+1] = temp;
            }
        }
    }
    /////STAMPA///////
    for (i=0; i<N; i++) {
        printf(" %d ", dato[i]);
    }
    printf("\n");
}
