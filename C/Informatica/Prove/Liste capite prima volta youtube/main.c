#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct lista{
    int val;
    struct lista* next;
}lista;

struct lista* Crea(struct lista* testa);
void Stampa(struct lista* testa);

struct lista* Crea(struct lista* testa) {
    struct lista* nuovo = NULL;
    int valore = 0;
    
    nuovo = (struct lista*)malloc(sizeof(struct lista));
    printf("Inserisci il valore->");
    scanf("%d", &valore);
    
    nuovo->val = valore;
    nuovo->next = testa;
    testa = nuovo;
    return nuovo;
}

void Stampa(struct lista* testa) {
    
    struct lista* temp = NULL;
    temp = testa;
    while (temp != NULL) {
        printf("Valore-> %d\n", temp->val);
        temp = temp->next;
    }
}
int main(){
    
    struct lista* head = NULL;
    int inserimento;
    do {
        printf("\n********MENU'********\n1) - Inserisci in lista\n2) - Stampa\n3) - Esci\n->");
        scanf("%d",&inserimento);
        switch (inserimento) {
            case 1:
                head = Crea(head);
                break;
            case 2:
                Stampa(head);
                break;
            default:
                printf("Inserimento non valido!");
                break;
        }
    } while (inserimento==1 || inserimento==2);
        return 0;
}
