/*
Scrivere un programma per la gestione della valutazione di un esame universitario. Il programma deve tenere in 
considerazione: 
– Cognome
– Nome
– Matricola
– Esami [4]
– Numero esami sostenuti
– Promosso (0 non promosso - 1 promosso)
Ogni Esame contiene 
- la data dell'esame
- la valutazione. 

Il programma tiene a memoria al massimo 4 prove (array di 4). 
Inizializzare l'array di esami.voto a -1 (non sostenuti). Il programma deve avere un menù (usare switch-case) che permetta di:
- Inserire un nuovo studente (senza inserire alcun esame). In automatico la casella promosso è definita 0.
- Aggiungere un esame cercando lo studente per matricola
- Stampare cognome, matricola e voto degli studenti che hanno sostenuto un esame (viene richiesto di inserire un numero da 1 a 4 per selezionare l'esame)
- Stampare cognome, matricola e voto degli studenti promossi.
Il campo Promosso deve essere automaticamente modificando quando inserito un voto >=18
*/

#include <stdio.h>
#include <string.h>

typedef struct esame{
  int voto;
  int data;
} esame;

typedef struct studente{
  char cognome[20];
  char nome[20];
  int matricola;
  esame esami[4];
  int numero_esami;
  int promosso;
} studente;

int inserisciStudente (studente studenti[], int numStud);
void aggiungiEsame(studente stud[], int numStud, int matricola);
void stampaStudentiEsame(studente stud[], int numStud, int numEsame);
void stampaPromossi(studente stud[], int numStud);

int main(){
  studente corso[100];
  int d, numeroStudenti = 0, matricola, e;
  
  do{
    printf("MENU\n\n1) Inserisci studente\n2) Inserisci esame\n3) Stampa studenti iscritti\n4) Stampa studenti promossi\n5) ESCI\n\n>> ");
    scanf("%d",&d);
    
    switch(d)
    {
      case 1:
        numeroStudenti = inserisciStudente(corso, numeroStudenti);
        break;
      
      case 2:
        printf("Quale matricola cerco: ");
        scanf("%d",&matricola);
        aggiungiEsame(corso,numeroStudenti,matricola);
      break;
      case 3:
        printf("Quale appello vuoi visualizzare: ");
        scanf("%d",&e);
        stampaStudentiEsame(corso, numeroStudenti, e);
      break;
      case 4:
        stampaPromossi(corso, numeroStudenti);
      break;
      
    }
  }while(d!=5);
  return 0;
}

int inserisciStudente (studente studenti[], int numStud){
  printf("Inserisci nome: ");
  fflush(stdin); //Quando la lettura di caratteri o stringhe salta, questa riga risolve il problema. su mac, fflush(stdin) diventa fpurge(stdin); su repl.it diventa __fpurge(stdin);
  gets(studenti[numStud].nome);
  printf("Inserisci cognome: ");
  fflush(stdin);
  gets(studenti[numStud].cognome);
  printf("Inserisci matricola: ");
  scanf("%d",&studenti[numStud].matricola);
  for (int i=0; i<4; i++)
    studenti[numStud].esami[i].voto = -1;
  studenti[numStud].numero_esami = 0;
  studenti[numStud].promosso = 0;
  numStud++;
  return numStud;
}

void aggiungiEsame(studente stud[], int numStud, int matricola){
  
  int trovato = 0;
  for (int i=0; i<numStud; i++)
  {
    if (stud[i].matricola == matricola)
    {
      trovato = 1;
      if (stud[i].numero_esami<4)
      {
        printf("Inserisci voto: ");
        scanf("%d",&stud[i].esami[stud[i].numero_esami].voto);
        printf("Inserisci data: ");
        scanf("%d",&stud[i].esami[stud[i].numero_esami].data);
        if (stud[i].esami[stud[i].numero_esami].voto >= 18)
          stud[i].promosso = 1;
        stud[i].numero_esami++;
      }
      else
        printf("Lo studente ha gia' sostenuto 4 esami");
    }
  }
  if (trovato==0)
    printf("Studente non trovato\n");
  
}

void stampaStudentiEsame(studente stud[], int numStud, int numEsame)
{
  printf("Studenti che hanno sostenuto il %d esame\n",numEsame);
  
  printf("Cognome\tMatricola\tVoto\n\n");
  for (int i =0; i<numStud; i++)
  {
    if (stud[i].numero_esami>=numEsame)
    {
      printf("%s\t%d\t%d\n",stud[i].cognome,stud[i].matricola,stud[i].esami[numEsame-1].voto);
    }
  }
}

void stampaPromossi(studente stud[], int numStud){
  for (int i=0; i<numStud; i++)
  {
    if (stud[i].promosso==1)
    {
      printf ("Cognome: %s\tMatricola: %d\tVoto: %d\n",stud[i].cognome,stud[i].matricola, stud[i].esami[stud[i].numero_esami-1].voto);
    }
  }
}


















