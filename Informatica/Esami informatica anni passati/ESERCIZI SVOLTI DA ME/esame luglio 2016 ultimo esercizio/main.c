#include <stdio.h>
#include <stdlib.h>

typedef enum {Europa, Nord_America, Sud_America, Africa, Oriente}
continente_t;


typedef struct nodo_s{
    struct nodo_s* next;
    char nazione[20];
    int ranaking;
    continente_t continente;
} node_t;

typedef node_t* ptrNode;



int main() {
    // insert code here...
    printf("Hello, World!\n");
    return 0;
}
