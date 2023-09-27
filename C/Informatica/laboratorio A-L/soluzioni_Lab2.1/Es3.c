//
//  main.c
//  Lab2Es3
//
//  Created by Paolo on 30/10/17.
//  Copyright © 2017 Paolo. All rights reserved.
//

#include <stdio.h>

char sostituisci(char c1, char c2);

int main(int argc, const char * argv[]) {
    char array[20];
    int i;
    
    printf("Inserisci carattere: ");
    fpurge(stdin);
    scanf("%c",&array[0]);
    array[1]=' ';
    
    //Lettura
    for (i=2; i<20; i++)
    {
        fpurge(stdin);
        scanf("%c",&array[i]);
        if (array[i]=='.')
            break;
        array[i] = sostituisci(array[0], array[i]);
    }
    printf("Con cambiato vocali masiucole\n");
    for (i=0; i<20 && array[i]!='.'; i++)
        printf("%c",array[i]);
    return 0;
}

char sostituisci(char c1, char c2)
{
    if ((c2=='A') || (c2=='E') || (c2=='I') || (c2=='O') || (c2=='U'))
        return c1;
    else
        return c2;
}
