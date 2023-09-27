#include <stdio.h>

void invertiStampa(char *str);

int main(){
  char stringa[100];
  
  printf("Inserisci parola: ");
  scanf("%s",stringa);
  invertiStampa(stringa);
}

void invertiStampa(char *str){
  if (*str=='\0')
    printf(" ");
  else
  {
    printf("%c",*str);
    invertiStampa(str+1);
    printf("%c",*str);
  }
}