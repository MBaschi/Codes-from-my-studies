#include <stdio.h>

double pi(int precision);

int main(int argc, const char * argv[]) {
    int precision;
    
    printf("Inserisci la precisione: ");
    scanf("%d", &precision);
    
    printf("%.30f\n", pi(precision));
    
    return 0;
}

double pi(int precision) {
    double sum = 0.0;
    int k;
    double fractions;
    int power = 1;
    
    // nota: nei calcoli prendiamo costanti double,
    // in tal modo forziamo la divisione tra dobule.
    for (k = 0; k < precision; k++) {
        fractions = 4.0 / (8 * k + 1);
        fractions -= 2.0 / (8 * k + 4);
        fractions -= 1.0 / (8 * k + 5);
        fractions -= 1.0 / (8 * k + 6);
        
        // alla iterazione k-esima,
        // pow e' la potenza k-esima di 16
        sum += fractions / power;
        
        power *= 16;
    }
    
    return sum;
}
