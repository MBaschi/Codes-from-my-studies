#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node_s{
    char nome[10];
    char numTel[10];
    char email[10];
    struct node_s* linkp;
}node_t;

typedef node_t* Ptrnode;

Ptrnode crealista(void);
void vedilista(Ptrnode head);
void modifica(Ptrnode head,char *vecchio,char* nuovo);
Ptrnode cancella(Ptrnode head,char *erase);

int main(){
    Ptrnode testa;
    char vecchio[10];
    char nuovo[10];
    char erase[10];
    testa = crealista();
    vedilista(testa);
    printf("Che nome vuoi cambiare \n");
    scanf("%s",vecchio);
    printf("Con che lo vuoi cambiare \n");
    scanf("%s", nuovo);
    modifica(testa,vecchio,nuovo);
    vedilista(testa);
    printf("inserisci il contatto da eliminare");
    scanf("%s",erase);
    testa=cancella(testa,erase);
    vedilista(testa);
}


Ptrnode crealista(){
    Ptrnode succ = NULL;
    Ptrnode prec = NULL;
    int i,elem;
    printf("quanti elementi vuoi inserire->");
    scanf(" %d",&elem);
    for(i=0;i<elem;i++){
        prec=(Ptrnode)malloc(sizeof(prec));
        printf("Inserisci nome numero,telefono e email-> ");
        scanf("%s",prec->nome);
        scanf(" %s",prec->numTel);
        scanf(" %s",prec->email);
        prec->linkp=succ;
        succ=prec;
    }
    return prec;
}



void vedilista(Ptrnode head){    //ricorsiva
    printf("La rubrica ha i seguenti contatti->");
    if(head==NULL){
        printf("\n");
    }
    else{
        printf(" %s \n",head->nome);
        printf(" %s \n",head->numTel);
        printf(" %s \n",head->email);
        printf("########################\n\n");
        vedilista(head->linkp);
    }
}



void modifica(Ptrnode head,char *vecchio,char *nuovo){
    if(strcmp(head->nome , vecchio)== 0){
        strcpy(head->nome,nuovo);
        return;
    }else{
        modifica( head->linkp,vecchio,nuovo);
    }
}


Ptrnode cancella(Ptrnode head,char *erase){
    Ptrnode temp,fine;
    fine=head;
    
    while(head!=NULL){
        if ( strcmp(head->linkp->nome,erase)==0){
            temp=head->linkp->linkp;
            free(head->linkp);
            head->linkp=temp;}
        if ( strcmp(head->nome ,erase)==0){
            temp=head->linkp;
            free(head);
            return temp;
        }
        head=head->linkp;
    }
    return fine;
}
