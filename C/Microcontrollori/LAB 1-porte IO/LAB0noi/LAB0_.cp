#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB1-porte IO/LAB0noi/LAB0_.c"
void main() {
 int i=0;
 TRISC = 0xFF;
 ANSELC = 0;

 TRISD = 0;
 ANSELD = 0xFF;

 while(1)
 LATD = PORTC;

}
