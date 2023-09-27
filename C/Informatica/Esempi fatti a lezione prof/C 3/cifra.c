#include <stdio.h>

int main() {
    
    int n;
    char c;
    int nuovo;
    
    printf("Inserisci un valore numerico -> ");
    scanf("%d", &n);
    
    n = n % 52;
    
    printf("n inserito -> %d\n", n);
    
    do {
        printf("Inserisci un carattere -> ");
        scanf(" %c", &c);
    } while (c<'A' || c>'z' || (c>'Z' && c<'a') );
    
    //printf("Bravo!");
    
    if (c<'Z') {
        //parte sinistra
        nuovo = c + n;
        if (nuovo > 'Z') {
            nuovo = nuovo + ('a'-'Z') - 1;
            //printf("Valore di nuovo -> %c\n", nuovo);
            if (nuovo > 'z') {
                nuovo = nuovo - ('z'-'A') - 1;
            }
        }
    
    }
    else {
        //parte destra
    }
}
