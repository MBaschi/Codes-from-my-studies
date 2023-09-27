#include <stdio.h>

int main() {
    
    int inserito;
    int somma;
    int numInseriti;
    float media;
    
    somma = 0;
    numInseriti = 0;
    
    do {
        //1. nuovo valore per inserito
        printf("Inserisci un valore tra 18 e 33 (-1 per uscire) -> ");
        scanf("%d", &inserito);
        while ( (inserito < 18 || inserito > 33) && inserito != -1 ) {
            printf("Valore non valido. Riprova -> ");
            scanf("%d", &inserito);
        }
        //2. gestisco -1
        //3. modifica di somma e numInseriti se inserito != -1
        if (inserito != -1) {
            somma += inserito; //somma = somma + inserito;
            numInseriti++; // numInseriti = numInseriti + 1;
        }
    } while(inserito != -1);
    
    //l'utente ha inserito -1 per uscire
    
    if (numInseriti > 0) {
        media = (float)somma/numInseriti;
        printf("Media calcolata -> %f\n", media);
    }
    else {
        printf("Non hai inserito valori.\n");
    }
    
}
