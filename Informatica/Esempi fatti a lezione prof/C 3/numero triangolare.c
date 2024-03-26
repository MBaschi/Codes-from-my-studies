#include <stdio.h>

int numeroTriangolare(int n);

int main() {
    int num;
    int risultato;
    printf("Inserisci un numero -> ");
    scanf("%d", &num);
    risultato = numeroTriangolare(num);
    if (risultato == 1) {
        printf("Il numero è triangolare\n");
    }
    else{
        printf("Non è triangolare\n");
    }
}

int numeroTriangolare(int n) {
    int i = 1;
    while (n>0) {
        n = n - i;
        i++;
    }
    if (n==0) {
        return 1;
    }
    return 0;
}
