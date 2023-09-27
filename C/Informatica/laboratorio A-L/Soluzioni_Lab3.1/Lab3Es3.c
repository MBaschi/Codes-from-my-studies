/*
Scrivere un programma che prenda in ingresso massimo 10 
parole (il numero di parole da inserire viene richiesto all’utente 
all’inizio del programma).
Il programma deve stampare a video le parole inserite dall’utente in ordine alfabetico (per semplicità considerare solo la prima lettere della parola).

N.B.: Ogni parola-stringa è un array. Occorre quindi utilizzare un array di stringhe. Definire la lunghezza massima della parola = 10
*/
#include <stdio.h>
#include <string.h>

void invertiPosizione(char *parola1, char *parola2);
int main (){
  char parole[10][100];
  int n;
  
  printf("Quante parole vuoi inserire?\n>> ");
  scanf("%d",&n);
  for (int i=0; i<n; i++)
  {
    printf("Inserisci parola %d (solo lettere minuscole): ",i+1);
    scanf("%s",parole[i]);
  }
  for (int k=0; k<n; k++){
    for (int i=0; i<n-1; i++)
    {
      if (parole[i][0]>parole[i+1][0])
        invertiPosizione(parole[i],parole[i+1]);
    }
  }
  for (int i=0; i<n; i++)
  {
    printf("%s\n",parole[i]);
  }
}

void invertiPosizione(char *parola1, char *parola2){
  char temp[100];
  
  strcpy(temp, parola1);
  strcpy(parola1, parola2);
  strcpy(parola2, temp);
}
















