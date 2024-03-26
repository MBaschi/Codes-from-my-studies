#include <stdio.h>
#include <stdlib.h>
typedef struct node_s{
 int primo;
 int secondo;
 struct node_s *next;
}nodo_t;

typedef struct ele{
int altro;
struct ele *nuovo;
}seconda;

typedef nodo_t *Ptrnodo;
typedef seconda *Ptrsec;

void vedilista(Ptrnodo head);
void vedilista2(Ptrsec head);
Ptrsec creaSeconda(Ptrnodo head);
void ordina(Ptrsec head);


//fare anche come funzione
int main()
{
    Ptrnodo lista,prec,succ;
    Ptrsec altr;
    int i;
    for(i=0;i<100;i++){
        succ=(Ptrnodo)malloc(sizeof(nodo_t));
        printf("Inserisci il primo numero ");
        scanf(" %d",&(succ->primo));
        printf("inserisci secondo numero ");
        scanf(" %d",&(succ->secondo));
        if(i==1){
            lista=prec;
            lista->next=succ;//provare a metterlo dopo
         }
         if((succ->primo)==-1 && (succ->secondo)==-1){
            succ=NULL;
           if( i>0 ){ prec->next=succ;}
            if(i==0){lista=NULL;};
         break;
        }
       if(i>0){ prec->next=succ;}
        prec=succ;
    }
 vedilista(lista);
 altr=creaSeconda(lista);
 ordina(altr);
 vedilista2(altr);



}
void vedilista(Ptrnodo head){
   if(head==NULL){
    return;
   }
   else{
    printf(" %d %d \n\n",head->primo,head->secondo);
    vedilista(head->next);
   }
}
Ptrsec creaSeconda(Ptrnodo head){
  Ptrsec  prec ,succ,lista;
  int i;
  lista=(Ptrsec)malloc(sizeof(seconda));
      if((head->primo)>(head->secondo)){
        lista->altro=head->primo;
      };
     if((head->primo)<(head->secondo)){
        lista->altro=head->secondo;
      };
      prec=lista;
      if(head->next==NULL){
        lista->nuovo=NULL;
        return lista;
      }
      head=head->next;
   for(i=0;i<100;i++){
      succ=(Ptrsec)malloc(sizeof(seconda));
      if((head->primo)>(head->secondo)){
        succ->altro=head->primo;
              }
    if((head->primo)<(head->secondo)){
        succ->altro=head->secondo;
      }

     if(i==0){
        lista->nuovo=succ;
      }

      prec->nuovo=succ;
      prec=succ;
      if(head->next==NULL){
         prec->nuovo=NULL;
      break;
      }
       head= head->next;
     }

return lista;

}
void vedilista2(Ptrsec head){

if(head==NULL){
    return;
   }
   else{
    printf(" %d  \n\n",head->altro);
    vedilista2(head->nuovo);
   }

}
void ordina(Ptrsec head){
  int i,temp;
  Ptrsec fine;
  fine=head;
   for(i=0;i<67;i++){
        if(head->nuovo==NULL){
        head=fine;
    }
    if(head->altro > head->nuovo->altro ){
        temp=head->altro;
        head->altro=head->nuovo->altro;
        head->nuovo->altro=temp;}

    head=head->nuovo;

  }



}




/*int ordina(Ptrsec head){
  int temp;
  if(head->nuovo==NULL){
    return head->altro;
  }
  if(head->altro > ordina(head->nuovo)){
    temp=head->altro;
    head->altro=head->nuovo->altro;
    head->nuovo->altro=temp;
    return head->nuovo->altro;

  }
 else{
    return head->altro;
 }}
void arrangiamento(Ptrsec head){

while(head!=NULL){
    printf("%d\n", ordina(head));
    head=head->nuovo;
}


}*/








