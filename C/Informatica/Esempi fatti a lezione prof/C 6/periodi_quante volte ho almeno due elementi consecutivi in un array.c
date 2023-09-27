#include <stdio.h>

#define N 10

int main() {
    
    int dato[N] = {3, 3, 4, 1, 1, 1, 1, 8, 9, 9};
    int i;
    int periodo; //valore booleano per indicare la presenza di un periodo
    int contatore;
    
    periodo = 0; //non sono in un periodo
    contatore = 0;
    
    i=0;
    while (i<N-1) {
        if (dato[i] == dato[i+1] && periodo == 0) {
            //ho individuato l'inizio di un nuovo periodo
            periodo = 1;
            contatore++;
        }
        if (dato[i] != dato[i+1]) {
            periodo = 0;
        }
        i++;
    }
    printf("Sono stati contati %d periodi.\n", contatore);
}
