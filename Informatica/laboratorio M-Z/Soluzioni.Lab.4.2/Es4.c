//
//  main.c
//  prova
//
//  Created by Anna Maria Nestorov on 27/11/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include<stdio.h>
#include<string.h>

int palRic(char *PC, char *UC);

int main(int argc, const char * argv[]) {
    
    int lunghStringa;
    char stringa[10];
    
    printf("Inserisci una stringa: \n");
    scanf("%s",stringa);
    lunghStringa=strlen(stringa);
    
    int ultimoCarattere = lunghStringa - 1;
    if (palRic(&stringa[0], &stringa[ultimoCarattere]))
        printf("La stringa è palindroma!\n");
    else
        printf("La stringa non è palindroma!\n");
    return 0;
}

int palRic(char *PC, char *UC){
    /* stringa vuota o un solo carattere */
    if (PC >= UC){
        return 1;
    }
    else if (*PC != *UC){
        return 0;
    }
    else{
        return palRic(PC+1, UC-1);
    }
}
