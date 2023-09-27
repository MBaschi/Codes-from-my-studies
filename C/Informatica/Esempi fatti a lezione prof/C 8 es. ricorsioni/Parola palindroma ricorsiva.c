#include <stdio.h>
#include <string.h>
#define N 10

int palindroma(char *inizio, char *fine);

int main() {
    char parola[N];
    int risultato;
    int lunghezzaParola;
    printf("Inserisci la parola -> ");
    scanf("%s", parola);
    lunghezzaParola = (int)strlen(parola);   //funzione da CASTare e dà la lunghezza della parola
    risultato = palindroma(parola, parola + lunghezzaParola - 1);
    if (risultato) {
        printf("La parola è palindroma.\n");
    }
    else {
        printf("La parola NON è palindroma.\n");
    }
}

int palindroma(char *inizio, char *fine) {
    //caso base
    if (inizio >= fine) {
        return 1;
    }
    //caso base
    if (*inizio != *fine) {
        return 0;
    }
    //chiamata ricorsiva
    return palindroma(inizio+1, fine-1);
}
