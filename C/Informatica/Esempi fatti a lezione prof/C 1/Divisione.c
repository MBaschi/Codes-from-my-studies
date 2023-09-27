#include <stdio.h>

void main() {
    int a;
    int b;
    float af;
    float bf;
    int risInt;
    float risFloat;
    a = 5;
    b = 3;
    af = 5;
    bf = 3;
    risFloat = af/bf;
    printf("float, float -> float %f\n", risFloat);
    
    risInt = af/bf;
    printf("float, float -> int %d\n", risInt);
    
    risFloat = a/bf;
    printf("int, float -> float %f\n", risFloat);
    
    risFloat = (float)a/b;
    printf("cast esplicito, cast implicito -> float %f\n", risFloat);
}
