void main() {
       int i=0;
    TRISC = 0xFF; // Spengo buffer uscita digitale
    ANSELC = 0; // Accendo il buffer ingresso digitale

    TRISD = 0; // Accendo buffer uscita digitale
    ANSELD = 0xFF; // Spengo il buffer ingresso digitale

    while(1)
        LATD = PORTC;

}