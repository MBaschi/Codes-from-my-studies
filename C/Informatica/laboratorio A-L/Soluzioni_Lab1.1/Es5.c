#include <stdio.h>

int main(int argc, const char * argv[]) {
    int anno;
    
    printf("Inserisci l'anno da analizzare\n");
    scanf("%d",&anno);
    if (((anno%4==0) && (anno%100!=0)) || (anno%400==0))
        printf("%d è bisestile\n",anno);
    else
        printf("%d NON è bisestile\n",anno);
    return 0;
}
