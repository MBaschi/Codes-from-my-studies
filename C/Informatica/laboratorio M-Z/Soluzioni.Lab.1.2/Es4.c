#include <stdio.h>

int main(int argc, const char * argv[])
{
    int num;
    float media = 0;
    int somma = 0;
    int i = 0;
    printf ("Inserisci un numero: ");
    scanf("%d",&num);
    while (num >= 0) {
        i = i + 1;
        somma = somma + num;
        media = (float)somma/i;
        printf ("La media attuale è: %.3f\n", media);
        printf ("Inserisci un numero: ");
        scanf("%d",&num);
    }
    printf ("La media finale è: %.3f\n", media);
}

/* con do-while
 int main(int argc, const char * argv[])
 {
     int num;
     float media = 0;
     int somma = 0;
     int i = 0;
 
     do{
         printf ("Inserisci un numero: ");
         scanf("%d",&num);
         if (num>=0){
             i = i + 1;
             somma = somma + num;
             media = (float)somma/i;
             printf ("La media attuale è: %.3f\n", media);
         }
     }while (num >= 0);
     printf ("La media finale è: %.3f\n", media);
 }
 */
