#include <stdio.h>
#define N 10

///simile al metodo di bisezione

int main() {
    
    int dato[N] = {1, 5, 8, 9, 13, 16, 19, 23, 35, 41};
    int sx;
    int dx;
    int daCercare;
    int m;
    
    printf("Inserisci un valore -> ");
    scanf("%d", &daCercare);
    
    sx = 0;
    dx = N-1;
    while (sx <= dx) {
        m = (sx+dx)/2;
        if (dato[m]==daCercare) {
            printf("Elemento trovato in posizione -> %d\n", m);
            break;
        }
        else if (daCercare > dato[m]) {
            sx = m + 1;
        }
        else {
            dx = m-1;
        }
    }
    if (sx > dx) {
        printf("L'elemento non è stato trovato\n");
    }
}
