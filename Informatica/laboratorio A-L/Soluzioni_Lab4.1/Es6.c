/*Si definisca una lista contenente le telefonate effettuate da un cliente. La lista contiene: la città di destinazione, la durata in secondi ed il costo.
Scrivere un programma che permetta di:
1. Inserire una nuova telefonata, andando a sommare minuti e
costo (0.1 € al minuto) se la città di destinazione è già
presente;
2. Stampare le telefonate di una città cercata (usare una
                                                 funzione ricorsiva)
3. Stampare tutte le telefonate
4. Eliminare il nodo in testa alla lista e ristampare la lista.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct nodo{
    char cittaDest[20];
    int durata;
    float costo;
    struct node *next;
};

typedef struct nodo nodo;
typedef nodo *ptrNode;

void stampaLista(ptrNode lista);
ptrNode inserisciTelefonataInTesta(ptrNode lista);
ptrNode checkList(ptrNode l, char citta[]);
void stampaTelefonateCitta(ptrNode l, char citta[]);
ptrNode eliminaNodo(ptrNode l);

int main(int argc, const char * argv[]) {
    ptrNode listaCall = NULL;
    char citta[20];
    int r;
    do{
        printf("MENU\n\n1) Inserisci telefonata\n2) Stampa telefonate citta'\n3) Stampa tutte le telefonate\n4) Eliminare primo nodo e ristapa lista\n5) ESCI\n\n>> ");
        scanf("%d",&r);
        switch (r) {
            case 1:
                listaCall = inserisciTelefonataInTesta(listaCall);
                break;
            case 2:
                printf("Quale citta' cercare: ");
                scanf("%s",citta);
                stampaTelefonateCitta(listaCall, citta);
                break;
            case 3:
                printf("Citta\tMinuti\tCosto\n");
                stampaLista(listaCall);
                break;
            case 4:
                listaCall = eliminaNodo(listaCall);
                stampaLista(listaCall);
                break;
                
            default:
                break;
        }
    }while(r!=5);
    return 0;
}

void stampaLista(ptrNode lista){
    if (lista!=NULL)
    {
        printf("%s\t%d\t%.2f\n",lista->cittaDest,lista->durata,lista->costo);
        stampaLista(lista->next);
    }
}

ptrNode checkList(ptrNode l, char citta[]){
    if (l==NULL)
        return NULL;
    else{
        if (!(strcmp(l->cittaDest,citta)))
            return l;
        else
            return checkList(l->next,citta);
    }
}

ptrNode inserisciTelefonataInTesta(ptrNode lista)
{
    char tempCity[20];
    int d;
    ptrNode temp;
    ptrNode toRet;
    printf("Inserisci citta': ");
    scanf("%s",tempCity);
    printf("Inserisci numero minuti: ");
    scanf("%d",&d);
    temp = checkList(lista,tempCity);
    if (temp==NULL)
    {
        temp = (ptrNode)malloc(sizeof(nodo));
        temp->next = lista;
        toRet = temp;
        temp->durata = d;
    }
    else
    {
        toRet = lista;
        temp->durata += d;
    }
    strcpy(temp->cittaDest,tempCity);
    temp->costo = temp->durata*0.1f;
    return toRet;
}

void stampaTelefonateCitta(ptrNode l, char citta[]){
    if (l!=NULL)
    {
        if (!(strcmp(l->cittaDest,citta)))
            printf("Durata: %d\tCosto: %.2f", l->durata, l->costo);
        stampaTelefonateCitta(l->next, citta);
    }
}

ptrNode eliminaNodo(ptrNode l){
    ptrNode temp;
    if (l==NULL)
        return NULL;
    else
    {
        temp=l->next;
        free(l);
        return temp;
    }
}
