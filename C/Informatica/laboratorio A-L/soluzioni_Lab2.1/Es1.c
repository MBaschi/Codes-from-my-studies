#include <stdio.h>

int main() {

    int campo[6];
    int errori = 0;
    int ace= 0;
    
    float ePerc, acePerc;
    
    int val;
    
    for (int i=0; i<6; i++)
        campo[i] = 0;
    
    do{
        printf("Inserisci posizione (1-6), ACE (-1), errore (-2): ");
        scanf("%d",&val);
        if (val==-1)
            ace++;
        else if (val==-2)
            errori++;
        else
        {
            campo[val-1]++;
        }
    }while(val!=0);
    
    val = 0;
    for (int i=0; i<6; i++)
    {
        val+=campo[i];
    }
    val+=errori;
    val+=ace;
    
    if (val!=0)
    {
        ePerc = errori/(float)val*100;
        acePerc = ace/(float)val*100;
        for (int i=0; i<6; i++)
            campo[i] = campo[i]*100/val;
    }
    printf("Ace %%: %.2f%%\n",acePerc);
    printf("Errori %%: %.2f%%\n",ePerc);
    printf("|--------|----------|\n");
    printf("|        |\t%d%%\t%d%%\t|\n",campo[1],campo[0]);
    printf("|        |\t%d%%\t%d%%\t|\n",campo[2],campo[5]);
    printf("|        |\t%d%%\t%d%%\t|\n",campo[3],campo[4]);
    printf("|--------|----------|\n");
    return 0;
}
