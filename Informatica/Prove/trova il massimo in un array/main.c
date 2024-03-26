
#include <stdio.h>

int trova_massimo (const int array[]);

int main() {
    int array[10];
    int i;
    int massimo_corrente;
    
    printf("Inserisci gli elementi dell'array->\n");
    
    for (i=0; i<10; ++i) {
        printf("Inserisci il valore->\n");
        scanf("%d", &array[i] );
    }
    
    printf("Ecco i numeri fino ad ora inseriti\n");
    
    int n=10;
    int min;
    int l,j;
    int temp;
    
    for(l=0; l<n-1; l++)
    {
        min = l;
        
        for(j=l+1; j<n; j++)
            if(array[j] < array[min])
                min = j;
        temp=array[min];
        array[min]=array[l];
        array[l]=temp;
    }
    for (i=0; i<10; ++i) {
        printf("%d elemento --> %d\n", i+1, array[i]);
    }
    
    massimo_corrente = trova_massimo (&array[0]);
    printf("Il massimo valore inserito dall'utente è %d\n", massimo_corrente);
    
}

int trova_massimo ( const int array[]) {
    int i;
    int massimo_corrente;
    
    massimo_corrente = array[0];
    
    for (i=1; i<10; ++i) {
        if (array[i]>massimo_corrente) {
            massimo_corrente = array[i];
        }
    }
    return massimo_corrente;
}



