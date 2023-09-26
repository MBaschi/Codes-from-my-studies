
//BLINKING LED
int delayLED = 500; // 16 bit signed  globale perchè deve andare nel interrup, usare le varibili globali solo se serve

void main() {
    
    TRISD = 0b11111110; // disabilito buffer d'uscita per tutti tranne per l'ltimo
    
    TRISD.RD0 = 0; // cosiì modifichiamo direttamente il bit 0 dello sp
    ANSELB.RB6 = 0; // Accendo buffer ingresso digitale della porta B

    IOCB = 0b01000000; // setto la porta B a 01000000

    
    INTCON.RBIE = 1; // Abilito interrupt IOCB
    INTCON.RBIF = 0; // Resetto la flag di interrupt IOCB
    INTCON.GIE = 1; // Abilito interrupt globali

    //INTCON = 0b10001000; // altro modo di scrivere le tre istruzioni precedenti

    while(1){
        //Delay_ms(500); // delay in ms funziona solo in micro C, SPOILER delay fa schifo perche mezzo secondo fermo di codice è troppo
                        // delay non accetta variabili ma sono costanti perciò si può usare VDelay
        VDelay_ms(500);
        LATD.RD0 = !LATD.RD0; // cambia valore del bit 0 porta D per accendere led
    }

}
void interrupt(){ // interruprt è chiamato automaticamente dal microcontrollore non va chimato dal main

    if (INTCON.RBIF){ // polling 
        if(PORTB.RB6) // leggo porta 
            delayLED -= 100; // modifico delay -= significa sottrai quello a destra

        INTCON.RBIF = 0; // riazzero flag 
    }
}
// il problema di questo codice è che delay led può diventare negativo 