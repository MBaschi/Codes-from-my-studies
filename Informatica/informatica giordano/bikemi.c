#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct bik{
 int inizio;
 int fine;
 int anno;
 char partenza[10];
 char arrivo[10];
 struct bik*next;
}bikemi;
 typedef bikemi *Ptrbike;
 Ptrbike aggiungiele(Ptrbike head,int start,int end,int year,char partenza[10],char arrivo[10]);
 void stampabike(Ptrbike testa);
 Ptrbike inseriscinuova(Ptrbike head,Ptrbike copy);
 typedef struct {
int min;
int numUtilizzi;
int durataMedia;
Ptrbike list;
}Fascia;
typedef Fascia*ptrfascia;
 ptrfascia funzionenuova(Ptrbike head);
int main()
{
    Ptrbike testa=NULL;
 int inizio,i;
 int fine;
 int anno;
 char partenza[10];
 char arrivo[10];

   for(i=0;i<2;i++){ printf("che inizio -> \n");
    scanf("%d",&inizio);
     printf("che fine > \n");
    scanf("%d",&fine);
     printf("che  anno -> \n");
    scanf("%d",&anno);
    printf(" dove parte -> \n");
    scanf("%s",partenza);
    printf("dove arriva->\n\n");
    scanf("%s",arrivo);
    testa=aggiungiele(testa,inizio,fine,anno,partenza,arrivo);}
   // stampabike(testa);
     funzionenuova(testa);

     }

Ptrbike aggiungiele(Ptrbike head,int start,int end,int year,char partenza[10],char arrivo[10]){
 Ptrbike scorri,prec,newele;
scorri=head;
prec=NULL;
newele=(Ptrbike)malloc(sizeof(bikemi));
newele->inizio=start;
newele->fine=end;
newele->anno=year;
strcpy(newele->partenza,partenza);
strcpy(newele->arrivo,arrivo);
if(head==NULL){
    newele->next=NULL;
    return newele;
}
while(scorri!=NULL&&scorri->inizio<start){
    prec=scorri;
    scorri=scorri->next;
}
if(scorri==NULL){
    prec->next=newele;
    newele->next=NULL;
    return head;
}
if(scorri->inizio>start){
        newele->next=scorri;
        prec->next=newele;
        return head;
    }
}
void stampabike(Ptrbike testa){

if(testa==NULL){
    return;
    }

else{

    printf("inizio -> %d\n",testa->inizio);
    printf("fine-> %d\n",testa->fine);
    printf("anno -> %d\n",testa->anno);
    printf("partenza -> %s\n",testa->partenza);
    printf("arrivo-> %s\n\n",testa->arrivo);
    stampabike(testa->next);

}
}
Ptrbike inseriscinuova(Ptrbike lista1,Ptrbike head){
    Ptrbike nuovo;
if(lista1==NULL){
    lista1=(Ptrbike)malloc(sizeof(bikemi));
    lista1->inizio=head->inizio;
    lista1->anno=head->anno;
    strcpy(lista1->arrivo,head->arrivo);
    strcpy(lista1->partenza,head->partenza);
    lista1->fine=head->fine;
     lista1->next=NULL;
    return lista1;
}
else{
    lista1->next = inseriscinuova(lista1->next, head);
    return lista1;
}

}
 ptrfascia funzionenuova(Ptrbike head){
 Ptrbike lista1=NULL;
 Ptrbike lista2=NULL;
 Fascia array[5];
 int sum=0;
 array[0].numUtilizzi=0;
 array[1].numUtilizzi=0;
 array[0].min=16;
 array[1].min=20;
 array[2].min=30;
 array[3].min=40;
 array[4].min=50;
 array[5].min=60;
 //printf("%d",array[0].min);
 while(head!=NULL){
    if(head->anno>10&&head->anno<19){
        array[0].numUtilizzi++;
        sum=sum+head->fine-head->inizio;
        array[0].durataMedia=sum/array[0].numUtilizzi;
       lista1=inseriscinuova(lista1,head);

      // printf("%d %d",array[0].numUtilizzi,array[0].durataMedia);


    }

    if(head->anno>20&&head->anno<30){
        array[1].numUtilizzi++;
        sum=sum+head->fine-head->inizio;
        array[1].durataMedia=sum/array[1].numUtilizzi;
       lista2=inseriscinuova(lista2,head);

        }
head=head->next;
    }
stampabike(lista2);

 stampabike(lista1);

 }








