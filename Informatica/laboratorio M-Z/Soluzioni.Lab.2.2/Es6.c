#include <stdio.h>

void moltiplica(int *vett_in, int *vett_out_molt){
    int i, j;
    for(i=0, j=0; i<10; i=i+2, j++){
        vett_out_molt[j] = vett_in[i] * vett_in[i+1];
    }
}

void somma_simmetrici(int *vett_in, int *vett_out_somma){
    int i, j;
    for(i=0, j=0; i<5; i++, j++){
        vett_out_somma[j] = vett_in[i] + vett_in[9-i];
    }
}

void conta_percentuali(int vett_in[], float *perc_neg, float *perc_pos){
    int i;
    int pos=0, neg=0;
    for(i=0; i<10; i++){
        if(i>=0)
            pos++;
        else
            neg++;
    }
    *perc_neg = (neg*100)/10;
    *perc_pos = (pos*100)/10;
}

int main(int argc, const char * argv[]){
    int vett_in[10];
    int vett_out_molt[5];
    int vett_out_somma[5];
    float perc_neg, perc_pos;
    int i;
    
    printf ("Inserisci gli elementi di vett_in: \n");
    for (i=0; i<10; i++){
        scanf("%d\n",&vett_in[i]);
    }
    moltiplica(vett_in, vett_out_molt);
    somma_simmetrici(vett_in, vett_out_somma);
    conta_percentuali(vett_in, &perc_neg, &perc_pos);
    printf("vett_in[] \t\t=\t { ");
    for(i=0;i<10; i++){
        printf("%d",vett_in[i]);
        if(i<9)
            printf(", ");
    }
    printf("}\n");
    printf("vett_out_molt[] \t=\t { ");
    for(i=0;i<5; i++){
        printf("%d",vett_out_molt[i]);
        if(i<4)
            printf(", ");
    }
    printf("}\n");
    printf("vett_out_somma[] \t=\t { ");
    for(i=0;i<5; i++){
        printf("%d",vett_out_somma[i]);
        if(i<4)
            printf(", ");
    }
    printf("}\n");
    printf("Le percentuali di numeri positivi e negativi sono %0.2f e %0.2f\n", perc_pos, perc_neg);
    
    
    return 0;
}
