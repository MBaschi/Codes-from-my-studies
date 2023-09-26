#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/Nuova cartella/LAB0.c"
void main() {


TRISC = 0xFF;
 TRISC = 255;

 ANSELC = 0;

 TRISD = 0;
 ANSELC = 0xFF;

 while(1)
 LATD = PORTC;
}
