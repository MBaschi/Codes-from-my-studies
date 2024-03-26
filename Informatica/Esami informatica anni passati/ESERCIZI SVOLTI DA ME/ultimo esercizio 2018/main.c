//Definisco la struttura dati di una lista di valutazioni
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define M 20
#define N 10



typedef struct voto_s {
    char data[11]; //AAAA/MM/GG
    double voto;
    struct voto_s *next;
} voto_t;

typedef voto_t *ptrVoti;



//Definisco la struttura dati di una lista di studenti
typedef struct studente_s {
    char nome[M];
    char cognome[M];
    ptrVoti listaVoti;
    struct studente_s* next;
} studente_t;

typedef studente_t *ptrStudenti;



//Definisco la struttura dati di un registro
typedef struct {
    int anno;
    char classe[N];
    ptrStudenti listaStudenti;
} registro_t;


ptrStudenti inserimentoNuovoStudente (ptrStudenti testa, char nome[], char cognome[]);



//Definisco la funzione che inserisce i nuovi voti nella lista dei voti
ptrVoti inserimentoVoti(ptrVoti testa, char date[], double vote) {
    ptrVoti nuovoElemento = NULL;
    //printf("\n*PROVA*\n");
    if(testa == NULL)
    {
        nuovoElemento = (ptrVoti)malloc(sizeof(voto_t));
        strcpy(nuovoElemento->data, date);
        nuovoElemento->voto = vote;
        nuovoElemento->next = NULL;
        return nuovoElemento;
    }
    else
    {
        //printf("\n*PROVA*\n");
        testa->next = inserimentoVoti(testa->next, date, vote);
        return testa;
    }
}

//Definisco la funzione che inserisce ordinatamente nuovi studenti nella lista degli studenti
ptrStudenti inserimentoStudenti(ptrStudenti testa, char name[], char surname[], ptrVoti votiStudente)
{
    ptrStudenti nuovoElemento = NULL;
    ptrStudenti prec;      //Puntatore all'elemento precedente il nuovo elemento
    ptrStudenti scorri;    //Puntatore all'elemento successivo
    nuovoElemento = (ptrStudenti)malloc(sizeof(studente_t));
    strcpy(nuovoElemento->nome, name);
    strcpy(nuovoElemento->cognome, surname);
    nuovoElemento->listaVoti = votiStudente;
    //Condizione iniziale
    prec = NULL;
    scorri = testa;
    // Verifico che non sia arrivato in fondo e che il numero da inserire sia maggiore dell'elemento precedente
    while(scorri != NULL && (strcmp(surname, scorri->cognome) > 0))
    {
        //Avanzo i puntatori
        prec = scorri;
        scorri = scorri->next;
    }
    //Gestisco un inserimento in testa o in lista vuota --> Il ciclo non è¨ mai stato attivato
    if(prec == NULL)
    {
        nuovoElemento->next = scorri;
        return nuovoElemento;
    }
    if(scorri != NULL && (strcmp(surname, scorri->cognome) == 0))
    {
        while(scorri != NULL && (strcmp(name, scorri->nome) > 0))
        {
            //Avanzo i puntatori
            prec = scorri;
            scorri = scorri->next;
        }
    }
    //Dopo aver iterato
    nuovoElemento->next = scorri;
    prec->next = nuovoElemento;
    return testa;
}
//Definisco la funzione che inizializza i voti di uno studente
ptrVoti scanVoti(ptrVoti testa)
{
    char boole[3];
    double votoStudente;
    char dataVoto[11];
    
    printf("Si desidera inserire un nuovo voto?\n");
    printf("Digiti si o no:\n");
    scanf("%s", boole);
    while(boole[0] == 's')
    {
        printf("Inserisci la data\n-> ");
        scanf("%s",dataVoto);
        printf("Inserisci il voto\n-> ");
        scanf("%lf", &votoStudente);
        testa = inserimentoVoti(testa, dataVoto, votoStudente);
        printf("Si desidera inserire un nuovo voto?\n");
        printf("Digiti si o no:\n");
        scanf("%s", boole);
    }
    return testa;
}
//Definisco la funzione che inizializza la lista studenti
ptrStudenti scanStudenti(ptrStudenti testa)
{
    char boole[3];
    char nomeStudente[M];
    char cognomeStudente[M];
    ptrVoti testaVoti;
    
    printf("Si desidera memorizzare un nuovo studente?\n");
    printf("Digiti si o no:\n");
    scanf("%s", boole);
    while(boole[0] == 's')
    {
        printf("Inserisci il nome dello studente\n-> ");
        scanf("%s", nomeStudente);
        printf("Inserisci il cognome dello studente\n-> ");
        scanf("%s", cognomeStudente);
        testaVoti = NULL;
        testaVoti = scanVoti(testaVoti);
        testa = inserimentoStudenti(testa, nomeStudente, cognomeStudente, testaVoti);
        printf("Si desidera memorizzare un nuovo studente?\n");
        printf("Digiti si o no:\n");
        scanf("%s", boole);
    }
    return testa;
}
//Definisco la funzione che stampa i voti di uno studente
void stampaVoti(ptrVoti testa)
{
    if(testa != NULL)
    {
        printf("%.2lf (%s)\n", testa->voto, testa->data);
        stampaVoti(testa->next);
    }
    else return;
    
}
//Definisco la funzione che stampa i dati di uno studente
void stampaStudente(ptrStudenti testa)
{
    if(testa != NULL)
    {
        printf("%s %s\n", testa->nome, testa->cognome);
        stampaVoti(testa->listaVoti);
        stampaStudente(testa->next);
        
    }
    else return;
}
//Definisco una funzione per aggiungere un voto ad uno studente
ptrStudenti inserireVoto(ptrStudenti testa, char name[], char surname[], char date[], double vote)
{
    int boole = 0;
    while(testa != NULL)
    {
        if((strcmp(testa->nome, name) == 0) && (strcmp(testa->cognome, surname) == 0))
        {
            testa->listaVoti = inserimentoVoti(testa->listaVoti, date, vote);
            boole = 1;
        }
        testa = testa->next;
    }
    if(boole == 0)
    {
        printf("Lo studente inserito non esiste nel registro memorizzato. La lista non è stata modificata\n");
        return testa;
    }
    else return testa;
}
//Definisco una funzione che somma il numero di voti riferiti ad uno studente
double sommaVoti(ptrVoti testa, int *numero)
{
    //Caso base
    if(testa == NULL)
    {
        return 0;
    }
    else
    {
        *(numero) = *(numero) + 1;
        return (testa->voto + sommaVoti(testa->next, &numero));
    }
}
//Definisco una funzione che calcola la media dei voti di uno studente
double mediaVoti(ptrStudenti testa, char name[], char surname[], int *numero)
{
    double somma, media;
    while (testa != NULL)
    {
        if((strcmp(testa->nome, name) == 0) && (strcmp(testa->cognome, surname) == 0))
        {
            somma = sommaVoti(testa->listaVoti, &numero);
        }
        testa = testa->next;
    }
    media = somma/(*(numero));
    return media;
}


