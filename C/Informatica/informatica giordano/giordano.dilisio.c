#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node_s{
    int data;
    char titolo[15];
    char desrizione[255];
    struct node_s *next;
}node_t;

typedef node_t* Ptrnode;

Ptrnode inseriscinuovo(Ptrnode head,int data, char titolo[15],char descrizione[255]);
void visualizzalista(Ptrnode head);
void ricercaTodo(Ptrnode head, char daricercare[15]);
Ptrnode rimuoviTodo(Ptrnode head, char daliminare[15]);

int main()
{
    int sel;
    int data;
    char titolo[15];
    char daricercare[15];
    char daeliminare[15];
    char desrizione[255];
    Ptrnode lista=NULL;
    
    do{
        printf("Premi 1 per inserire nuovo TODO\n");
        printf("Premi 2 per visualizzare lista\n");
        printf("Premi 3 per ricercare TODO\n");
        printf("Premi 4 per eliminare TODO\n");
        printf("Premi 5 per uscire\n\n");
        scanf("%d",&sel);
        switch (sel){
                
            case 1:
                printf("inserisci data di consegna->\n");
                scanf("%d",&data);
                printf("scrivi titolo->\n");
                scanf("%s",titolo);
                printf("scrivi descrizione-> \n");
                scanf("%s",desrizione);
                lista= inseriscinuovo(lista,data,titolo,desrizione);
                
                break;
            case 2:
                visualizzalista(lista);
                break;
                
            case 3:
                printf("inserisci il titolo del TODO\n");
                scanf("%s",daricercare);
                ricercaTodo(lista,daricercare);
                
                break;
            case 4:
                printf("Inserisci titolo TODO da eliminare->");
                scanf("%s",daeliminare);
                rimuoviTodo( lista, daeliminare);
                
                break;
            case 5 :
                
                break;
            default:
                
                break;
        }
    } while(sel!=5);
    return 0;
}


/////
Ptrnode inseriscinuovo( Ptrnode head , int data , char titolo[15],char descrizione[255]){
    Ptrnode newelem,scorri,prec;
    prec=NULL;
    scorri=head;
    newelem=(Ptrnode)malloc(sizeof(node_t));
    
    newelem->data=data;
    strcpy(newelem->titolo,titolo);
    strcpy(newelem->desrizione,descrizione);
    
    
    if(head==NULL){
        newelem->next =NULL;
        return newelem;}
    
    while(scorri!=NULL && (scorri->data)<data){
        prec=scorri;
        scorri=scorri->next;
        
    }
    if(scorri==NULL){
        prec->next=newelem;
        newelem->next=NULL;
        return head;}
    
    if(prec==NULL){
        newelem->next=scorri;
        return newelem;
    }
    
    if((scorri->data)>data){
        prec->next=newelem;
        newelem->next=scorri;
    }
    return head;
}


//////
void visualizzalista(Ptrnode head){
    
    if(head==NULL){
        return;
    }
    else{
        printf("DATA %d\n",head->data);
        printf("TITOLO %s\n",head->titolo);
        printf("DESCRIZIONE %s\n",head->desrizione);
        printf("#####################\n\n");
        visualizzalista(head->next);
    }
}


//////
void ricercaTodo(Ptrnode head, char daricercare[15]){
    if(head==NULL){
        printf("Non e' presente\n ");
        return;
    }
    if (strcmp(head->titolo,daricercare)==0){
        printf("TROVATO!!!!");
        printf("DATA %d\n",head->data);
        printf("TITOLO %s\n",head->titolo);
        printf("DESCRIZIONE %s\n",head->desrizione);
        printf("#####################\n\n");
        return;
        
    }
    ricercaTodo(head->next,daricercare);
    
    
    
}


//////
Ptrnode rimuoviTodo(Ptrnode head, char daeliminare[15]){
    Ptrnode temp;
    if (head == NULL) {
        return head;
    }
    
    if (strcmp(head->titolo, daeliminare)==0) {
        temp = head->next;
        free(head);
        return rimuoviTodo(temp, daeliminare);
    }
    
    head->next = rimuoviTodo(head->next, daeliminare);
    return head;
}




