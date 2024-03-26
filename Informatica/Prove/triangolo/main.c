#include <stdio.h> ///stampo un triangolo

int main() {
    int numSpazi;
    int numAsterischi;
    int i;
    int j;
    
    i=0;
    while (i<6) {
        numSpazi = 5-i;
        numAsterischi = 11-2*numSpazi;
        j=0;
        while (j<numSpazi) {
            printf("   ");
            j++;
        }
        j=0;
        while (j<numAsterischi) {
            printf(" + ");
            j++;
        }
        printf("\n");
        i++;
    }
    return 0;
}
