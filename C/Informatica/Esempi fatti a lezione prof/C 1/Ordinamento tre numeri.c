#include <stdio.h>

void main() {
    int a;
    int b;
    int c;
    
    printf("Inserisci numero a -> ");
    scanf("%d", &a);
    
    printf("Inserisci numero b -> ");
    scanf("%d", &b);
    
    printf("Inserisci numero c -> ");
    scanf("%d", &c);
    
    if (a<b) {
        if (b<c) {
            printf("%d %d %d\n", a,b,c);
        }
        else {
            if (a<c) {
                printf("%d %d %d\n", a,c,b);
            }
            else {
                printf("%d %d %d\n", c,a,b);
            }
        }
    }
    else {
        if (b<c) {
            if (a<c) {
                printf("%d %d %d\n", b,a,c);
            }
            else {
                printf("%d %d %d\n", b,c,a);
            }
        }
        else {
            printf("%d %d %d\n", c,b,a);
        }
    }
}
