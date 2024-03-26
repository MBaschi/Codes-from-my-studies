#include <stdio.h>

int somma_dif(int array[20], int len, int *diff);
float media(int somma, int len);
int pari(int arrayIn[20], int cont, int *arrayOut);
int primo(int val);
int soloPrimi(int arrayIn[20], int cont, int arrayOut[20]);

int main(int argc, const char * argv[]) {
    int val[20];
    int soloPari[20];
    int numPrimi[20];
    int contSoloPari;
    int conSoloPrimi;
    int cont = 0;
    int i;
    int sum,diff;
    float mean;
    
    
    printf ("Inserisci numeri: ");
    for (i=0; (i<20 && val[i-1]>=0); i++)
        scanf("%d",&val[i]);
    cont = i -1;
    
    sum = somma_dif(val,cont,&diff);
    mean = media(somma_dif(val,cont,&diff), cont);
    
    printf("somma: %d\n",sum);
    printf("differenza: %d\n",diff);
    printf("media: %.2f\n",mean);
    
    contSoloPari = pari(val,cont,soloPari);
    printf("Questi sono i numeri pari appena inseriti:\n");
    for (i=0; i<contSoloPari; i++)
        printf("%d\n",soloPari[i]);
    
    conSoloPrimi = soloPrimi(val, cont, numPrimi);
    printf("Questi sono i numeri primi appena inseriti:\n");
    for (i=0; i<conSoloPrimi; i++)
        printf("%d\n",numPrimi[i]);
    
    return 0;
}

int somma_dif(int array[20], int len, int *diff)
{
    int s = 0;
    *diff = 0;
    for (int j=0; j<len; j++)
    {
        s = s + array[j];
        *diff = *diff-array[j];
    }
    return s;
}

float media(int somma, int len)
{
    return somma/(float)len;
}

int pari(int arrayIn[20], int cont, int *arrayOut)
{
    int j = 0;
    for (int i=0; i<cont; i++)
    {
        if (arrayIn[i]%2==0){
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


