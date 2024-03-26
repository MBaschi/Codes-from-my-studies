//
//  main.c
//  Laboratorio 1 A esercizio 4
//
//  Created by sebastiano scrofani on 01/12/17.
//  Copyright © 2017 sebastiano scrofani. All rights reserved.
//

#include <stdio.h>

int main() {
    int base, esponente, sum, i;
    printf("Inserisci base ed esponente\n");
    printf("Base-> ");
    scanf("%d", &base);
    printf("Esponente-> ");
    scanf("%d", &esponente);
    sum =1;
    
    for (i = 0; i < esponente; i++) {
        sum = sum * base;
        
    }
    
    printf("il risultato è %d",sum);
    return 0;
}
