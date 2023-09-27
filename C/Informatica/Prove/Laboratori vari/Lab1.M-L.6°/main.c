#include <stdio.h>

int somma(int *array, int dimensione);
int min(int *array, int dimensione);
int max(int array[], int dimensione);
double media(int dimensione, int max, int min, int somma);
int dispari(int array[], int dimensione, int *arrayOut);
int primo(int numero);
int main() {
    int i;
    int j;
    int num;
    int exit =0;
    int array[20];
    int quantidisparitrovati;
    int solodispari[20];
    
    
    
    printf ("Inserisci numeri: \n");
    for (i=0; i<20 && exit == 0; i++){
        scanf("%d",&num);
        if(num >=0){
            array[i]=num;
        }
        else
            break;
    }
    printf("la somma è: %d\n", somma(array,i));
    printf("il minimo è %d\n", min(array,i));
    printf("il massimo è %d\n", max(array,i));
    printf("la media dei numeri esclusi il massimo ed il minimo è %f\n",media(i, max(array,i), min(array,i), somma(array, i)));
    quantidisparitrovati = dispari(array, i, solodispari);
    printf("i numeri dispari inseriti sono->");
    for (j=0;j<quantidisparitrovati; j++) {
        printf("%d ",solodispari[j]);
    }
}

int somma(int *array,int dimensione) {
    int somma=0;
    int i;
    for (i=0; i<dimensione; i++) {
        somma += *(array + i);
    }
    return (somma);
}

int min(int *array, int dimensione) {
    int min = array[0];
    int i;
    for (i=1; i<dimensione; i++) {
        if(array[i]<min) {
            min = array[i];
        }
    }
    return (min);
}


int max(int array[], int dimensione) {
    int max = array[0];
    int i;
    for (i=1; i<dimensione; i++) {
        if(array[i]>max) {
            max = array[i];
        }
    }
    return (max);
}

double media(int dimensione, int max, int min, int somma) {
    double media;
    media = (float)(somma - max - min)/(dimensione-2);
    return(media);
}

int dispari(int array[], int dimensione,int *arrayOut) {
    int j=0;
    for (int i=0; i<dimensione; i++) {
        if(array[i]%2 == 1) {
            arrayOut[j]=array[i];
            j++;
        }
    }
    return (j);
}

int primo(int numero)
{
    int i;
    if (numero==0) {
        return 0;
    }
    if (numero==1){
        return 0;
    }
    for(i=2; (i<numero && numero%i!= 0); i++) {
        if (i==numero) {
            return 1;
        }
        else
            return 0;
    }
}

