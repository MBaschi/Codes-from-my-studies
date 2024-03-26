#include <stdio.h>

int main() {
    char c[4] = {'L', 'U', 'C', 'A'};
    int i;
    for(i = 0; i < 4; i++) {
        printf("%c\n", c[i]);
    }
    printf("\n");
    char* c_ptr = c; //equivalente a char* c_ptr = &c[0];
    *c_ptr = 'M';
    *(++c_ptr) = 'I';
    *(c_ptr + 1) = 'N';
    *(c_ptr + 2) = 'O';
    for(i = 0; i < 4; i++) {
        printf("%c\n", c[i]);
    }
    return 0;
}
