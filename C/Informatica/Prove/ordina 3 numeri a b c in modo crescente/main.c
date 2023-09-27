#include <stdio.h>

int main() {
    int a;
    int b;
    int c;
    
    printf("Inserisci il numero a ->");
    scanf("%d", &a);
   
    printf("Inserisci il numero b ->");
    scanf("%d", &b);
   
    printf("Inserisci il numero c ->");
    scanf("%d", &c);
    
    if (a<b) {
        if (b<c) {
            printf("%d %d %d\n",a,b,c);
        }
        else {
            if (a<c) {
                printf("%d %d %d\n",a,c,b);
            } else {
                printf("%d %d %d\n",c,a,b);
                }
        }
    }
    else {
        if (b<c) {
            
            if (a<c) {
                printf("%d %d %d",b,a,c);
            } else {
                printf("%d %d %d",b,c,a);
            }
        } else {
            printf("%d %d %d",c,b,a);
        }
    }
    return 0;
}
