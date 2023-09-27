#define DIM 3
#include <stdio.h>

void invertiArray(int *a, int *iArray);

int main(int argc, const char * argv[]) {
    int array[DIM];
    int inv[DIM];
    
    printf("Riempire array:\n");
    for (int i=0; i<DIM; i++)
        scanf("%d",&array[i]);
    invertiArray(array, inv);
    
    printf("Invertito:\n");
    for (int i=0; i<DIM; i++)
        printf("%d\n", *(inv+i));
    return 0;
}

void invertiArray(int *a, int *iArray)
{
    for (int i=0; i<DIM; i++){
        *(iArray+i) = a[DIM-1-i];
    }
}