ptrStudenti inserimentoNuovoStudente (ptrStudenti testa, char name[], char surname[]) {
    ptrStudenti nuovoElemento = NULL;
    ptrStudenti prec = NULL;
    ptrStudenti scorri = testa;
    
    nuovoElemento = (ptrStudenti)malloc(sizeof(studente_t));
    strcpy(nuovoElemento->nome, name);
    strcpy(nuovoElemento->cognome, surname);
    nuovoElemento->listaVoti = NULL;
    
    while (scorri != NULL && (strcmp(surname,scorri->cognome))>0) {
        prec = scorri;
        scorri = scorri->next;
    }
    if (scorri != NULL && (strcmp(surname,scorri->cognome))==0) {
        while (scorri != NULL && (strcmp(name,scorri->nome))>0) {
            prec = scorri;
            scorri = scorri->next;
        }
    }
    if (prec == NULL) {
        nuovoElemento->next = scorri;
        return nuovoElemento;
    }
    prec->next = nuovoElemento;
    nuovoElemento->next =scorri;
    return testa;
}






int main() {
    int scelta = 0;
    registro_t registro;
    ptrStudenti classeStudenti = NULL;
    int numeroVoti = 0;
    double mediaStudente;
    char nomeStudente[M];
    char cognomeStudente[M];
    char dataNuovoVoto[11];
    double nuovoVoto;
    printf("Registro di classe 2.0\n");
    printf("Inserire l'anno scolastico corrente\n-> ");
    scanf("%d", &(registro.anno));
    printf("Inserire il nome della classe\n-> ");
    scanf("%s", registro.classe);
    classeStudenti = scanStudenti(classeStudenti);
    registro.listaStudenti = classeStudenti;
    while(scelta != 4)
    {
        printf("REGISTRO ELETTRONICO, anno %d, classe %s\n", registro.anno, registro.classe);
        printf("Menu'\n");
        printf("Digitare 1 per visualizzare il registro memorizzato\n");
        printf("Digitare 2 per aggiungere un nuovo voto ad uno studente\n");
        printf("Digitare 3 per calcolare la media voto di uno studente\n");
        printf("Digitare 4 per terminare\n-> ");
        scanf("%d", &scelta);
        switch (scelta) {
            case 1 :
                printf("Il registro memorizzato e' il seguente\n");
                stampaStudente(registro.listaStudenti);
                break;
            case 2 :
                printf("Inserire il nome dello studente-> ");
                scanf("%s", nomeStudente);
                printf("Inserire il cognome dello studente-> ");
                scanf("%s", cognomeStudente);
                registro.listaStudenti = inserimentoNuovoStudente(registro.listaStudenti, nomeStudente, cognomeStudente);
                break;
            case 3 :
                printf("Inserire il nome dello studente\n-> ");
                scanf("%s", nomeStudente);
                printf("Inserire il cognome dello studente\n-> ");
                scanf("%s", cognomeStudente);
                mediaStudente = mediaVoti(registro.listaStudenti,nomeStudente,cognomeStudente,&numeroVoti);
                printf("La media dello studente inserito e': %f", mediaStudente);
                break;
            case 4 :
                printf("Spegnimento in corso...\n");
                return 1;
        }
    }
    return 0;
}





