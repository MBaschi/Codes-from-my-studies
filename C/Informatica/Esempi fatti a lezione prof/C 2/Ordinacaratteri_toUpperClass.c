#include <stdio.h>

int main() {
    char primo;
    char secondo;
    char temp;

    printf("Inserisci un carattere -> ");
    scanf(" %c", &primo);
    while (primo < 'a' || primo > 'z') {
        printf("Riprova -> ");
        scanf(" %c", &primo);
    }
    
    printf("Primo inserito -> %c\n", primo);
    
    printf("Inserisci un carattere -> ");
    scanf(" %c", &secondo);
    while (secondo<'a' || secondo>'z') {
        printf("Riprova -> ");
        scanf(" %c", &secondo);
    }
    
    if (primo > secondo) {
        //vanno riordinati
        temp = primo;
        primo = secondo;
        secondo = temp;
    }
    
    primo = primo - ('a'-'A');
    secondo = secondo - ('a'-'A');
    
    printf("Primo -> %c \n", primo);
    printf("Secondo -> %c \n", secondo);
    
    

}
