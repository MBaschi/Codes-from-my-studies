#include <stdio.h>
#define N 100

int main() {

    int m[N][N];
    
    int righe;     //provato col numero 6
    int colonne;
    
    int i;
    int j;
    
    printf("Inserire riga -> ");
    scanf("%d", &righe);
    
    colonne = righe*2 - 1;
    
    for (i=0; i<righe; i++) {
        for (j=0; j<colonne; j++) {
            m[i][j] = 0;
        }
    }
    
    m[0][colonne/2] = 1;
    m[righe-1][0] = 1;
    m[righe-1][colonne-1] = 1;
    
    for (i=1; i<righe; i++) {
        for (j=1; j<colonne-1; j++) {
            m[i][j] = m[i-1][j-1] + m[i-1][j+1];
        }
    }
    
    for (i=0; i<righe; i++) {
        for (j=0; j<colonne; j++) {
            if (m[i][j] != 0) {
                printf(" %d ", m[i][j]);
            }
            else {
                printf("   ");
            }
        }
        printf("\n");
    }
}
