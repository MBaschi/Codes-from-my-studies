//
//  main.c
//  prova
//
//  Created by Anna Maria Nestorov on 27/11/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

typedef struct listnode{
    int a;
    int b;
    struct listnode *next;
} listnode;
typedef listnode *ptrList;

typedef struct listnode2{
    int a;
    struct listnode2 *next;
} listnode2;
typedef listnode2 *ptrList2;

ptrList tailInsert(ptrList l, int a, int b);
void printList(ptrList l);
ptrList2 creaLista(ptrList l, ptrList2 l2);
void printList2(ptrList2 l);
ptrList2 tailInsert2(ptrList2 l, int a);

int main(int argc, const char * argv[]) {
    
    ptrList lista1 = NULL;
    ptrList2 lista2 = NULL;
    
    int a,b;
    
    do{
        scanf("%d %d",&a,&b);
        if ((a!=-1) && (b!=-1))
            lista1 = tailInsert(lista1, a,b);
        
    }while ((a!=-1) && (b!=-1));
    printList(lista1);
    
    lista2 = creaLista(lista1,lista2);
    printList2(lista2);
    
    return 0;
}

ptrList tailInsert(ptrList l, int a, int b) {
    listnode *n;
    if (l == NULL) {
        n = (listnode *) malloc(sizeof(listnode));
        n->next = NULL;
        n->a = a;
        n->b = b;
        return n;
    } else {
        l->next = tailInsert(l->next, a,b);
        return l;
    }
}

ptrList2 tailInsert2(ptrList2 l, int a) {
    listnode2 *n;
    if (l == NULL) {
        n = (listnode2 *) malloc(sizeof(listnode2));
        n->next = NULL;
        n->a = a;
        return n;
    } else {
        l->next = tailInsert2(l->next, a);
        return l;
    }
}
void printList(ptrList l) {
    if (l != NULL) {
        printf("%d ", l->a);
        printf("%d ", l->b);
        if (l->next != NULL)
            printf("-->\t");
        printList(l->next);
    } else {
        printf("--|\n");
    }
}

ptrList2 creaLista(ptrList l, ptrList2 l2)
{
    int max;
    
    if (l==NULL)
        return l2;
    
    if (l->a>l->b)
        max = l->a;
    else
        max = l->b;
    
    l2 = tailInsert2(l2,max);
    return creaLista(l->next, l2);
    
}

void printList2(ptrList2 l) {
    if (l != NULL) {
        printf("%d ", l->a);
        if (l->next != NULL)
            printf("-->\t");
        printList2(l->next);
    } else {
        printf("--|\n");
    }
}
