#include <stdio.h>

int main() {
    int watt;
    printf("Inserisci il numero dei Watt della lampadina->");
    scanf("%d", &watt);
    switch (watt) {
        case 15:
            printf("la luminosità è 125");
            break;
        case 25:
            printf("la luminosità è 215");
            break;
        case 40:
            printf("la luminosità è 500");
            break;
        case 60:
            printf("la luminosità è 880");
            break;
        case 75:
            printf("la luminosità è 1000");
            break;
        case 1001:
            printf("la luminosità è 675");
            break;
        default:
            printf("-1");
            break;
    }
    return 0;
}
