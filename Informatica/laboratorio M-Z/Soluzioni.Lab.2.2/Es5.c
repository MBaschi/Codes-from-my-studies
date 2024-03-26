#include <stdio.h>

#define n_lettere 38

void genera_valori_buleani(int *boolv);
void filtro(char *stringa, int *boolv, char *stringa_out);

int main(int argc, const char * argv[]){
    char stringa[n_lettere]="Nel mezzo del cammin di nostra vita...";
    int boolv[n_lettere];
    char stringa_out[n_lettere];
    genera_valori_buleani(boolv);
    filtro(stringa, boolv, stringa_out);
    printf("%s \n", stringa);
    printf ("%s\n", stringa_out);
    return 0;
}

void genera_valori_buleani(int *boolv){
    int i;
    for(i = 0; i<n_lettere; i++){
        if(i%3 == 0){
            boolv[i]=1;
        }
        else{
            boolv[i]=0;
        }
    }
}

void filtro(char *stringa, int *boolv, char *stringa_out)
{
    int i;
    for (i=0; i<n_lettere; i++){
        if (boolv[i]==1)
        {
            stringa_out[i]=stringa[i];
        }
        else{
            stringa_out[i]=' ';
        }
    }
    stringa_out[i]='\0';
    //return stringa_out;
}
