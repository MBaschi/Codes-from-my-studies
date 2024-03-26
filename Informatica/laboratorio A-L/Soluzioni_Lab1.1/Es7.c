#include <stdio.h>

//Risolto con array
int main(int argc, const char * argv[]) {
    float voto;
    float max = 0;
    float min = 10;
    float votoFinale = 0;
    int first = 1;
    
    printf("Inserire i 5 voti:\n");
    for (int i=0; i<5; i++)
    {
        scanf("%f",&voto);
        {
            if (voto>max)
                max = voto;
            if (voto<min)
                min = voto;
            votoFinale += voto;
        }
    
    }
  
    votoFinale = (votoFinale-min-max) * 2;
    printf("Il voto finale è: %.1f",votoFinale);
    return 0;
}
