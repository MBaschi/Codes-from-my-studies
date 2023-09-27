#include <stdio.h>

int isPerpendicolare(double m1, double m2);

int main() {
    double m1, q1, m2, q2;
    
    printf ("Inserisci m e q per la prima retta: \n");
    scanf("%lf",&m1);
    scanf("%lf",&q1);
    
    printf ("Inserisci m e q per la seconda retta: \n");
    scanf("%lf",&m2);
    scanf("%lf",&q2);
    
    if (isPerpendicolare(m1,m2)==1)
        printf ("Le due rette sono perpendicolari\n");
    else
        printf ("Le due rette non sono perpendicolari\n");
    return 0;
}

int isPerpendicolare(double m1, double m2)
{
    if (m1*m2==-1)
        return 1;
    else
        return 0;
}
