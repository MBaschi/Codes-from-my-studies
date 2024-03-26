#include <stdio.h>

int leggi(double prezzi[100]);
void inserisciSconto(double sconti[100], int cont);
void prezziScontati(double p[100], double s[100], double ps[100], int cont);

int main(int argc, const char * argv[]) {
    double prezzi[100];
    double sconti[100];
    double pScontati[100];
    
    int cont;
    
    cont = leggi(prezzi);
    inserisciSconto(sconti, cont);
    prezziScontati(prezzi, sconti, pScontati, cont);
    
    printf("I prezzi scontati sono: \n");
    for (int i=0; i<cont; i++)
        printf("%.2lf €",pScontati[i]);
    return 0;
}

int leggi(double prezzi[100])
{
    int i=0;
    printf ("Inserisci prezzi (-1 per terminare): ");
    for (i=0; i<100; i++)
    {
        scanf("%lf",&prezzi[i]);
        if (prezzi[i] < 0)
            break;
    }
    if (i==0)
        return 0;
    return i;
}

void inserisciSconto(double sconti[100], int cont)
{
    int i=0;
    printf ("Inserisci sconti: ");
    for (i=0; i<cont; i++)
    {
        scanf("%lf",&sconti[i]);
        if (sconti[i] < 0)
            break;
    }
}

void prezziScontati(double p[100], double s[100], double ps[100], int cont)
{
    for (int i=0; i<cont; i++)
        ps[i] = p[i]-s[i]/100.0*p[i];
}
