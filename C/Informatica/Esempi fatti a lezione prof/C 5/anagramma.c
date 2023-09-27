#include <stdio.h>
#include <string.h>
#define N 10

int main() {

    char parola1[N];
    char parola2[N];
    int len;
    int cp1;
    int cp2;
    int i;
    int j;
    int alfabeto[26];
    
    printf("Inserisci la prima parola -> ");    //acquisisci prima parola
    scanf("%s", parola1);
    
    printf("Inserisci la seconda parola -> ");
    scanf("%s", parola2);
    
    len = (int)strlen(parola1);
    
    if (strlen(parola2) != len) {    //per essere anagrammi devono avere la stessa lunghezza
        printf("Non sono anagrammi!\n");
        return 0;
    }
    
    for(i=0; i<26; i++) {           //inizializzo a 0 tutti i caratteri dell'array alfabeto
        alfabeto[i] = 0;
    }
    
    i=0;                            //per iniziare correttamente il ciclo
    while (i<len) {
        if (alfabeto[parola1[i]-'a']==0) {
            cp1=0;
            cp2=0;
            for (j=0; j<len; j++) {
                if (parola1[j]==parola1[i]) {
                    cp1++;
                }
                if (parola2[j]==parola1[i]) {
                    cp2++;
                }
            }
            if (cp1!=cp2) {
                printf("Non sono anagrammi!\n");
                return 0;
            }
            else {
                alfabeto[parola1[i]-'a'] = 1;
            }
        }
        i++;
    }
    printf("Sono anagrammi!\n");
}
