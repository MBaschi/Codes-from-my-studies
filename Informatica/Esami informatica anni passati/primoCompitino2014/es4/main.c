
#include <stdio.h>
#include <string.h>

#define N 5
#define M 11

int main() {
    
    
    char parole [N][M];
    int num[26];
    int i;
    int j;
    int len;
    char c;
    
    for (i=0; i<26; i++) {
        num[i]=0;
    }
    
    for (i=0; i<N; i++) {
        printf("Inserisci la parola %d: ", i);
        scanf("%s", parole[i]);
    }
    
    for (i=0; i<N; i++) {
        
        len = (int)strlen(parole[i]);
        printf("%s", parole[i]);
        printf(" - length: %d", len);
        printf("\n");
        
        if (len >= 6) {
            for (j=0; j<len; j++) {
                c = parole[i][j];
                num[c-'a']++;
            }
        }
        
    }
    
    printf("\n");
    
    for (i=0; i<26; i++) {
        if (num[i]>0) {
            printf("%c -> %d\n", 'a'+i, num[i]);
        }
    }
    
    printf("\n\n");
    
    return 0;
}
