#include <stdio.h>
#define N 10
int elemMax(int *testa, int numElem);

int main() {
    
    int array[N] = {1, 5, 23, 5, 98, 34, 2, 5, 7, 19};
    int risultato;
    
    risultato = elemMax(array, N);
    printf("Il valore massimo è -> %d\n", risultato);
}

int elemMax(int *testa, int numElem) {
    int maxTemp;
    //caso base
    if (numElem==1){
        return testa[0]; //*testa
    }
    //chiamata ricorsiva
    maxTemp = elemMax(testa+1, numElem-1); //&testa[1]
    if (maxTemp > testa[0]) {
        return maxTemp;
    }
    else {
        return testa[0];
    }
}
