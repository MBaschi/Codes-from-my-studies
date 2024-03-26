#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
typedef struct ele{
  int prAdult;
  char luogo[10];
  int prInf;
  struct ele* next;
}Destinazione;
typedef Destinazione* ptrdestinazione;

typedef struct els{
  int inizio;
  int fine;
  int adulti;
  char luogo[10];
  int infanti;
  struct els* pross;
}Prenotazione;
typedef Prenotazione* ptrprenotazione;
ptrdestinazione inseriscidestinazione(ptrdestinazione head,char luogo[10],int prAdult,int prInf);
void aumentaprezzi(ptrdestinazione head,float percentuale,char luogo[10]);
void stampadestinazioni(ptrdestinazione head);
void stampaprenotazioni(ptrprenotazione head);
ptrprenotazione inserisciprenotazione (ptrprenotazione head,char luogo[10],int adulti,int infanti,int inizio,int fine);
void fatturato(ptrdestinazione head,ptrprenotazione head2);
int main()
{ int prAdult,prInf,quanti,i;
int adulti,infanti,inizio,fine;
float percentuale;
  char luogo[10],altroluogo[10],ancoraltro[10],perfatt[10];
  ptrdestinazione lista=NULL;
  ptrprenotazione lista2=NULL;
  printf("quante destinazioni vuoi inserire-> \n");
  scanf("%d",&quanti);
  for(i=0;i<quanti;i++){
    printf("inserisci destinazione ->");
    scanf("%s",luogo);
    printf("inserisci adulto e infante ->\n");
    scanf("%d",&prAdult);
    scanf("%d",&prInf);
    lista=inseriscidestinazione(lista,luogo,prAdult,prInf);
  }
  stampadestinazioni(lista);
  printf("che luogo intendi aumentare di prezzo e di che percentuale\n");
  scanf("%s",altroluogo);
  scanf("%f",&percentuale);
  percentuale=percentuale/100;
  aumentaprezzi(lista,percentuale,altroluogo);
  stampadestinazioni(lista);
  for(i=0;i<1;i++){
  printf("che prenotazione vuoi fare inserisci luogo adulti infanti inizio e fine");
  scanf("%s",ancoraltro);
scanf("%d",&adulti);
scanf("%d",&infanti);
scanf("%d",&inizio);
scanf("%d",&fine);
lista2=inserisciprenotazione(lista2,ancoraltro,adulti,infanti,inizio,fine);}
stampaprenotazioni(lista2);
printf("che fattura vuoi visulizzare di che luogo-> \n");
scanf("%s",perfatt);
while(lista!=NULL){
    if(strcmp(lista->luogo,lista2->luogo)==0){
        fatturato(lista,lista2);
    }

  lista=lista->next;
  lista2=lista2->pross;
}
}
ptrdestinazione inseriscidestinazione (ptrdestinazione head,char luogo[10],int prAdult,int prInf){
if(head==NULL){
    head=(ptrdestinazione)malloc(sizeof(Destinazione));
    head->next=NULL;
    head->prInf=prInf;
    strcpy(head->luogo,luogo);
    head->prAdult=prAdult;
    return head;
}
else{
    head->next=inseriscidestinazione(head->next,luogo,prAdult,prInf);
    return head;
}
}
ptrprenotazione inserisciprenotazione (ptrprenotazione head,char luogo[10],int adulti,int infanti,int inizio,int fine){
if(head==NULL){
    head=(ptrprenotazione)malloc(sizeof(Prenotazione));
    head->pross=NULL;
    head->adulti=adulti;
    strcpy(head->luogo,luogo);
    head->infanti=infanti;
    head->fine=fine;
    head->inizio=inizio;
    return head;
}
else{
    head->pross=inserisciprenotazione(head->pross,luogo,adulti,infanti,inizio,fine);
    return head;
}
}
void aumentaprezzi(ptrdestinazione head,float percentuale,char luogo[10]){
if(head==NULL){
    printf("non trovata destinazione\n");
    return;
}
if(strcmp(head->luogo,luogo)==0){
head->prAdult= head->prAdult + percentuale*(head->prAdult);
head->prInf= head->prInf + percentuale*(head->prInf);

}

else{
    aumentaprezzi(head->next,percentuale,luogo);

}


}
void stampadestinazioni(ptrdestinazione head){

if(head==NULL){
    return  ;
}
else{
    printf("%s \n %d \n %d \n",head->luogo, head->prAdult, head->prInf );
    stampadestinazioni(head->next);
}


}
void stampaprenotazioni(ptrprenotazione head){

if(head==NULL){
    return  ;
}
else{
    printf("%s \n %d \n %d \n %d \n %d\n",head->luogo, head->adulti, head->infanti,head->inizio,head->fine );
    stampaprenotazioni(head->pross);
}


}
void fatturato(ptrdestinazione head,ptrprenotazione head2){
 int somma=0;
     somma=head->prAdult*head2->adulti*(head2->inizio-head2->fine)+ head->prInf*head2->infanti*(head2->inizio-head2->fine);
     printf("%d",somma);
}
