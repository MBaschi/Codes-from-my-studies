#include <stdio.h>

int main(int argc, const char * argv[]) {
    int num;
    long double fattoriale=1;
    
    do{
        printf("Inserisci un numero: ");
        scanf("%d",&num);
        if(num>=0)
        {
            for (int i=1; i<=num; i++)
                fattoriale = fattoriale*i;
            printf("Il fattoriale e': %.0Lf\n",fattoriale);
            fattoriale = 1;
        }
   }while(num>=0);
   
    return 0;
}
