#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#define N 6

void consegnaTessere(char g[N], int pool[26]);
int parolaValida(char *parola, char mano[N]);
int punteggio(char *parola, int valore[26]);

int presenze(char c, char lettere[], int lunghezzaArray);

int main() {
    
    int pool[26] = {9,2,2,4,12,2,3,2,9,1,1,4,2,6,8,2,1,6,4,6,4,2,2,1,2,1};
    int valore[26] = {1,2,3,2,1,4,2,4,1,8,5,1,3,1,1,3,10,1,1,1,1,4,4,8,4,10};
    
    char mano[N];
    char parola[N+1];
    
    int i;
    int p;
    
    consegnaTessere(mano, pool);
    
    for(i=0; i<N; i++) {
        printf(" %c ", mano[i]);
    }
    printf("\n");
    
    printf("Inserisci una parola ->");
    scanf("%s", parola);
    
    p = punteggio(parola, valore);
    printf("Hai totalizzato %d punti!\n\n", p);

}

void consegnaTessere(char g[N], int pool[26]) {
    int i;
    int random;
    unsigned int seed = (unsigned int)time(NULL);
    srand(seed);
    i=0;
    while (i<N) {
        //genero una tessera
        random = rand()%26;
        if (pool[random] > 0) {
            pool[random]--;
            g[i] = 'a' + random;
            i++;
        }
    }
}

int punteggio(char *parola, int valore[26]) {

    int len;
    int i;
    int somma;
    
    len = (int)strlen(parola);
    somma = 0;
    for(i=0; i<len; i++) {
        somma += valore[parola[i]-'a'];
    }
    return somma;
}
