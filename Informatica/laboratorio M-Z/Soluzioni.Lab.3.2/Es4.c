//
//  main.c
//  prova
//
//  Created by Anna Maria Nestorov on 27/11/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <math.h>

/* costante booleana */
typedef enum {falso, vero} boolean;

/* punto nel piano */
typedef struct {
    float x;
    float y;
}punto;

/* retta (o segmento) per due punti */
typedef struct {
    punto p1;
    punto p2;
}segmento;

/* triangolo (individuato dai suoi vertici)  */
typedef struct {
    punto p1;
    punto p2;
    punto p3;
}triangolo;


boolean Ver_All(punto p1, punto p2, punto p3)
{
    boolean all = falso;
    float temp1, temp2;
    temp1 = (p1.x - p2.x) * (p1.y - p3.y);
    temp2 = (p1.x - p3.x) * (p1.y - p2.y);
    
    if(temp1 == temp2)
        all = vero;
    return all;
}

punto PuntoM (segmento seg_)
{
    punto punto_medio;
    punto_medio.x = (seg_.p1.x + seg_.p2.x) / 2.0;
    punto_medio.y = (seg_.p1.y + seg_.p2.y) / 2.0;
    return (punto_medio);
}

float PerimetroT (triangolo *ptri)
{
    double AB, BC, CA;
    float sum = 0;
    AB = sqrt(pow((double)(ptri->p1.x - ptri->p2.x), (double)2) + (pow((double)(ptri->p1.y - ptri->p2.y), (double)2)));
    BC = sqrt(pow((double)(ptri->p2.x - ptri->p3.x), (double)2) + (pow((double)(ptri->p2.y - ptri->p3.y), (double)2)));
    CA = sqrt(pow((double)(ptri->p3.x - ptri->p1.x), (double)2) + (pow((double)(ptri->p3.y - ptri->p1.y), (double)2)));
    sum = (float)(AB+BC+CA);
    return(sum);
}

punto Baricentro (triangolo tri)
{
    punto punto_b;
    punto_b.x = (tri.p1.x + tri.p2.x + tri.p3.x) / 3.0;
    punto_b.y = (tri.p1.y + tri.p2.y + tri.p3.y) / 3.0;
    return (punto_b);
}

void StampaP (punto p)
{
    printf("\n x: %5.2f   y: %5.2f\n", p.x, p.y);
}


int main(int argc, const char * argv[]) {
    punto punto1, punto2, punto3, punto4;
    segmento segmento1;
    triangolo triangolo1;
    boolean allineamento;
    int scelta = -1;
    while(scelta != 0) {
        printf(" \n***************** MENU *****************\n");
        printf("\n 0: uscita");
        printf("\n 1: allineamento");
        printf("\n 2: punto medio");
        printf("\n 3: perimetro triangolo");
        printf("\n 4: baricentro");
        printf("\n Inserisci la scelta --> ");
        scanf("%d", &scelta);
        switch(scelta) {
            case 1:
                printf("\nAscissa e ordinata del primo punto:    ");
                scanf("%f %f", &punto1.x, &punto1.y);
                printf("\nAscissa e ordinata del secondo punto:  ");
                scanf("%f %f", &punto2.x, &punto2.y);
                printf("\nAscissa e ordinata del terzo punto:    ");
                scanf("%f %f", &punto3.x, &punto3.y);
                
                allineamento = Ver_All(punto1, punto2, punto3);
                if(allineamento == vero)
                    printf("\ni punti sono allineati");
                else
                    printf("\ni punti non sono allineati\n");
                break;
                
            case 2:
                printf("\nAscissa e ordinata del primo punto:    ");
                scanf("%f %f", &segmento1.p1.x, &segmento1.p1.y);
                printf("\nAscissa e ordinata del secondo punto:  ");
                scanf("%f %f", &segmento1.p2.x, &segmento1.p2.y);
                
                punto4 = PuntoM(segmento1);
                StampaP(punto4);
                break;
                
            case 3:
                printf("\nAscissa e ordinata del primo punto:    ");
                scanf("%f %f", &triangolo1.p1.x, &triangolo1.p1.y);
                printf("\nAscissa e ordinata del secondo punto:  ");
                scanf("%f %f", &triangolo1.p2.x, &triangolo1.p2.y);
                printf("\nAscissa e ordinata del terzo punto:  ");
                scanf("%f %f", &triangolo1.p3.x, &triangolo1.p3.y);
                
                printf("\nIl perimetro del triangolo: %5.2f", PerimetroT(&triangolo1));
                break;
                
            case 4:
                printf("\nAscissa e ordinata del primo punto:    ");
                scanf("%f %f", &triangolo1.p1.x, &triangolo1.p1.y);
                printf("\nAscissa e ordinata del secondo punto:  ");
                scanf("%f %f", &triangolo1.p2.x, &triangolo1.p2.y);
                printf("\nAscissa e ordinata del terzo punto:  ");
                scanf("%f %f", &triangolo1.p3.x, &triangolo1.p3.y);
                
                punto4 = Baricentro(triangolo1);
                StampaP(punto4);
                break;
        }
    }
    
}
