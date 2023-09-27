#include <stdio.h>

int main() {
    char primo;
    char secondo;
    char temp;
    
    
    printf("Inserisci un carattere -> ");
    scanf(" %c", &primo);                       // " %c" fa in modo di svuotare il buffer e non fa
                                                // spuntare due volte il "Riprova -> Riprova -> "
    while (primo < 'a' || primo > 'z') {
        printf("Riprova -> ");
        scanf("%c", &primo);
    }
    
    printf("Primo inserito -> %c\n", primo);
    
    printf("Inserisci un carattere -> ");
    scanf(" %c", &secondo);
    while (secondo<'a' || secondo>'z') {
        printf("Riprova -> ");
        scanf(" %c", &secondo);
    }
    if (primo> secondo) {
        //vanno riordinati
        temp = primo;
        primo = secondo;
        secondo = temp;
    }
    //rendo maiuscolo primo e secondo
    primo = primo - ('a'-'A');
    secondo = secondo - ('a'-'A');
    
    printf("Primo -> %c \n", primo);
    printf("Secondo -> %c \n", secondo);
    
    return 0;
}
