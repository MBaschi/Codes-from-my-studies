#include <stdio.h>

void main() {
    
    int max = -1;
    int posizione = 0;
    int posizioneMax = 0;
    int inserito = -1;
    
    
    do {
        
        //step 1. chiedere un nuovo valore all'utente
        
        printf("Inserisci un nuovo valore -> ");
        scanf("%d", &inserito);
        
        while (inserito <= 0 && inserito != -1) {
            printf("Deve essere positivo. Riprova.\n");
            scanf("%d", &inserito);
        }
        
        //step 2. gestisco un eventuale -1
        
        /*
        if (inserito == -1) {
            break;
        }
        */
        
        // step 3. il nuovo valore è il nuovo massimo???
        //posizione = posizione + 1;
        posizione++;
        
        if (inserito != -1 && inserito > max) {
            max = inserito;
            posizioneMax = posizione;
        }
        
    } while (inserito != -1);
    
    //gestisco il caso in cui lui non abbia inserito alcun valore valido nella sequenza, ma immediatamente un -1
    
    if (max == -1) {
        printf("Non hai inserito niente!\n");
    }
    else{
        printf("Max -> %d\n", max);
        printf("Posizione del max -> %d\n",posizioneMax);
    }
}
