int delayLED = 500;


void main() {


    //TRISD = 0b11111110; 
    TRISD.RD0 = 0; // Accende il buffer uscita digitale

    ANSELB.RB6 = 0; // Accendo buffer ingresso digitale

    IOCB = 0b01000000;

    INTCON.RBIE = 1; // Abilito interrupt IOCB
    INTCON.RBIF = 0; // Resetto la flag di interrupt IOCB
    INTCON.GIE = 1; // Abilito interrupt globali

    //INTCON = 0b10001000;

    while(1){
        VDelay_ms(delayLED);
        LATD.RD0 = !LATD.RD0;
    }

}


void interrupt(){

    if (INTCON.RBIF){
        if(PORTB.RB6)
            delayLED -= 100;

        INTCON.RBIF = 0;
    }
}