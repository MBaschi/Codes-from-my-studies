#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 3-timer0/lab3.c"
 int led_ms = 0;
int kitt_delay = 1000;


void main() {




 short unsigned int dir = 1;






 TRISB.RB7 = 1;
 TRISB.RB6 = 1;

 ANSELB.RB7 = 0;
 ANSELB.RB6 = 0;

 IOCB = 0b11000000;



 TRISC = 0;



 INTCON.RBIE = 1;
 INTCON.RBIF = 0;








 T0CON = 0b11000111;
#line 53 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 3-timer0/lab3.c"
 INTCON.TMR0IE = 1;
 INTCON.TMR0IF = 0;




 LATC = 1;




 INTCON.GIE = 1;

 while(1){


 if (led_ms >= kitt_delay){


 if(dir)
 LATC <<= 1;
 else
 LATC >>= 1;
#line 86 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 3-timer0/lab3.c"
 if(LATC >= 0b00000001)
 dir = 1;
 else if(LATC <= 0b10000000)
 dir = 0;


 led_ms = 0;
 }
#line 106 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 3-timer0/lab3.c"
 }

}



void interrupt(){


 if(INTCON.TMR0IF){
 INTCON.TMR0IF = 0;

 led_ms += 33;

 }
 else if(INTCON.RBIF){

 if(PORTB.RB7)
 kitt_delay += 50;
 else if(PORTB.RB6)
 kitt_delay -= 50;

 if(kitt_delay < 50)
 kitt_delay = 50;
 else if(kitt_delay > 3000)
 kitt_delay = 3000;

 INTCON.RBIF = 0;
 }






}
