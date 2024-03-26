#include <stdio.h>
#include <string.h>

typedef struct manager {
    char Nome[20];
    char Cognome[20];
    char Sesso[10];
    int NumeroVoli;
}manager_t;

void mediaSup20(int n, manager_t VettManager[]);
void mediaMaschiFemmine(int n, manager_t VettManager[]);

int main() {
    
    manager_t VettManager[10];
    int controllo;
    int i=0;
    int funzionescelta;
    printf("Inserisci:\n '1' se vuoi inserire un altro menager;\n '2' se vuoi stampare il nome e cognome dei manager che hannp fatto più di 20 voli;\n '3' se vuoi sapere chi tra i manager uomini e donne ha una media complessiva di voli pù alta\n");
  
    scanf("%d", &funzionescelta);
  switch(funzionescelta) {
        case 1:
            printf("Inserisci i manager ->");
           do {
               printf("Inserisci Nome, Cognome, Sesso e Voli fatti: \n");
               printf("Manager %d: \n", i+1);
               scanf("%s", VettManager[i].Nome);
               scanf("%s", VettManager[i].Cognome);
                scanf("%s", VettManager[i].Sesso);
                scanf("%d", &VettManager[i].NumeroVoli);
                i++;
                printf("Inserire 1 se si vuole aggiungere un altro manager, 0 se si vuole cambiare funzione\n");
                scanf("%d", &controllo);
            } while (controllo==1);
            
            break;
            
        default:
            break;
    }
    
//mediaSup20(N, VettManager);
    
// mediaMaschiFemmine(N, VettManager);


void mediaSup20(int n, manager_t VettManager[]){
    int i;
    for(i=0; i < n;i++){
        if(VettManager[i].NumeroVoli > 20){
            printf("%s ", VettManager[i].Nome);
            printf("%s\n", VettManager[i].Cognome);
        }
        
    }
}

void mediaMaschiFemmine(int n, manager_t VettManager[]){
    int i;
    int numF=0, numM=0;
    float mediaF=0, mediaM=0;
    float sommaF=0, sommaM=0;
    for(i=0; i < n;i++){
        if(strcmp(VettManager[i].Sesso,"femmina")==0){
            sommaF +=VettManager[i].NumeroVoli;
            numF++;
        }
        else{
            sommaM +=VettManager[i].NumeroVoli;
            numM++;
        }
    }
    mediaF = sommaF/numF;
    mediaM = sommaM/numM;
    if(mediaF > mediaM){
        printf("Le manager donna hanno media complessiva più alta!\n");
    }
    else if(mediaM > mediaF){
        printf("I manager uomini hanno media complessiva più alta!\n");
    }
    else{
        printf("Manager donne e uomini hanno stessa media complessiva!\n");
    }
}
