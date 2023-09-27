#include <stdio.h>

#define N 10
#define M 4

int cancella(char dato[], int n, char daCercare[], int m);

int main() {
    
    char dato[N] = {'c', 'i', 'o', 'm', 'c', 'i', 'a', 'o', 'w', 'z'};
    char daCercare[M] = {'c', 'i', 'a', 'o'};
    
    int i;
    int risultato;
    
    risultato = cancella(dato, N, daCercare, M);
    
    if (risultato == -1) {
        printf("Non sono riuscito a trovare la sottostringa.\n");
    }
    else {
        printf("Sottostringa trovata in posizione %d.\n", risultato);
        for (i=0; i<N; i++) {
            printf("%c", dato[i]);
        }
        printf("\n");
    }
    
}

int cancella(char dato[], int n, char daCercare[], int m) {
    
    int i;
    int j;
    
    i=0;
    while (i<=(n-m)) {
        //i indica la posizione in cui potrebbe trovarsi la parola cercata
        for (j=0; j<m; j++) {
            if (dato[i+j] != daCercare[j]) {
                break;
            }
        }
        if (j==m) {
            //la parola è stata trovata
            for (j=0; j<m; j++) {
                dato[i+j] = '_';
            }
            return i;
        }
        i++;
    }
    return -1;
}

