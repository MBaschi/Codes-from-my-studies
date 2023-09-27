//
//  main.c
//  Lab2Es8
//
//  Created by Paolo on 30/10/17.
//  Copyright © 2017 Paolo. All rights reserved.
//
#include <stdio.h>

#define DIM 22

void converti(int *array_in, char *array_out);

int main(int argc, const char * argv[]) {
    int array_in[DIM] = {67, 79, 77, 80, 76, 73, 77, 69, 78, 84, 73, 33, 72, 97, 105, 70, 105, 110, 105, 116, 111, 33};
    char array_out[DIM];
    
    converti(array_in, array_out);
    
    for (int i=0; i<DIM; i++)
        printf("%c ", *(array_out+i));
    printf("\n");
    return 0;
}

void converti(int *array_in, char *array_out)
{
    for (int i=0; i<DIM; i++){
        *(array_out+i) = (char)(*(array_in+i));
    }
}
