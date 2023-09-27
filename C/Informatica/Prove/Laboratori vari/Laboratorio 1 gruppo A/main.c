

#include <stdio.h>
#include <math.h>
int main() {
    double a;
    double b;
    double c;
    double delta;
    printf("Inserisci i tre numeri a,b,c corrispondenti ai coefficienti del polinomio di secondo grado->\n");
    scanf("%lf", &a);
    scanf("%lf", &b);
    scanf("%lf", &c);
    delta = ( pow(b, 2) - 4*a*c );
    if (delta<0) {
        printf("Il delta è negativo e quindi si avrànno soluzioni nel campo complesso");
    } else {
        printf("Le due soluzioni sono %f,%f",((-b + sqrt(delta))/(2*a)), ((-b - sqrt(delta))/(2*a)));
    }
return 0;
}
