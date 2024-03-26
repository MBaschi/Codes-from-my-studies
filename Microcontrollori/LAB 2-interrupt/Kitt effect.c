
/*
Reproduce the "Kitt Car effect" on PORTC
*/

void main() {

    // ----------Variables--------------
    short unsigned int dir = 0;
    // ---------------------------------
    
    // ------Register Configuration-----
    // ------PORTC------
    TRISC = 0;  // PORTC configured as Output, ANSELC not required
    // -----------------
    // ---------------------------------

    // ---------Initialization----------
    LATC = 1;
    // ---------------------------------


    while(1){

        if(dir)
            LATC >>= 1; // LATC = LATC >> 1;
        else
            LATC <<= 1; // LATC = LATC << 1;
        
        if(LATC >= 0b10000000)
            dir = 1;
        else if(LATC <= 0b00000001)
            dir = 0;

        Delay_ms(300);
    }
}