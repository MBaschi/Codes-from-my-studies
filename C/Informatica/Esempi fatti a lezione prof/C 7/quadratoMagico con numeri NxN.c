#include <stdio.h>

#define N 51

int main() {
    
    int matrice[N][N];
    int dimensione;
    int cont;
    int i;
    int j;
    int sommariga;
    int sommaelementi;
    
    printf("Inserisci la dimensione -> ");
    scanf("%d", &dimensione);
    
    for (i=0; i<dimensione; i++) {        //inizializzo tutti gli elementi che mi interessano a 0
        for (j=0; j<dimensione; j++) {
            matrice[i][j] = 0;
        }
    }
    
    //imposto la posizione iniziale
    i = dimensione-1;
    j = dimensione/2;
    
    cont = 1;
    
    while (cont <= dimensione*dimensione) {
        //piazzo un elemento e calcolo nuovi valori di i e j
        matrice[i][j] = cont;
        cont++;
        if (matrice[(i+1)%dimensione][(j+1)%dimensione] == 0) {
            i = (i+1)%dimensione;
            j = (j+1)%dimensione;
        }
        else {
            i = i-1;
        }
    }
    
    for (i=0; i<dimensione; i++) {
        for (j=0; j<dimensione; j++) {
            printf("%5d", matrice[i][j]);
        }
        printf("\n");
    }
    
    sommariga = 0;
    for (i=0; i<dimensione; i++) {    ///somma della prima riga
        sommariga += matrice[0][i];
    }
    
    printf("\nSomma prima riga -> %d\n\n", sommariga);


    sommaelementi = 0;
    for (i=0; i<dimensione; i++) {
        for (j=0; j<dimensione; j++) {
            sommaelementi += matrice[i][j];
        }
    }
    printf("\nSomma tutti gli elementi -> %d\n\n", sommaelementi);
}

