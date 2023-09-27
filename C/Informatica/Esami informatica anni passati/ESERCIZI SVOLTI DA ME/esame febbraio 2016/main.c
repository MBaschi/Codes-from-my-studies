#include <stdio.h>
#include <math.h>
#define MAX 99

void inseriscivertici (double x[],double y[], int l);
int calcolaPerimetro(double* perimetro,double x[],double y[], int l);

int main() {
    double xx[MAX], yy[MAX];
    int leng;
    double perimetro;
    int risultato;
    double* p;
    p = &perimetro;
    
    printf("Inserisci il numero di vertici che ha il poligono -> \n");
    scanf("%d", &leng);
    
    inseriscivertici(xx, yy, leng);
    risultato = calcolaPerimetro(p, xx, yy, leng);
    
    printf("Il perimetro del poligono è %f ", perimetro);
    if (risultato == 1) {
        printf("e il poligono non ha vertici nel secondo o quarto quadrante\n");
    }
    else {
        printf("e il poligono ha anche vertici nel secondo e quarto quadrante\n");
    }
    return 0;
}

void inseriscivertici(double x[],double y[], int l) {
    int i;
    for (i=0; i<l; i++) {
        printf("Inserisci l'ascissa e l'ordinata del vertice numero %d -> ", i+1);
        scanf("%lf%lf", &x[i], &y[i]);
    }
}

int calcolaPerimetro(double* perimetro, double x[],double y[], int l) {
    double sommaparziale = sqrt( (x[0]-x[l])*(x[0]-x[l]) + (y[0]-y[l])*(y[0]-y[l]));
    int i,j;
    int r=1;
    
    for(i=0; i<l-1; i++) {
    sommaparziale += sqrt( (x[i]-x[i+1])*(x[i]-x[i+1])+(y[i]-y[i+1])*(y[i]-y[i+1]) );
    }
    *perimetro = sommaparziale;
    
    for (j=0; j<l && r==1; j++) {
        if ((x[j]>=0 && y[j]>=0) || (x[j]<=0 && y[j]<=0)) {
        }
        else {
            r=0;
            break;
        }
    }
    return r;
}
