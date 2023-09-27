#include <stdio.h>

int somma (int num);

int main(){
  int n;
  printf("Inserisci numero: ");  
  scanf("%d",&n);
  printf("La somma dei primi %d numeri e': %d",n,somma(n));
  return 0;
}

int somma (int num){
  if (num==0)
    return 0;
  else
    return num + somma(num-1);
}
