//calcola in modo ricorsivo il valore di un numero (base) elevanto all'ennesima potenza.


#include <stdio.h>
int power_raiser(int base, int power);
int main() {
    int base,power;
    printf("inserisci due numeri positivi interi, rispettivamente la base e l'esponente della potenza cercata->");
    scanf("%d%d", &base, &power);
    printf("Il risultato è %d\n", power_raiser(base,power));
    return 0;
}

int power_raiser(int base,int power) {
   int ans;
   if (power == 1) {
       ans = base;
   } else {
       ans = base * power_raiser(base, power - 1);
   }
    return ans;
}


