//
//  main.c
//  prova
//
//  Created by Anna Maria Nestorov on 27/11/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include <stdio.h>
#include <string.h>

#define N 10

typedef char Stringa[100];

void leggiInd(Stringa indirizzi[], int nInd);
void scriviInd(Stringa indirizzi[], int nInd);


int main(int argc, const char * argv[]) {
    
    int n_elements;
    
    do{
        printf("Inserisci il numero di indirizzi (1-10): \n");
        scanf("%d", &n_elements);
    }while(n_elements<0 || n_elements>10);
    
    Stringa indirizzi[N];
    
    leggiInd (indirizzi, n_elements);
    
    scriviInd (indirizzi, n_elements);
    
    return 0;
    
    
}

void leggiInd(Stringa indirizzi[], int nInd) {
    unsigned int i;
    Stringa protocollo;
    for (i = 0; i < nInd; i++) {
        do
        {
            printf ("Indirizzo %d: ", i);
            scanf ("%s", indirizzi[i]);
        } while (strlen(indirizzi[i]) < 4);
        
        if (strstr(indirizzi[i], "ftp.") != NULL) {
            strcpy(protocollo, "ftp://");
        }
        else
        {
            strcpy (protocollo, "http://");
        }
        strcat(protocollo, indirizzi[i]);
        strcpy(indirizzi[i], protocollo);
    }
    printf("\n");
}

void scriviInd(Stringa indirizzi[], int nInd) {
    unsigned int i;
    for (i = 0; i < nInd; i++) {
        printf ("Indirizzo: %s ", indirizzi[i]);
        if (strcmp(indirizzi[i], "http://www.polimi.it") == 0)
            printf ("E’ il sito del Poli!");
        printf("\n");
    }
}

