#include <stdio.h>
#define N 10

///ordina i dati di un array in modo crescente

int main() {
    int dato[N] = {7, 8, 15, 2, 28, 1, 11, 34, 13, 22};
    int i;
    int j;
    int temp;
    
    i=0;
    while (i<N-1) {     //ultimo scmabio inutile!!!
        j=0;
        while (j<N-1-i) {
            if (dato[j]>dato[j+1]) {
                temp = dato[j];
                dato[j] = dato[j+1];
                dato[j+1] = temp;
            }
            j++;
        }
        i++;
    }
    
    for (i=0; i<N; i++) {
        printf(" %d ", dato[i]);
    }
    printf("\n");

}
