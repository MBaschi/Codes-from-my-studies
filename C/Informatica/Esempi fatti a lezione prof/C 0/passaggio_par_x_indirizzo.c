#include <stdio.h>

/*
 void incrementa(int parametro)
 {
 parametro = parametro +1;
 printf("Il valore di parametro nella procedura è %d\n",parametro);
 }
 
 */

void incrementa(int *parametro)
{
    *parametro = *parametro +1;
    printf("Il valore di parametro nella procedura è %d\n",*parametro);
}


int main() {
    
    int i;
    
    i = 40;
    
    printf("Il valore di i prima della chiamata è %d\n",i);
    
    incrementa(&i);
    
    printf("Il valore di i dopo la chiamata è %d\n",i);
    
    
}

