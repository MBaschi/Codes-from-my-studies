#include<stdio.h>
#include<string.h>

#define N 3

struct studente {
    char cognome[26];
    char nome[26];
    char cdl[10];
    int voto;
    int lode;
    int anni;
};

struct studente archivio[N];

void RiempiVettore(struct studente v[], int dim){
    int i;
    
    for (i=0; i<dim;i++) {
        printf("Studente %d \n",i);
        printf("Cognome: \n");
        scanf("%s", v[i].cognome);
        printf("Nome: \n");
        scanf("%s", v[i].nome);
        printf("CdL \n");
        scanf("%s", v[i].cdl);
        printf("Voto di Laurea: \n");
        scanf("%d", &v[i].voto);
        fflush(stdin);
        printf("Lode (1-si, 0-no)\n");
        scanf("%d", &v[i].lode);
        fflush(stdin);
        printf("Anni di Studio: \n");
        scanf("%d", &v[i].anni);
        fflush(stdin);
    }
}

int StudentiMigliori (struct studente v[], int dim, int vsoglia, int asoglia)
{
    int i,count=0;
    
    for (i=0;i<dim; i++) {
        if (v[i].voto>=vsoglia &&v[i].anni==asoglia){
            printf("\nCognome %s ",v[i].cognome);
            printf("\nNome %s ",v[i].nome);
            printf("\nVoto %d ",v[i].voto);
            count++;
        }
    }
    return count;
}

int StudentiConLode (struct studente v[], int dim)
{
    int i,count=0;
    
    for (i=0;i<dim; i++) {
        if (v[i].voto == 110 && v[i].lode == 1){
            printf("\nCognome %s ",v[i].cognome);
            printf("\nNome %s ",v[i].nome);
            printf("\nCdL %s ",v[i].cdl);
            count++;
        }
    }
    return count;
}



double MediaCdL(struct studente v[], int dim, struct studente x)
{
    int i,count=0;
    double m=0.0;
    
    for (i=0;i<dim; i++) {
        if (!strcmp(v[i].cdl,x.cdl)) {
            m+=v[i].voto;
            count++;
        }
    }
    return m/count;
}

int main(int argc, const char * argv[]) {
    
    int scelta;
    struct studente elem;
    
    printf("********************* MENU *********************");
    do {
        printf("\n1 - Riempi Vettore ");
        printf("\n2 - Visualizza Studenti Migliori ");
        printf("\n3 - Visualizza Media di un certo CdL ");
        printf("\n4 - Visualizza Studenti con Lode ");
        printf("\n5 Fine ");
        printf("\nInserisci la tua scelta ---> ");
        scanf("%d",&scelta);
        fflush(stdin);
        switch (scelta) {
            case 1:
                RiempiVettore(archivio,N);
                break;
            case 2:
                printf("\nInserisci il voto minimo: ");
                scanf("%d", &elem.voto);
                fflush(stdin);
                
                printf("\nInserisci il numero di anni (3 o 5): ");
                scanf("%d", &elem.anni);
                fflush(stdin);
                
                StudentiMigliori(archivio,N,elem.voto,elem.anni);
                break;
            case 3:
                printf("\nInserisci il cdl: ");
                scanf("%s", elem.cdl);
                fflush(stdin);
                printf("\nLa Media e' %f",MediaCdL(archivio,N,elem));
                break;
            case 4:
                StudentiConLode(archivio, N);
                break;
        }
    } while (scelta < 5);
    return 0;
}
