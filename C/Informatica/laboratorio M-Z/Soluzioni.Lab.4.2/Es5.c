//
//  main.c
//  prova
//
//  Created by Anna Maria Nestorov on 27/11/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_L_NOME 50
#define MAX_L_INDIR 70
#define MAX_L_NUM_TEL 15

#define TRUE 1
#define FALSE 0


typedef struct {
    char nome[MAX_L_NOME+1];
    char indir[MAX_L_INDIR+1];
    char n_tel[MAX_L_NUM_TEL+1];
} ElementoArchivio;

/* Si definisce la struttura a lista */
struct nodo {
    ElementoArchivio e;
    struct nodo *next;
};

typedef struct nodo ElemLista;
typedef ElemLista *ArchivioALista;


void init_arch(ArchivioALista *arch)
{
    *arch = NULL;
}

int vuoto(ArchivioALista arch)
{
    if (arch == NULL)
        return TRUE;
    else
        return FALSE;
}

int head(ArchivioALista arch, ElementoArchivio *testa){
    if (vuoto(arch))
        return FALSE;
    else{
        *testa = arch->e;
        return TRUE;
    }
}

int tail(ArchivioALista arch, ArchivioALista *coda) {
    if (vuoto(arch))
        return FALSE;
    else{
        *coda = arch->next;
        return TRUE;
    }
}

int inser_per_nome(ArchivioALista *arch, ElementoArchivio el){
    ElemLista *pt_new_el;
    if (vuoto(*arch)) {
        pt_new_el = malloc (sizeof (ElemLista)); pt_new_el->e = el;
        pt_new_el->next = NULL;
        *arch = pt_new_el;
        return TRUE;
    }
    if (strcmp((*arch)->e.nome, el.nome) == 0)
    {
        return FALSE;
    }
    if (strcmp((*arch)->e.nome, el.nome) > 0) {
        pt_new_el = malloc (sizeof (ElemLista));
        pt_new_el->e = el;
        pt_new_el->next = *arch;
        *arch = pt_new_el;
        return TRUE;
    }
    else {
        return inser_per_nome(&((*arch)->next), el);
    }
}

int leggi_dati_voce(ElementoArchivio *el)
{
    ElementoArchivio new_voce;
    printf ("Inserire nome (max %d caratteri): \n",
            MAX_L_NOME);
    fpurge(stdin);
    fgets(new_voce.nome, (MAX_L_NOME + 1), stdin);
    if (strcmp (new_voce.nome, "") == 0) {
        return FALSE;
    }
    
    printf ("Inserire indirizzo (max %d caratteri): \n", MAX_L_INDIR);
    fpurge(stdin);
    fgets(new_voce.indir, MAX_L_INDIR + 1, stdin);
    
    printf ("Inserire num. telefonico (max %d caratteri): \n",
            MAX_L_NUM_TEL);
    fpurge(stdin);
    fgets(new_voce.n_tel, MAX_L_NUM_TEL + 1, stdin);
    *el = new_voce;
    return TRUE;
}

int canc_voce(ArchivioALista *arch, char *nome){
    ElemLista *temp;
    if (vuoto(*arch)){
        return FALSE;
    }
    if (strcmp ((*arch)->e.nome, nome) == 0) {
        temp = (*arch)->next;
        free (*arch);
        *arch = temp;
        return TRUE;
    }else {
        return canc_voce (&((*arch)->next), nome);
    }
}

void stampa_arch (ArchivioALista arch){
    if (!vuoto(arch))
    {
        printf ("Nome: %s\n", arch->e.nome);
        printf ("Indirizzo: %s\n", arch->e.indir);
        printf ("N. Telefono: %s\n\n", arch->e.n_tel);
        stampa_arch (arch->next);
    }
}

int main(int argc, const char * argv[]) {
    ElementoArchivio voce;
    ElementoArchivio nuova_voce;
    ArchivioALista arch, coda;
    char nome_da_canc[MAX_L_NOME];
    int nomeNoError, insNoError;
    int uscita = FALSE;
    int scelta;
    init_arch(&arch);
    
    while (!uscita) {
        printf ("\n ****************** MENU ARCHIVIO ****************** \n");
        printf ("1. Inizializza archivio \n");
        printf ("2. Verifica se l'archivio è vuoto\n");
        printf ("3. Inserisci nuova voce nell'archivio\n");
        printf ("4. Cancella una voce dell'archivio \n");
        printf ("5. Stampare l'archivio \n");
        printf ("6. Stampare il nome della prima voce dell'archivio \n");
        printf ("7. Stampare la coda dell'archivio \n");
        printf ("0. Esci dal programma\n");
        printf ("\nScelta: ");
        scanf ("%d", &scelta);
        
        switch (scelta) {
            case 1:
                init_arch(&arch);
                printf ("\nArchivio iniziallizato con successo.\n");
                break;
            case 2:
                if(vuoto(arch))
                    printf("L'archivio è vuoto.\n");
                else
                    printf("L'archivio non è vuoto. \n");
                break;
            case 3:
                nomeNoError = leggi_dati_voce(&nuova_voce);
                if (nomeNoError == FALSE){
                    printf("Errore: il campo nome è vuoto!.");
                }
                else{
                    insNoError = inser_per_nome(&arch, nuova_voce);
                    if(insNoError == FALSE)
                        printf("Il nome '%s' è già presente nell'archivio. \n", nuova_voce.nome);
                    else
                        printf("La voce è stata inserita correttamente nell'archivio!\n");
                }
                break;
            case 4:
                printf("Inserisci il nome da cancellare dall'archivio: \n");
                fpurge(stdin);
                fgets(nome_da_canc, (MAX_L_NOME + 1), stdin);
                canc_voce (&arch, nome_da_canc);
                printf ("Nuovo contenuto dell'archivio:\n");
                stampa_arch(arch);
                break;
            case 5:
                printf("Il contenuto dell'archivio: \n");
                stampa_arch(arch);
                break;
            case 6:
                if (head(arch, &voce)) {
                    printf ("\nNome prima voce: %s\n", voce.nome);
                }
                else{
                    printf("L'archivio è vuoto!\n");
                }
                break;
            case 7:
                if (tail(arch, &coda))
                {
                    printf ("\nContenuto coda:\n");
                    stampa_arch(coda);
                }
                else{
                    printf("L'archivio è vuoto!\n");
                }
                break;
            case 0:
                printf ("Uscita...\n");
                uscita = TRUE;
                break;
            default:
                printf ("Opzione non riconosciuta...\n");
                break;
        }
    }
    
}
