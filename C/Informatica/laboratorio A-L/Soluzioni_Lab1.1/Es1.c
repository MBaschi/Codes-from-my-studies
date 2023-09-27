#include <stdio.h>

//int main(int argc, const char * argv[]) {
//    int num1, num2;
//    int risultato;
//
//    printf("Inserisci il primo numero: ");
//    scanf("%d",&num1);
//    printf("Inserisci il secondo numero: ");
//    scanf("%d",&num2);
//    risultato = num1+num2;
//    printf("Il risultato è: %d\n",risultato);
//
//    return 0;
//}

//Senza la variabile risultato
//int main(int argc, const char * argv[]) {
//    int num1, num2;
//
//    printf("Inserisci il primo numero: ");
//    scanf("%d",&num1);
//    printf("Inserisci il secondo numero: ");
//    scanf("%d",&num2);
//    printf("Il risultato è: %d\n",num1+num2);
//
//    return 0;
//}

////Stampa solo se risutlato è positivo
//int main(int argc, const char * argv[]) {
//    int num1, num2;
//    int risultato;
//    printf("Inserisci il primo numero: ");
//    scanf("%d",&num1);
//    printf("Inserisci il secondo numero: ");
//    scanf("%d",&num2);
//    risultato = num1+num2;
//    if (risultato>0)
//        printf("Il risultato è: %d\n",risultato);
//    else
//        printf("Il risultato è negativo.\n");
//
//    return 0;
//}

//Stampa solo se i due numeri sono positivi
//int main(int argc, const char * argv[]) {
//    int num1, num2;
//
//    printf("Inserisci il primo numero: ");
//    scanf("%d",&num1);
//    printf("Inserisci il secondo numero: ");
//    scanf("%d",&num2);
//    if (num1>0 && num2>0)
//        printf("Il risultato è: %d\n",num1+num2);
//    else
//        printf("Uno dei due numeri è negativo\n");
//
//    return 0;
//}

//While per controllo
int main(int argc, const char * argv[]) {
    int num1, num2;
    int risultato;
    printf("Inserisci il primo numero: ");
    do{
        scanf("%d",&num1);
        if (num1<0)
            printf("Hai inserito un numero negativo, inseriscine uno positivo: ");
    }while(num1<0);
    printf("Inserisci il secondo numero: ");
    do{
        scanf("%d",&num2);
        if (num2<0)
            printf("Hai inserito un numero negativo, inseriscine uno positivo: ");
    }while(num2<0);
    
    risultato = num1+num2;
    printf("Il risultato è: %d\n",risultato);
    
    return 0;
}
