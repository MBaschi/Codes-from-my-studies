
#include <stdio.h>

int main() {
    
    int numero_inserito;
    int fattoriale;
    int i;
    fattoriale=1;
  
    
    printf("Inserisci il numero di cui si vuole conoscere il fattoriale ->");
    scanf("%d", &numero_inserito);
    
    while (numero_inserito>=0) {
        
        for (i=0; i<numero_inserito; i++) {
            fattoriale= fattoriale*(numero_inserito-i);
        }
        printf("Il fattoriale del numero inserito è %d\n", fattoriale);
        printf("Inserisci il numero di cui si vuole conoscere il fattoriale ->");
        scanf("%d", &numero_inserito);
        fattoriale=1;
        
    }
    
    printf("Il numero inserito è negativo, fine del programma");
    return 0;
}
