
#include <stdio.h>
#include <math.h>

int main() {
    int a,b,c;
    int m,n;

    printf("Inserisci due numeri interi i ordine crescente ->");
    scanf("%d%d", &n, &m);
           
    if (m>n) {
        a= pow(m,2) - pow(n,2);
        b= 2*m*n;
        c= pow(m,2) + pow(n,2);
        printf("La terna pitagorica è quella data dai numeri %d,%d,%d\n",a,b,c);
        
    }
    return 0;
}
//  float res = pow(2,3);
//  println(“La potenza 2^3 è: %.2f”, res);

