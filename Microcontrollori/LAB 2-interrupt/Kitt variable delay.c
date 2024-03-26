/*
Reproduce the "Kitt Car effect" on PORTC
*/

int delayKitt = 500;

void main() {

    // ----------Variables--------------
    short unsigned int dir = 0;
    // ---------------------------------
    
    // ------Register Configuration-----

    ANSELB = 0b00111111;

    // ------PORTC------
    TRISC = 0;  // PORTC configured as Output, ANSELC not required
    // -----------------
    // ---------------------------------

    // ---------Initialization----------
    LATC = 1;
    // ---------------------------------

    IOCB = 0b11000000;

    INTCON.RBIE = 1;
    INTCON.RBIF = 0;
    INTCON.GIE = 1;

    while(1){

        if(dir)
            LATC >>= 1; // LATC = LATC >> 1;
        else
            LATC <<= 1; // LATC = LATC << 1;
        
        if(LATC >= 0b10000000)
            dir = 1;
        else if(LATC <= 0b00000001)
            dir = 0;

        VDelay_ms(delayKitt);
    }
}



void interrupt(){ //ISR

    if(INTCON.RBIF){

        if(PORTB.RB7)
            delayKitt += 100;

        if(PORTB.RB6)
            delayKitt -= 100;

        if(delayKitt > 5000)
            delayKitt = 5000;
        else if (delayKitt < 50)
            delayKitt = 50;

        INTCON.RBIF = 0;
    }


}