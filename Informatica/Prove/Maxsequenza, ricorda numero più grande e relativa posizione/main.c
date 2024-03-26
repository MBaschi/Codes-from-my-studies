//inserisco infiniti numeri, mi interessa tenere solo il più grande di essi e ricordare la relativa posizione. E' una struttura a ciclo dove chiedo sempre un numero. Mi blocco solo all'arrivo del numero "-1" che chiude il ciclo
#include <stdio.h>

int main() {
    
    int max=-1;
    int posizione=0;
    int inserito=-1;
    int posizioneMax=0;
    
    do{
        printf("Inserisci un nuovo valore ->");
        scanf("%d", &inserito);
        
        while (inserito <=0 && inserito!=-1) {
            printf("Deve essere positivo.Riprova.\n");
            scanf("%d", &inserito);
        }
        
        
        if (inserito==-1) {
            break;
        }
        
        posizione=posizione+1;
        
        if(inserito>max) {
            max=inserito;
            posizioneMax=posizione;
        }
        
    }while (1);  //vuol dire che è vero
    
    if(max==-1) {
        printf("Non hai inserito niente!\n");
    }
    else{
        printf("Max ->%d\n", max);
        printf("Posizione del max -> %d\n", posizioneMax);
    }
    return 0;
}
