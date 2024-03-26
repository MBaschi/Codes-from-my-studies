#include <stdio.h>

int sommaDivisori(int num);

int main() {
    
    int primo;
    int numPrecedente;
    int numInserito;
    
    printf("Inserisci un valore positivo (-1 per uscire) ->" );
    scanf("%d", &numInserito);
    while (numInserito <= 0 && numInserito != -1) {
        printf("Inserimento errato! Riprova -> ");
        scanf("%d", &numInserito);
    }
    
    if (numInserito == -1) {
        printf("Non hai inserito valori! \n");
        return 0;
    }
    
    primo = numInserito;
    
    do {
        numPrecedente = numInserito;
        
        printf("Inserisci un nuovo valore positivo (-1 per uscire) -> ");
        scanf("%d", &numInserito);
        while (numInserito <= 0 && numInserito != -1) {
            printf("Inserimento errato! Riprova -> ");
            scanf("%d", &numInserito);
        }
        
        /*
        if (numInserito == -1) {
            break;
        }
         */
        
        if (numInserito != -1 && numInserito!=sommaDivisori(numPrecedente)) {
            printf("I numeri inseriti non sono socievoli!\n");
            return 0;
        }
        
    } while(numInserito != -1);
    
    //numInserito == -1 
    //numPrecedente è l'ultimo valore valido
    
    if (primo != sommaDivisori(numPrecedente)) {
        printf("I numeri inseriti non sono socievoli.\n");
    }
    else {
        printf("I numeri inseriti sono socievoli! \n");
    }
  
}

int sommaDivisori(int num) {
    int somma;
    int i;
    somma = 1;
    for (i=2; i<num; i++) {
        if (num%i==0) {
            somma += i;
        }
    }
    return somma;
}







