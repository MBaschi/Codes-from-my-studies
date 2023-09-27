//
//  main.c
//  1 laboratorio 2 esercizio in poi

#include <stdio.h>
#define cost1 32
#define cost2 -273.15
int main() {
    double temp_celsius;
    double Fahrenheit;
    double Kelvin;

    printf("Inserisci la temperatura in gradi Celsius ->");
    scanf("%lf",&temp_celsius);
    while (temp_celsius<cost2) {
        printf("Il valore inserito non esiste, è minore dello zero assoluto.Riprova.\n");
        printf("Inserisci la temperatura in gradi Celsius -> \n");
        scanf("%lf", &temp_celsius);
    }
    
    Fahrenheit=(double)9/5*temp_celsius+cost1;
    Kelvin=temp_celsius - cost2;
    
    printf("La temperatura in Fahreneit è %lf.\n",Fahrenheit);
    printf("La temperatura in Kelvin è %lf.\n",Kelvin);
    
    return 0;
}
