#define MAX 100
#define TRUE 1
#define FALSE 0

#include <stdio.h>

int checkArray(int ar[], int n, int m);

int main(){
  int num[MAX];
  int n=0;
  int m;
  
  printf("Inserisci array di numeri (-1 per terminare):\n");
  do{
    scanf("%d",&num[n]);
    n++;
  }while(n<MAX && num[n-1]!=-1);
  n = n-1;
  
  printf("Inserisci numero per confronto: ");
  scanf("%d",&m);
  printf("Il confronto ha dato risultato: %d\n",checkArray(num,n,m));
  return 0;
}

int checkArray(int ar[], int n, int m){
  if (n==0)
    return FALSE;
  else{
    if (ar[n]>m)
      return checkArray(ar,n-1,m);
    else
      return TRUE;
  }
}
