//
//  main.c
//  prova
//
//  Created by Anna Maria Nestorov on 27/11/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#define MAX_SIZE 1024

void ricercaParola(char *str, char *daCercare){
    int strLen  = (int)strlen(str);
    int searchLen = (int)strlen(daCercare);
    int i, j;
    int found;
    
    for(i=0; i<strLen - searchLen; i++)
    {
        found = 1;
        for(j=0; j<searchLen; j++)
        {
            if(str[i + j] != daCercare[j])
            {
                found = 0;
                break;
            }
        }
        
        if(found == 1)
        {
            printf("'%s' trovata in posizione: %d \n", daCercare, i);
        }
    }
}


void eliminaPrimaOcc(char *str, char *daRimuovere)
{
    int i, j;
    int len, removeLen;
    int found = 0;
    
    len = (int)strlen(str);
    removeLen = (int)strlen(daRimuovere);
    
    for(i=0; i<len; i++)
    {
        found = 1;
        for(j=0; j<removeLen; j++)
        {
            if(str[i+j] != daRimuovere[j])
            {
                found = 0;
                break;
            }
        }
        
        if(found == 1)
        {
            for(j=i; j<=len-removeLen; j++)
            {
                str[j] = str[j + removeLen];
            }
            break;
        }
    }
}
int main(int argc, const char * argv[]) {
    
    char str[MAX_SIZE];
    char daRimuovere[MAX_SIZE];
    char daCercare[MAX_SIZE];
    int scelta;
    
    printf("********************* MENU *********************");
    do {
        printf("\n1 - Inserisci stringa ");
        printf("\n2 - Rimuovi sottostringa ");
        printf("\n3 - Cerca sottostringa");
        printf("\n4 - Esci ");
        printf("\nInserisci la tua scelta ---> ");
        scanf("%d",&scelta);
        switch (scelta) {
            case 1:
                printf("\nInserisci una stringa (max 1024 caratteri):");
                gets(str);
                break;
            case 2:
                printf("\nInserisci la sottostringa da rimuovere:");
                gets(daRimuovere);
                eliminaPrimaOcc(str, daRimuovere);
                printf("\nRisultato: '%s': \n", str);
                break;
            case 3:
                printf("\nInserisci la parola da cercare: ");
                gets(daCercare);
                ricercaParola(str,daCercare);
                break;
        }
    } while (scelta != 4);
    return 0;
    
    
}
