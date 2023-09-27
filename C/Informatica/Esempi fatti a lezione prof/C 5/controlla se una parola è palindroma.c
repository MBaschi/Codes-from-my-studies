#include <stdio.h>
#include <string.h>

#define N 10

char toLower(char input);   //rende un carattere minuscolo

int main() {
    
    char parola[N];
    int sx;
    int dx;
    
    printf("Inserisci la parola da controllare -> ");
    scanf("%s", parola);
    
    printf("Parola insertita -> %s\n", parola);
    
    sx = 0;
    dx = (int)strlen(parola)-1;    ///funzione per calcolare la lunghezza di una parola
    
    while (sx < dx) {
        //verifico uguaglianza
        if (toLower(parola[sx]) != toLower(parola[dx])) {
            //la parola non è palindroma
            printf("La parola inserita non è palindroma!\n");
            return 0;
        }
        sx++;
        dx--;
    }
    
    printf("La parola inserita è palindroma!\n");
    
}

char toLower(char input) {
    if (input >= 'A' && input <= 'Z') {
        input = input + ('a'-'A');
    }
    return input;
}





