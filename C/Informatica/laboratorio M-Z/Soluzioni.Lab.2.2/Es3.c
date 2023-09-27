#include <stdio.h>

int leggiCaratteri(char stringa_in[]){
    char c;
    char terminatore = '$';
    int i = 0;
    printf ("Inserisci caratteri; termina con %c:", terminatore);
    scanf ("%c", &c);
    while (c != terminatore)
    {
        stringa_in[i] = c;
        i++;
        scanf ("%c", &c);
    }
    return i;
}

void codifica(char stringa_in[], int numCaratteri, char stringa_out[]){
    int i;
    for (i = 0; i < numCaratteri; i++)
    {
        if (stringa_in[i] == ' ')
        {
            stringa_out[i] = '_';
        }
        else if (stringa_in[i] < 'z')
        {
            stringa_out[i] = stringa_in[i] + 1;
        }
        else
        {
            stringa_out[i] = 'a';
        }
    }
    
}

int main(int argc, const char * argv[]) {
    int MAX = 100;
    char stringa_in[MAX], stringa_out[MAX];
    
    int numCaratteri;
    int i;
    
    numCaratteri = leggiCaratteri(stringa_in);
    
    codifica(stringa_in, numCaratteri, stringa_out);
    
    printf ("\nStringa codificata: ");
    for (i = 0; i < numCaratteri; i++)
    {
        printf ("%c", stringa_out[i]);
    }
    return(0);
}

