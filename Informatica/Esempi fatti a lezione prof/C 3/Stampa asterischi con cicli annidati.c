#include <stdio.h>
#define N 10

void histoOrizzontale(int arr[], int len);
void histoV(int arr[], int len);

int main() {
    int dato[N] = {1,9,13,6,4,11,7,3,2,10};
    histoOrizzontale(dato, N);
    printf("\n\n\n");
    histoV(dato, N);
}

void histoOrizzontale(int arr[], int len) {
    int i;
    int j;
    for (i=0; i<len; i++) {
        //stampare un certo numero di * per il valore i-esimo
        for (j=0; j<arr[i]; j++) {
            printf("*");
        }
        //stampare un \n
        printf("\n");
    }
    
}

void histoV(int arr[], int len) {
    int max;
    int i;
    int riga;
    
    max = arr[0];
    for (i=1; i<len; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    
    for (riga = max; riga > 0; riga--) {
        //sto gestendo la riga riga-esima
        for (i=0; i<len; i++) {
            if (arr[i]>=riga) {
                printf(" * ");
            }
            else {
                printf("   ");
            }
        }
        printf("\n");
    }
    
    
    
    
}












