#include <stdio.h>
#include <math.h>

int main(int argc, const char * argv[])
{
    
    int a, b, c;
    int m, n;
    int sxuguale, dxuguale;
    do{
        printf("Inserisci il valore di m: \n");
        scanf("%d", &m);
        printf("Inserisci il valore di n: \n");
        scanf("%d", &n);
        if(m<=n){
            printf("Errore: m deve essere maggiore di n!\n");
        }
    }while(m<=n);
    
    a = pow(m,2) - pow(n,2);
    b = 2*m*n;
    c = pow(m,2) + pow(n,2);
    sxuguale = pow(a,2) + pow(b,2);
    dxuguale = pow(c,2);
    if(sxuguale == dxuguale){
        printf("La tripletta di Pitagora ottenuta è (%d, %d, %d) e soddisfa l'equazione.\n",a,b,c);
    }
    else{
        printf("Errore: equazione non soddisfatta!");
    }
    return 0;
}
