#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int somma(int a[50]);
void genera(int a[50]);
void stampa(int a[50]);

int main(int argc, const char * argv[]) {
    int array[50];
    srand(time(NULL));
    
    genera(array);
    stampa(array);
    printf ("La somma del contenuto è: %d\n",somma(array));
    
    return 0;
}

int somma(int a[50])
{
    int s = 0;
    for (int i=0; i<50; i++)
        s+= a[i];
    return s;
}

void genera(int a[50])
{
    for (int i=0; i<50; i++)
    {
        a[i] = 1+ rand()%30;
    }
}

void stampa(int a[50])
{
    for (int i=0; i<50; i++)
        printf("%d ",a[i]);
    printf("\n");
}
