#include <stdio.h>
/*
int main(int argc, const char * argv[]) {
    int num;
    
    printf("Inserisci numero tra 2 e 12: ");
    do{
        scanf("%d",&num);
        if(num<2 || num>12)
            printf("Numero non valido, inserisci numero tra 2 e 12: ");
    }while(num<2 || num>12);
    printf("Tabellina per ripassare: %d ",num);
    for (int i=1; i<=10; i++)
        printf("%dx%d=%d ",num,i,num*i);
    printf("\n");
    return 0;
}
*/
//VARIANTE
int main(int argc, const char * argv[]) {
     int num,k;
 
     printf("Inserisci numero tra 2 e 12: ");
     do{
         scanf("%d",&num);
         if(num<2 || num>12)
         printf("Numero non valido, inserisci numero tra 2 e 12: ");
     }while(num<2 || num>12);
    printf("Inserisci numero tra 1 e 10 (termine della tabellina): ");
     do{
         scanf("%d",&k);
         if(k<1 || k>10)
             printf("Numero non valido, inserisci numero tra 1 e 10: ");
     }while(k<1 || k>10);
     printf("Tabellina per ripassare: %d ",num);
     for (int i=1; i<=k; i++)
         printf("%dx%d=%d ",num,i,num*i);
     printf("\n");
     return 0;
 }

