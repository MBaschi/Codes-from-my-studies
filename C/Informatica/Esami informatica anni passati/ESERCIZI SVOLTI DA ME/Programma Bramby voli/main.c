#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX 10

typedef struct{
    int giorno;
    int mese;
    int anno;
} data_t;

typedef struct node_s {
    data_t data;
    int id;
    int codice;
    char arrival[MAX];
    char departure[MAX];
    int part_previsa;
    int part_reale;
    int arr_previsto;
    int arr_reale;
    struct node_s *next;
} node_t;

typedef node_t* ptrNode;

ptrNode inserimento(ptrNode testa);
void stampaLista(ptrNode testa);
double media_ritardi(ptrNode testa, char aeroporto[], int anno);
double voto_aereo(ptrNode testa, char aeroporto[]);

int main() {
    ptrNode testaMain = NULL;
    int choice;
    char aeroporto1[MAX];
    char aeroporto2[MAX];
    int anno;
    
    do{
        printf("\nScegliere dal menù l'azione che si desidera svolgere:\n1) Per inserire un altro volo nella lista\n2) Per stampare la lista\n3) Restituisci media dei ritardi dei voli in arrivo\n4) Per restituire il voto numerico per quell'aeroporto\n5) Per uscire\n");
        scanf("%d", &choice);
        switch (choice){
            case 1:
                testaMain = inserimento(testaMain);
                break;
            case 2:
                stampaLista(testaMain);
                break;
            case 3:
                printf("Inserisci il nome dell'aeroporto di arrivo e l'anno di riferimento per avere la media dei ritardi dei voli in arrivo relativa a quell'anno->");
                scanf("%s%d", aeroporto1, &anno);
                printf("La media dei ritardi dei voli per quell'anno è %f\n", media_ritardi(testaMain,aeroporto1,anno));
                break;
            case 4:
               printf("Inserisci il nome dell'aeroporto per saperne il voto-> \n");                scanf("%s", aeroporto2);
                printf("Il voto per quell'aeroporto è %f\n", voto_aereo(testaMain,aeroporto2));
                break;
            case 5:
                break;
            default:
                printf("Valore inserito non valido! Inseriscine un'altro:\n");
                break;
        }
    }while(choice!=5);
    
    printf("\nEnd of the programme\n");
    return 0;
}
                       
ptrNode inserimento(ptrNode testa){
    ptrNode nuovo_volo = NULL;
    nuovo_volo = (ptrNode)malloc(sizeof(node_t));
    
    printf("Inserisci Data:\nGiorno-> ");
    scanf("%d", &nuovo_volo->data.giorno);
    printf("\nMese-> ");
    scanf("%d", &nuovo_volo->data.mese);
    printf("\nAnno-> ");
    scanf("%d", &nuovo_volo->data.anno);
    printf("\nInserisci identificativo volo-> ");
    scanf("%d", &nuovo_volo->id);
    printf("\nInserisci codice operatore-> ");
    scanf("%d", &nuovo_volo->codice);
    printf("\nInserisci aereoporto arrivo-> ");
    scanf("%s", nuovo_volo->arrival);
    printf("\nInserisci aereoporto partenza-> ");
    scanf("%s", nuovo_volo->departure);
    printf("\nInserisci orario partenza previsto-> ");
    scanf("%d", &nuovo_volo->part_previsa);
    printf("\nInserisci orario partenza reale-> ");
    scanf("%d", &nuovo_volo->part_reale);
    printf("\nInserisci orario arrivo previsto-> ");
    scanf("%d", &nuovo_volo->arr_previsto);
    printf("\nInserisci orario arrivo reale> ");
    scanf("%d", &nuovo_volo->arr_reale);
    nuovo_volo->next = testa;
    return(nuovo_volo);
}

void stampaLista(ptrNode testa) {
    if (testa==NULL)
        return;
    else{
        printf("Stampo data: \n*Giorno -> %d\n*Mese -> %d\n*Anno -> %d ", testa->data.giorno, testa->data.mese, testa->data.anno);
        printf("\nIndentificativo numerico -> %d", testa->id);
        printf("\nCodice operatore -> %d", testa->codice);
        printf("\nAeroporto arrivo -> %s", testa->arrival);
        printf("\nAeroporto partenza -> %s", testa->departure);
        printf("\nOrario partenza previsto-> %d", testa->part_previsa);
        printf("\nOrario partenza reale -> %d", testa->part_reale);
        printf("\nOrario arrivo previsto -> %d", testa->arr_previsto);
        printf("\nOrario arrivo reale -> %d\n\n", testa->arr_reale);
        
        stampaLista(testa->next);
    }
}

double media_ritardi(ptrNode testa, char aeroporto[], int anno){
    double somma_min_ritardo=0;
    int num_ritardi=0;
    double media;
    
    for(;testa != NULL; testa=testa->next) {
        if(strcmp(testa->arrival,aeroporto)==0 && testa->data.anno==anno && ((testa->arr_reale)-(testa->arr_previsto))>15) {
            somma_min_ritardo += testa->arr_reale-testa->arr_previsto;
            ++num_ritardi;
        }
    }
    if (somma_min_ritardo==0 || num_ritardi==0) {
        media=0;
    }
    else {
        media = somma_min_ritardo/num_ritardi;
    }
    return media;
}

double voto_aereo(ptrNode testa, char aeroporto[]) {
    double voto=0;
    double voto_arrivo_ritardo=0;
    double voto_partenza_ritardo=0;
    
    if (testa!= NULL && strcmp(aeroporto,testa->arrival)==0 && ((testa->arr_reale)-(testa->arr_previsto))>15) {
        voto_arrivo_ritardo = 0.5 + voto_aereo(testa->next, aeroporto);
    }
    if (testa!= NULL && strcmp(aeroporto,testa->departure)==0 && ((testa->part_reale)-(testa->part_previsa))>15) {
        voto_partenza_ritardo = 1 + voto_aereo(testa->next, aeroporto);
    }
    
    voto=voto_arrivo_ritardo + voto_partenza_ritardo;
    return voto;
}


