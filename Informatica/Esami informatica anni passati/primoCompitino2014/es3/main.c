
#include <stdio.h>
#define N 5

int main() {
    
    int m[N][N] = {{1, 2, 11, 0, 0}, {33, 26, 45, 7, 0}, {0, 7, 15, 24, 52}, {0,0,19,2,56}, {0,0,0,25,9}};
    int i;
    int j;
    int banda = 1;
    int deveEssereZero;
    
    //stampa della matrice
    
    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            printf(" %3d ", m[i][j]);
        }
        printf("\n");
               
    }
    printf("\n\n");
    
    //controllo la diagonale principale (obbligatoria)
    
    for (i=0; i<N && banda==1; i++) {
        if (m[i][i]==0) {
            banda = 0;
        }
    }
    
    if (banda==0) {
        printf("NO - diagonale principale");
        printf("\n");
        return 0;
    }
    
    //controllo la semibanda destra
    
    deveEssereZero = 0;
    
    for (i=1; i<N && banda == 1; i++) {
        if (m[0][i]== 0) {
            deveEssereZero = 1;
            for (j=0; j<N-i && banda == 1; j++) {
                if (m[j][i+j]!=0)
                    banda = 0;
            }
        }
        else {
            if (deveEssereZero==1) {
                banda = 0;
            }
            for (j=0; j<N-i && banda == 1; j++) {
                if (m[j][i+j]==0) {
                    banda = 0;
                }
            }
        }
    }
    
    if (banda==0) {
        printf("NO - semibanda destra");
        printf("\n");
        return 0;
    }
    
    //controllo la semibanda sinistra
    
    deveEssereZero = 0;
    
    for (i=1; i<N && banda == 1; i++) {
        if (m[i][0] == 0) {
            deveEssereZero = 1;
            for (j=0; j<N-i && banda == 1;j++) {
                if (m[i+j][j]!=0) {
                    banda = 0;
                }
            }
        }
        else {
            if (deveEssereZero == 1) {
                banda = 0;
            }
            for (j=0; j<N-i && banda == 1; j++) {
                if (m[i+j][j] == 0) {
                    banda = 0;
                }
            }
        }
    }
    
    if (banda==0) {
        printf("NO - semibanda destra");
        printf("\n");
    }
    else {
        printf("SI");
        printf("\n");
    }
    
    
    return 0;
}
