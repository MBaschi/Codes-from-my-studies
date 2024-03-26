#include <stdio.h>

int main() {
    
    /*
     switch (nome_var) {
        case costante1 :
            statement1;
            statement2;
            ...
            break;
        case costante2 :
            statement3;
            statement4;
            ...
            break;
        case costante3 :
            statement5;
            statement6;
            ...
            break;
        default:
            statment7;
            ...
            break;
     }
     */
    
    int dato;
    
    printf("Inserisci un numero -> ");
    scanf("%d", &dato);
    
    switch (dato) {
        case 1:
            printf("1\n");
            break;
        case 2:
            printf("2\n");
            break;
        case 3:
            printf("3\n");
            break;
        default:
            printf("Siamo in fondo!\n");
    }
    
    
    
}
