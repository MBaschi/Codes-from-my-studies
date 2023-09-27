#include <stdio.h>

int max(int a[], int dim);
int min(int a[], int dim);
int somma(int array[20], int len);
float media(int somma, int len);
int dispari(int arrayIn[20], int cont, int *arrayOut);
int primo(int val);
int soloPrimi(int arrayIn[20], int cont, int arrayOut[20]);

int main(int argc, const char * argv[]) {
    int val_max;
    int val_min;
    int val[20];
    int val_media[18];
    int soloDispari[20];
    int numPrimi[20];
    int contSoloDisp;
    int conSoloPrimi;
    int cont = 0;
    int cont_media = 0;
    int i,j;
    int sum;
    float mean;
    int num;
    int exit = 0;
    
    
    printf ("Inserisci numeri: \n");
    for (i=0; i<20 && exit == 0; i++){
        scanf("%d",&num);
        if(num >=0){
            val[i]=num;
        }
        else{
            exit = 1;
        }
    }
    cont = i - 1;
    
    val_max = max(val, cont);
    val_min = min(val, cont);
    
    for(i=0, j=0; i<20; i++){
        if((val[i] < val_max) && (val[i] > val_min)){
            val_media[j] = val[i];
            j++;
        }
    }
    cont_media = j;
    
    sum = somma(val_media,cont_media);
    mean = media(somma(val_media,cont_media), cont_media);
    
    printf("somma: %d\n",sum);
    printf("media: %.2f\n",mean);
    
    contSoloDisp = dispari(val,cont,soloDispari);
    printf("Questi sono i numeri dispari appena inseriti:\n");
    for (i=0; i<contSoloDisp; i++)
        printf("%d\n",soloDispari[i]);
    
    conSoloPrimi = soloPrimi(val, cont, numPrimi);
    printf("Questi sono i numeri primi appena inseriti:\n");
    for (i=0; i<conSoloPrimi; i++)
        printf("%d\n",numPrimi[i]);
    
    return 0;
}

int max(int a[], int dim)

{
    int max=a[0];
    int i;
    for (i=1; i<dim; i++) {
        if (max<a[i])
        {
            max=a[i];
        }
    }
    return max;
}

int min(int a[], int dim)
{
    int i;
    int min = a[0];
    for (i=1; i<dim; i++) {
        if (min>a[i])
        {
            min=a[i];
        }
    }
    return min;
}

int somma(int array[20], int len)
{
    int s = 0;
    for (int j=0; j<len; j++)
        s = s + array[j];
    return s;
}

float media(int somma, int len)
{
    return somma/(float)len;
}

int dispari(int arrayIn[20], int cont, int *arrayOut)
{
    int j = 0;
    for (int i=0; i<cont; i++)
    {
        if (arrayIn[i]%2==1){
            arrayOut[j] = arrayIn[i];
            j++;
        }
    }
    return j;
}

int primo(int num)
{
    int i;
    if (num==0)
        return 0;
    if (num==1)
        return 1;
    for (i=2; (i<num && num%i!=0); i++);
    if (i==num)
        return 1;
    else
        return 0;
}

int soloPrimi(int arrayIn[20], int cont, int arrayOut[20])
{
    int j = 0;
    for (int i=0; i<cont; i++)
    {
        if (primo(arrayIn[i])==1){
            arrayOut[j] = arrayIn[i];
            j++;
        }
    }
    return j;
}
