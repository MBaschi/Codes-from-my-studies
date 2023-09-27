#include <stdio.h>
#include <stdlib.h>

typedef struct list_node {
    int content;
    struct list_node *next;
} node;

typedef node* list;

list headInsert(list l, int content) {
    list n =(list)malloc(sizeof(node));
    n->next = l;
    n->content = content;
    return n;
}

list tailInsert(list l, int content) {
    list currentTail = l;
    node *n = (node *) malloc(sizeof(node));
    n->next = NULL;
    n->content = content;
    
    // Caso di lista inizialmente vuota
    if (l == NULL) {
        return n;
    }
    
    // Caso di lista non vuota
    while (currentTail->next != NULL) {
        currentTail = currentTail->next;
    }
    
    currentTail->next = n;
    return l;
}

void printList(list l) {
    while (l != NULL) {
        printf("%d", l->content);
        if (l->next != NULL)
            printf(" --> ");
        l = l->next;
    }
    printf(" --|\n");
}

list sortInsert(list l, int content) {
    list currentNode = l;
    node *n = (node *) malloc(sizeof(node));
    
    // Casi in cui l'elemento deve essere inserito in prima posizione
    if (l == NULL || l->content >= content) {
        return headInsert(l, content);
    }
    
    // Caso in cui l'elemento deve essere inserito in una posizione centrale
    while (currentNode->next != NULL && currentNode->next->content < content) {
        currentNode = currentNode->next;
    }
    n->next = currentNode->next;
    n->content = content;
    currentNode->next = n;
    return l;
}

list removeFirst(list l, int content) {
    list previousNode = NULL;
    list currentNode = l;
    list head = l;
    
    while (currentNode != NULL && currentNode->content != content) {
        previousNode = currentNode;
        currentNode = currentNode->next;
    }
    
    // Se ho trovato l'elemento ...
    if (currentNode != NULL) {
        // L'elemento era in prima posizione
        if (previousNode == NULL) {
            head = currentNode->next;
        }
        // L'elemento NON era in prima posizione
        else {
            previousNode->next = currentNode->next;
        }
        free(currentNode);
    }
    return head;
}

list removeAll(list l, int content) {
    list previousNode = NULL;
    list currentNode = l;
    list head = l;
    
    while (currentNode != NULL) {
        if (currentNode->content == content) {
            // L'elemento era in prima posizione
            if (previousNode == NULL) {
                head = currentNode->next;
            }
            // L'elemento NON era in prima posizione
            else {
                previousNode->next = currentNode->next;
            }
            currentNode = currentNode->next;
        } else {
            previousNode = currentNode;
            currentNode = currentNode->next;
        }
    }
    return head;
}

int find(list l, int content) {
    while (l != NULL) {
        if (l->content == content) {
            return 1;
        }
        l = l->next;
    }
    return 0;
}

int size(list l) {
    int count = 0;
    while (l != NULL) {
        count++;
        l = l->next;
    }
    return count;
}

list clearList(list l) {
    list temp;
    while (l != NULL) {
        temp = l;
        l = l->next;
        free(temp);
    }
    return l;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
int main() {
    list head = NULL;
    int scelta = 0;
    int val = 0;
    int trovato=0;
    
    do {printf("**********MENU'***********\n");
        printf("Inserisci il numero:\n1) Per inserire un elemento in testa alla lista\n2) Per stampare la lista\n3) Per inserire un elemento in coda alla lista\n4) Per inserire l'elemento nella lista in ordine\n5) Per rimuovere l'elemento voluto la prima volta che lo si incontra nella lista\n6) Per eliminare un elemento tutte le volte che lo si sincontra nella lista\n7) Per sapere se un valore è nella lista\n8) Per sapere quanti elementi ci sono\n9) Per rimuovere tutti gli elementi dalla lista\n->");
        scanf("%d", &scelta);
        switch (scelta) {
            case 1:
                printf("Inserisci il valore che vuoi mettere in testa nella lista->");
                scanf("%d",&val);
                head = headInsert(head, val);
                break;
            case 2:
                printList(head);
                break;
            case 3:
                printf("Inserisci il valore che vuoi mettere in coda nella lista->");
                scanf("%d",&val);
                head = tailInsert(head, val);
                break;
            case 4:
                printf("Inserisci il valore che vuoi mettere nella lista in ordine->");
                scanf("%d",&val);
                head = sortInsert(head, val);
                break;
            case 5:
                printf("Inserisci il valore che vuoi eliminare dalla lista->");
                scanf("%d",&val);
                head = removeFirst(head, val);
                break;
            case 6:
                printf("Inserisci il valore che vuoi eliminare dalla lista tutte le volte che è presente->");
                scanf("%d",&val);
                head = removeAll(head, val);
                break;
            case 7:
                printf("Inserisci il valore che vuoi sapere se è nella lista->");
                scanf("%d",&val);
                trovato = find(head, val);
                if(trovato==1) {
                    printf("Il valore è presente nella lista!\n\n");
                }
                else {
                    printf("Il valore non è presente in lista :( \n\n");
                }
                break;
            case 8:
                printf("Nella lista sono presenti %d elementi\n", size(head));
                break;
            case 9:
                head = clearList(head);
                printf("Rimozione avvenuta con successo");
                break;
            default:
                break;
        }
    } while (scelta>=0 && scelta<=9);
         
    return 0;
}
