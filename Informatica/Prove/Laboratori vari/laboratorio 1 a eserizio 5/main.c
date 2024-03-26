//
//  main.c
//  laboratorio 1 a eserizio 5
//
//  Created by sebastiano scrofani on 01/12/17.
//  Copyright © 2017 sebastiano scrofani. All rights reserved.
//

#include <stdio.h>

int main() {
    int anno;
    printf("Inserisci l'anno di cui vuoi sapere se è bisestile o meno -> \n");
    scanf("%d", &anno);
    if ((anno%400)==0) {
            printf("L'anno è bisestile\n");
    } else {
        if ((anno%100)==0) {
        printf("l'anno non è bisesitile\n");
        } else {
            if ((anno%4)==0) {
                printf("l'anno è bisesitile\n");
            }
            else{
            printf("l'anno non è bisesitile\n");
            }
        }
    }
return 0;
}
