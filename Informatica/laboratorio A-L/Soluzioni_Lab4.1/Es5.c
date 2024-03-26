#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct nodo{
    int numero;
    int successione;
    struct nodo *next;
};

typedef struct nodo nodo;
typedef nodo* ptrNode;

ptrNode estraiNumero(ptrNode lista, int *estrazione);
void stampaLista(ptrNode lista);
int checkEstrazione(ptrNode lista, int e);
ptrNode ordinaPerNumero(ptrNode l, ptrNode l2);
ptrNode ordinaPerEstrazione(ptrNode l, ptrNode l2);

int main(int argc, const char * argv[]) {
    ptrNode tombola =  NULL, ordineEs, ordineNum;
    int r;
    int estrazione = 0;
    
    //Azzera rand
    srand((int)time(NULL));
    
    do{
        printf("MENU\n\n1) Estrai numero;\n2) Ordina i numeri per valore;\n3) Ordina numeri per estrazione\n4) ESCI\n\n>> ");
        scanf("%d",&r);
        switch (r) {
            case 1:
                if (estrazione==90)
                    printf("Sono stati estratti tutti i numeri");
                else{
                    tombola = estraiNumero(tombola, &estrazione);
                    stampaLista(tombola);
                }
                break;
            case 2:
                ordineNum = ordinaPerNumero(ordineNum, tombola);
                stampaLista(ordineNum);
                break;
            case 3:
                ordineEs = ordinaPerEstrazione(ordineEs, tombola);
                stampaLista(ordineEs);
                break;
        }
    }while(r!=4);
    
    return 0;
}

void stampaLista(ptrNode lista){
    if (lista!=NULL)
    {
        printf("Estrazione: %d\nNumero: %d\n",lista->successione,lista->numero);
        stampaLista(lista->next);
    }
}

int checkEstrazione(ptrNode lista, int e){
    if (lista==NULL)
        return 0;
    else{
        if (lista->numero == e)
            return 1;
        else
            return checkEstrazione(lista->next, e);
    }
}

ptrNode estraiNumero(ptrNode lista, int *estrazione){
    ptrNode tempNode;
    int e;
    do{
        e = rand() % 91;
    }while (checkEstrazione(lista, e));
    tempNode = (ptrNode)malloc(sizeof(nodo));
    tempNode->numero = e;
    *estrazione = *estrazione+1;
    tempNode->successione = *estrazione;
    tempNode->next = lista;
    return tempNode; //E' un inserimento in testa
}

//Questa funzione, a partire da una lista vuota l, ed una piena l2, inserisce uno alla volta i valori di l2 in modo orindano in l
ptrNode ordinaPerNumero(ptrNode l, ptrNode l2){
    ptrNode n = NULL;
    
    while(l2!=NULL){
        ptrNode currentNode = l;
        //Se va inserito in prima posizione
        if (l==NULL || l->numero>=l2->numero){
            n = (nodo *)malloc(sizeof(nodo));
            n->next = l;
            n->numero = l2->numero;
            n->successione = l2->successione;
            l = n;
        }
        else{
            // Caso in cui l'elemento deve essere inserito in una posizione centrale
            while (currentNode->next != NULL && currentNode->next->numero < l2->numero) {
                currentNode = currentNode->next;
            }
            n = (nodo *) malloc(sizeof(nodo));
            n->next = currentNode->next;
            n->numero = l2->numero;
            n->successione = l2->successione;
            currentNode->next = n;
        }
        l2 = l2->next;
    }
    return l;
}

//Questa funzione, a partire da una lista vuota l, ed una piena l2, inserisce uno alla volta i valori di l2 in modo orindano in l
ptrNode ordinaPerEstrazione(ptrNode l, ptrNode l2){
    ptrNode n = NULL;
    
    while(l2!=NULL){
        ptrNode currentNode = l;
        //Se va inserito in prima posizione
        if (l==NULL || l->successione>=l2->successione){
            n = (nodo *)malloc(sizeof(nodo));
            n->next = l;
            n->numero = l2->numero;
            n->successione = l2->successione;
            l = n;
        }
        else{
            // Caso in cui l'elemento deve essere inserito in una posizione centrale
            while (currentNode->next != NULL && currentNode->next->successione < l2->successione) {
                currentNode = currentNode->next;
            }
            n = (nodo *) malloc(sizeof(nodo));
            n->next = currentNode->next;
            n->numero = l2->numero;
            n->successione = l2->successione;
            currentNode->next = n;
        }
        l2 = l2->next;
    }
    return l;
}
