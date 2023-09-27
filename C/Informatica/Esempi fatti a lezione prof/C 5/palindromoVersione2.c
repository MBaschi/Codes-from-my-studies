#include <stdio.h>
#include <string.h>

#define N 10

char toLower(char input);

int main() {
    
    char parola[N];
    int i;
    int len;
    
    
    printf("Inserisci la parola da controllare -> ");
    scanf("%s", parola);
    
    printf("Parola insertita -> %s\n", parola);
    
    i = 0;
    len = (int)strlen(parola);
    
    while (i < len - 1 - i) {
        //verifico uguaglianza
        if (toLower(parola[i]) != toLower(parola[len-1-i])) {
            //la parola non è palindroma
            printf("La parola inserita non è palindroma!\n");
            return 0;
        }
        i++;
        
    }
    
    printf("La parola inserita è palindroma!\n");
    
}

char toLower(char input) {
    if (input >= 'A' && input <= 'Z') {
        input = input + ('a'-'A');
    }
    return input;
}





