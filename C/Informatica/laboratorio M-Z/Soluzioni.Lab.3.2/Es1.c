#include <stdio.h>
#include <string.h>

#define N 3

typedef struct manager{
    char Nome[20];
    char Cognome[20];
    char Sesso[10];
    int NumeroVoli;
}t_manager;

void mediaSup20(int n, t_manager VettManager[]);
void mediaMaschiFemmine(int n, t_manager VettManager[]);

int main(int argc, const char * argv[]) {
    
    t_manager VettManager[N];
    int i;
    
    printf("Inserisci Nome, Cognome, Sesso e Voto Medio degli studenti: \n");
    for(i=0;i<N;i++){
        printf("Manager %d: \n", i+1);
        scanf("%s", VettManager[i].Nome);
        scanf("%s", VettManager[i].Cognome);
        scanf("%s", VettManager[i].Sesso);
        scanf("%d", &VettManager[i].NumeroVoli);
        
    }
    
    mediaSup20(N, VettManager);
    
    mediaMaschiFemmine(N, VettManager);
    
    return 0;
    
}

void mediaSup20(int n, t_manager VettManager[]){
    int i;
    for(i=0; i < n;i++){
        if(VettManager[i].NumeroVoli > 20){
            printf("%s ", VettManager[i].Nome);
            printf("%s\n", VettManager[i].Cognome);
        }
        
    }
}

void mediaMaschiFemmine(int n, t_manager VettManager[]){
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
