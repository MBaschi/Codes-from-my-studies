#include <stdio.h>

#define n_elem 6

int isLowerCase(char c){
    if(c >= 'a' && c <= 'z')
        return 1;
    else
        return 0;
}

int toUpperCase(char c){
    return c - 32;
}

int toLowerCase(char c){
    return c + 32;
}


int main(int argc, const char * argv[]){
    int i;
    char inputString[n_elem] = {'A', 'B', 'c', 'D', 'e', 'f'} ;
    printf("inputString[6] = {");
    for(i=0; i<n_elem;i++){
        printf("%c",inputString[i]);
        if(i!=(n_elem-1)){
            printf(", ");
        }
        else{
            printf("}\n");
        }
    }
    
    for(i=0; i<n_elem; i++){
        if(isLowerCase(inputString[i])){
            inputString[i] = toUpperCase(inputString[i]);
        } else {
            inputString[i] = toLowerCase(inputString[i]);
        }
    }
    printf("inputString[6] = {");
    for(i=0; i<n_elem;i++){
        printf("%c",inputString[i]);
        if(i!=(n_elem-1)){
            printf(", ");
        }
    }
    printf("}\n");
    
    return 0;
}
