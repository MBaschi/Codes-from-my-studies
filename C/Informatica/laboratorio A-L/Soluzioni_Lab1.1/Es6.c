#include <stdio.h>

int main() {
    int a1,a2,a3,a4,b1,b2,b3,b4;
    int r1,r2=0,r3=0,r4=0;
    int of = 0;
    
    printf("Inserisci il numero a: ");
    scanf("%d %d %d %d",&a4,&a3,&a2,&a1);
    printf("Inserisci il numero a: ");
    scanf("%d %d %d %d",&b4,&b3,&b2,&b1);
    
    r1 = a1 + b1;
    if (r1>1)
    {
        r1 = 0;
        r2 = 1;
        
    }
    r2 = r2+a2+b2;
    if (r2==2)
    {
        r2 = 0;
        r3 = 1;
    }
    else if (r2==3)
    {
        r2 = 1;
        r3 = 1;
    }
    r3 = r3+a3+b3;
    if (r3==2)
    {
        r3 = 0;
        r4 = 1;
    }
    else if (r3==3)
    {
        r3 = 1;
        r4 = 1;
    }
    r4 = r4+a4+b4;
    if (r4==2)
    {
        r4 = 0;
        of = 1;
    }
    else if (r3==3)
    {
        r4 = 1;
        of = 1;
    }
    
    printf ("La somma è: %d%d%d%d\n",r4,r3,r2,r1);
    if (of==1)
        printf("C'e' overflow\n");
    
    
    
    
    
    return 0;
}
