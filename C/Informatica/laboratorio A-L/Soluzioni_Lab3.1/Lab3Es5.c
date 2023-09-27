/*
Scrivere un programma che permetta di inserire un testo 
(compresi gli spazi) di al massimo 1024 caratteri. Attraverso 
un menu, il programma deve:
– Inserire un nuovo testo
– Cercare una parola inserita dall'utente e invertirne le 
lettere (la parola può essere presente più di una volta)
– Cercare una parola e renderla tutta maiuscola (la 
parola può essere presente più di una volta)
– Stampare il testo
Effettuare la ricerca della parola scrivendo una funzione.
*/

#include <stdio.h>
#include <string.h>

char* cercaParola(char t[], char parola[]);
void invertiParola(char parola[], char parolaInvertita[]);

int main()
{
  char testo[1024];
  char parola[100];
  char parolaInv[100];
  char *ret;
  char r;
  do{
    printf("MENU\n\na) Inserisci testo\nb) Cerca la parola e inverti\nc) Stampa testo\n\n>> ");
    fflush(stdin);//Quando la lettura di caratteri o stringhe salta, questa riga risolve il problema. su mac, fflush(stdin) diventa fpurge(stdin); su repl.it diventa __fpurge(stdin);
    scanf("%c",&r);
    switch(r)
    {
      case 'a':
        printf("Inserisci testo:\n");
        fflush(stdin);
        gets(testo);
        break;
      case 'b':
        printf("Inserisci la parola da cercare: ");
        fflush(stdin);
        scanf("%s",parola);
        invertiParola(parola,parolaInv);  
        
        do{
          ret = cercaParola(testo,parola);
          if (ret!=NULL)
          {
            strncpy(ret,parolaInv,strlen(parola));
          }
        }while (ret!=NULL);
        
        break;
      case 'c':
        printf("Il testo inserito/modificato e':\n%s\n",testo);
        break;
      

    }
  }while(r!='e');
  return 0;
  
}
char* cercaParola(char t[], char parola[])
{
  char *a;
  a = strstr(t,parola);
  if (a!=NULL)
    return a;
  else
    return NULL;
}

void invertiParola(char parola[], char parolaInvertita[])
{
  for (int i=0; i<strlen(parola); i++)
  {
    parolaInvertita[strlen(parola)-i-1] = parola[i];
  }
}















