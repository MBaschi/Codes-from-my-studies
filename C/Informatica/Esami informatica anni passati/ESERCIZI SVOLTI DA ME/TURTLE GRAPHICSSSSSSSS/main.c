#include <stdio.h>
#define MAX 25
#define MARX 1000

int disegna(char matrice [][25], char istruzioni[]);

int main() {
    char matrice[MAX][MAX];
    char istruzioni[MARX];
    int i;
    
    for (i=0; i<MAX; i++) {
        for(int j=0; j<MAX; j++)
            matrice[i][j] = '_';
    }
    matrice[12][12]='x';
    
    printf("Talete, inserisci le istruzioni->\n");
    
    for (i=0; istruzioni[i-1]!='.' && i<MARX; i++) {
        scanf(" %c", &istruzioni[i]);
    }
    
    if (disegna(matrice,istruzioni)==1) {
        for (i=0; i<MAX; i++) {
            for(int j=0; j<MAX; j++) {
                printf(" %c ", matrice[i][j]);
            }
            printf("\n");
        }
    }
    else {
            printf("Talete datti all'ippica! hai sbagliatoooooo");
    }
    return 0;
}



int disegna(char matrice [][25], char istruzioni[]) {
    
    int richy,i,j;
    i=12;
    j=12;
    int direzione=1;
    
    for (richy=0; istruzioni[richy]!='.' && richy<MARX; richy++) {
        switch (istruzioni[richy]) {
                
            case 'a':
                switch (direzione) {
                    case 1:
                        matrice[i-1][j]='x';
                        i--;
                        break;
                    case 2:
                        matrice[i][j+1]='x';
                        j++;
                        break;
                    case 3:
                        matrice[i+1][j]='x';
                        i++;
                        break;
                    case 4:
                        matrice[i][j-1]='x';
                        j--;
                        break;
                    default:
                        break;
                }
                break;
            case 'd':
                switch (direzione) {
                    case 1:
                        direzione=2;
                        break;
                    case 2:
                        direzione=3;
                        break;
                    case 3:
                        direzione=4;
                        break;
                    case 4:
                        direzione=1;
                        break;
                    default:
                        break;
                }
                break;
           
            case 's':
                switch (direzione) {
                    case 1:
                        direzione=4;
                        break;
                    case 2:
                        direzione=1;
                        break;
                    case 3:
                        direzione=2;
                        break;
                    case 4:
                        direzione=3;
                        break;
                    default:
                        break;
                }
                break;

            default:
                break;
        }
        if (i==-1 || i==25 || j==-1 || j==25) {
            return (-1);
        }
}
    return 1;
}
