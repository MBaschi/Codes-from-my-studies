#include <stdio.h>
#define N 5

//proprietà matrice diagonale

int property(int matrice[N][N]);

int main() {
    int m[N][N] = { {1,2,3,4,5}, {6,1,2,3,4}, {7,6,1,2,3}, {8,7,6,1,2}, {9,8,7,6,1} };
    int risultato;
    risultato = property(m);
    if (risultato) {
        printf("La matrice soddisfa la proprietà.\n");
    }
    else {
        printf("La matrice NON soddisfa la proprietà.\n");
    }
}


int property(int matrice[N][N]) {
    
    int i;
    int j;
    
    for (i=0; i<N-1; i++) {
        //lavoro sulla diagonale i-esima
        for (j=0; j<N-1-i; j++) {
            //numero di iterazioni dipende dal numero di confronti da fare
            if (matrice[i+j][j] != matrice[i+j+1][j+1]) {
                return 0; //proprietà non verificata!
            }
            if (i!=0) {
                if (matrice[j][i+j] != matrice[j+1][i+j+1]) {\
                    return 0;
                }
            }
        }
    }
    
    //manca la diagonale principale
    /*
    for (i=0; i<N-1; i++) {
        if (matrice[i][i] != matrice[i+1][i+1]) {
            return 0;
        }
    }
    */
    
    return 1;
}








