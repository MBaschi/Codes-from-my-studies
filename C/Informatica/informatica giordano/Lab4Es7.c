

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node{
    char nome[10];
    char cognome[10];
    double tel;
    struct node *next;
}node;

typedef node *list;

list headInsert(list l, char nome[10], char cognome[10], double tel);
list cancella(list l, char nome[10], char cognome[10]);
list copiaLista(list l, list l2);
void printList(list l);
void clearList(list l);

int main(int argc, const char * argv[]) {
    list rubrica = NULL;
    list rubricaCopia = NULL;
    int c;
    char nome[10],cognome[10];
    double tel;
    
    do{
        printf("MENU:\n\n");
        printf("1) Inserisci contatto\n");
        printf("2) Creare contatto per nome e cognome x eliminarlo\n");
        printf("3) Creare lista con tel 3\n");
        printf("4) Esci\n\n");
        printf(">> ");
        fpurge(stdin);
        scanf("%d",&c);
        
        switch (c) {
            case 1:
                printf("Inserisci nome, cognome e telefono: ");
                scanf("%s %s %lf",nome,cognome,&tel);
                rubrica = headInsert(rubrica, nome, cognome, tel);
                printList(rubrica);
                break;
            case 2:
                printf("Inserisci nome e cognome da ricercare e cancellare: ");
                scanf("%s %s",nome,cognome);
                rubrica = cancella(rubrica, nome, cognome);
                printList(rubrica);
                break;
            case 3:
                clearList(rubricaCopia);
                rubricaCopia = NULL;
                rubricaCopia = copiaLista(rubrica, rubricaCopia);
                printList(rubricaCopia);
                break;
            case 4:
                
                break;
            default:
                break;
        }
        
    }while(c!=4);
    
    return 0;
}

list headInsert(list l, char nome[10], char cognome[10], double tel) {
    node *n = (node *) malloc(sizeof(node));
    n->next = l;
    strcpy(n->nome,nome);
    strcpy(n->cognome,cognome);
    n->tel = tel;
    return n;
}

list cancella(list l, char nome[10], char cognome[10]) {
    node *n;
    char ris;
    if (l == NULL) {
        return l;
    } else if ((strcmp(l->nome,nome)==0)&&(strcmp(l->cognome, cognome)==0)){
        printf("Utente trovato %s %s %.0lf, vuoi cancellarlo? (S/N) ",l->nome,l->cognome,l->tel);
        fpurge(stdin);
        scanf("%c",&ris);
        if (ris=='S')
        {
            n = l->next;
            free (l);
            return n;
        }
        else
            return l;
        
    } else {
        l->next = cancella(l->next, nome, cognome);
        return l;
    }
}

list copiaLista(list l, list l2)
{
    if (l==NULL)
        return l2;
    else
    {
        if ((int)(l->tel/1000000000)==3)
            l2 = headInsert(l2, l->nome,l->cognome,l->tel);
        return copiaLista(l->next, l2);
        
    }
}

void printList(list l) {
    if (l != NULL) {
        printf("%s %s %.0lf ", l->nome, l->cognome, l->tel);
        if (l->next != NULL)
            printf("\n");
        printList(l->next);
    } else {
        printf("\n");
    }
}

void clearList(list l) {
    node *n;
    if (l != NULL) {
        n = l->next;
        free(l);
        clearList(n);
    }
}
