#include <stdio.h>
#include <math.h>

int main(int argc, const char * argv[]) {
    float a,b,c,x1,x2;
    float delta;
    
    
    printf("Inserisci i tre coefficienti:\n");
    printf("A: ");
    scanf("%f",&a);
    printf("B: ");
    scanf("%f",&b);
    printf("C: ");
    scanf("%f",&c);
    
    delta = pow(b,2)-4*a*c;
    if (delta<0)
        printf("Non essitono soluzioni reali.\n");
    else if (delta==0)
    {
        printf("La soluzione è: x=%.2f",-b/(2*a));
    }
    else
    {
        x1 = (-b+sqrt(delta))/(2*a);
        x2 = (-b-sqrt(delta))/(2*a);
        printf("Delta > 0\nLe soluzioni sono:\nX1=%.2f\nX2=%.2f",x1,x2);
    }
    return 0;
}
