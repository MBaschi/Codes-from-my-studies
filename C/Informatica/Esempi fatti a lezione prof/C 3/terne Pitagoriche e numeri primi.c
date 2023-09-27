//  ternePitagoriche

#include <stdio.h>

int primiTraLoro(int a, int b);

int main(int argc, const char * argv[]) {
    
    
    int primoNumero;
    int secondoNumero;
    int terzoNumero;
    int terneInserite=0;
    int i;
    
    //primo numero
    
    printf("Inserisci il primo numero (positivo): ");
    scanf("%d", &primoNumero);
    
    while (primoNumero<=0 && primoNumero!=-1){
        printf("***Inserimento errato***");
        printf("Inserisci il primo numero (positivo): ");
        scanf("%d", &primoNumero);
    }
    
    if (primoNumero==-1) {
        printf("Non hai inserito abbastanza numeri...\n");
        return 0;
    }
    
    //secondo numero
    
    printf("Inserisci il secondo numero (positivo): ");
    scanf("%d", &secondoNumero);
    
    while (secondoNumero<=0 && secondoNumero!=-1){
        printf("***Inserimento errato***");
        printf("Inserisci il secondo numero (positivo): ");
        scanf("%d", &secondoNumero);
    }
    
    if (secondoNumero==-1) {
        printf("Non hai inserito abbastanza numeri...\n");
        return 0;
    }
    //terzo numero
    
    
    printf("Inserisci il terzo numero (positivo): ");
    scanf("%d", &terzoNumero);
    
    while (terzoNumero<=0 && terzoNumero!=-1){
        printf("***Inserimento errato***");
        printf("Inserisci il terzo numero (positivo): ");
        scanf("%d", &terzoNumero);
    }
    
    if (terzoNumero==-1) {
        printf("Non hai inserito abbastanza numeri...\n");
        return 0;
    }
    
    
    if (primoNumero*primoNumero + secondoNumero*secondoNumero == terzoNumero*terzoNumero) {
        if (primiTraLoro(primoNumero, secondoNumero) && primiTraLoro(secondoNumero, terzoNumero) && primiTraLoro(primoNumero, terzoNumero)) {            terneInserite++;
        }
    }
    
    
    //inserimento di altri numeri
    
    do {
        
        primoNumero = secondoNumero;
        secondoNumero = terzoNumero;
        
        printf("Inserisci un altro numero (positivo): ");
        scanf("%d", &terzoNumero);
        
        while (terzoNumero<=0 && terzoNumero!=-1){
            printf("***Inserimento errato***");
            printf("Inserisci il terzo numero (positivo): ");
            scanf("%d", &terzoNumero);
        }
        
        if (terzoNumero != -1) {
            if (primoNumero*primoNumero + secondoNumero*secondoNumero == terzoNumero*terzoNumero) {
                if (primiTraLoro(primoNumero, secondoNumero) && primiTraLoro(secondoNumero, terzoNumero) && primiTraLoro(primoNumero, terzoNumero)) {            terneInserite++;
                }
            }
        }
        
    }while (terzoNumero != -1);
    
    printf("Il numero di terne pitagoriche inserite è %d.\n", terneInserite);
    
    
    
    //esempio di sequenza
    // 3 4 5 6 8 10 11 5 12 13
    
    
    
    
    return 0;
}


int primiTraLoro(int a, int b) {
    
    int primiTraLoro = 1;
    int i;
    int temp;
    
    if (a>b) {
        temp = a;
        a = b;
        b = temp;
    }
    
    for (i=2; i<a && primiTraLoro==1; i++) {
        if (a % i == 0 && b % i == 0) {
            primiTraLoro=0;
        }
    }
    
    
    return primiTraLoro;

}



