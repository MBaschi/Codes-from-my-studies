#include <stdio.h>
#include <math.h>

int main(int argc, const char * argv[])
{
    float d ;
    float aq, ac, at;
    float r ;
    float rad3_4 ;
    
    rad3_4 = sqrt(3) / 4 ;
    
    printf("Immetti il valore di D: ") ;
    scanf("%f", &d) ;
    
    /* CALCOLA L’AREA DEL QUADRATO DI LATO D */
    aq = pow(d,2) ;
    
    /* CALCOLA L’AREA DEL CERCHIO DI DIAMETRO D */
    r = d/2 ;
    ac = M_PI*pow(r,2);

    /* CALCOLA L’AREA DEL TRIANGOLO EQUILATERO DI LATO D */
    at = rad3_4 * pow(d,2) ;

    /* STAMPA IL RISULTATO */
    printf("\n") ;
    printf("Le aree calcolate sono:\n") ;
    printf("Area del quadrato di lato %0.2f = %0.2f\n", d, aq) ;
    printf("Area del cerchio di diametro %0.2f = %0.2f\n",d, ac) ;
    printf("Area del triangolo equilatero di lato %0.2f = %0.2f\n", d, at) ;
    return 0;
}
