#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define N 10

void genera_array(int x[]) {
    int i;
    
    for (i=0; i<N; i++) {
        x[i] = rand()%200;
    }
}

void stampa(int x[], int n) {
    int i;
    
    for (i=0; i<n; i++)
        printf("%d ", x[i]);
    printf("\n");
    return;
}

void fondi(int v1[], int v2[], int v3[], int n)
{
    int i;
    for (i=0; i<n; i++){
        v3[2*i] = v1[i];
        v3[2*i+1] = v2[i];
    }
}

int main(int argc, const char * argv[]) {
    int v1[N], v2[N], v3[2*N];
    
    srand((unsigned)time(NULL));
    
    genera_array(v1);
    genera_array(v2);
    printf("Primo vettore: \n");
    stampa(v1, N);
    printf("Secondo vettore: \n");
    stampa(v2, N);
    fondi(v1,v2,v3,N);
    printf("Terzo vettore: \n");
    stampa(v3,2*N);
    return(0);
}
