#include <stdio.h>
#define N (20)
/* Il programma, attraverso funzioni, svolge calcoli su array di numeri inseriti dall'utente */
//Definisco la funzione che calcola la somma

int calcolaSomma(int array[],int lunghezza);
int main()
{
    int arr[N];
    int i;
    int lenght=0;
    int inserito;
    printf("Inserisci un nuovo valore, per un massimo di 20 numeri, su cui svolgere i calcoli:");
    scanf("%d",&inserito);
    if (inserito<0)
    {
        printf("Non hai inserito nessun valore valido");
        return 1;
    }
    
    i=0;
    do
    {
        arr[i]=inserito;
        i=i+1;
        lenght++;
        printf("Inserisci un nuovo valore, per un massimo di 20 numeri, su cui svolgere i calcoli:");
        scanf("%d",&inserito);
        
    } while(inserito>0 && i<N);
    printf("La somma dei numeri inseriti è: %d\n",calcolaSomma(arr,lenght));
    return 0;
}


int calcolaSomma(int array[], int lenght)
{
    int j;
    int somma=0;
    for(j=0;j<lenght;j++)
    {
        somma=somma+array[j];
    }
    return somma;
}






