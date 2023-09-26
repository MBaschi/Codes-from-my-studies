 int led_ms = 0;
int kitt_delay = 1000;


void main() {



    // ----------Variables--------------
    short unsigned int dir = 1;
    // ---------------------------------


    // ------Register Configuration-----

    // ------PORTB------
	TRISB.RB7 = 1;		// RB7, RB6 configured as input
	TRISB.RB6 = 1;

	ANSELB.RB7 = 0;		// RB7, RB6 configured as "Digital"
	ANSELB.RB6 = 0;

 	IOCB = 0b11000000;	//RB6-7 IOCB Active
    // -----------------

	// ------PORTC------
    TRISC = 0;  		// PORTC configured as Output, ANSELC not required
    // -----------------

	// ----Interrupt----
 	INTCON.RBIE = 1;
    INTCON.RBIF = 0; // Set IOCB
	// -----------------


	// ---------------------------------


    // ---------------------------------

    T0CON = 0b11000111;

    /*
    T0CON.TMR0ON = 1;
    T0CON.T08BIT = 1;
    T0CON.T0CS = 0;
    T0CON.T0SE = 0;
    T0CON.PSA = 0;
    T0CON.T0PS2 = 1;
    T0CON.T0PS1 = 1;
    T0CON.T0PS0 = 1;
    */
   INTCON.TMR0IE = 1;
   INTCON.TMR0IF = 0;
   // ---------------------------------


    // ---------Initialization----------
    LATC = 1;
    // ---------------------------------

    // Others init .....

    INTCON.GIE = 1;

    while(1){

        //Delay_ms(300);
        if (led_ms >= kitt_delay){


            if(dir)
                LATC <<= 1;
            else
                LATC >>= 1;

            /*
            NOTE LAT vs PORT
            here it is a case where using LAT can be different than using PORT,
            PORT == 0bxxxxxxxx can get different result compared to
            LATC == 0bxxxxxxxx because the time needed to the buffer for
            rising up or down the output voltage level can be bigger than
            rising up the time needed for reach the instruction "if".
            */

            if(LATC >= 0b00000001)
                dir = 1;
            else if(LATC <= 0b10000000)
                dir = 0;


            led_ms = 0;
        }


        // Code

        // Code1 => STOP Fusioine Nucleare

        // COde 2





    }

}

//32.768 ms
//0.128 ms
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