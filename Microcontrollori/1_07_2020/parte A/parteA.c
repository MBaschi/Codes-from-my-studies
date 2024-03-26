//ACCENDI SPEGNI CON PRESSIONE DI RC0
// Lcd module connections
sbit LCD_RS at LATB4_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATB0_bit;
sbit LCD_D5 at LATB1_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End Lcd module connections

void main() {
//INIZZIALIZZAZIONE
    //VARIABILI
       unsigned short int stato_accensione=0;
       unsigned short int RC0_VAL=0;
       unsigned short int RC0_OLD=0;
    //PORTE
    TRISC.RC0=1;  //pulsante di accensione
    ANSELC.RC0=0;
    TRISE.RE2=0;   // controllo motore
    ANSELE.RE2=1;  // è necessaria alta impedenza in ingresso per pilotare il motore quindi spengo buffer d'ingresso
    //LCD
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
    Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
    
    

//PROGRAMMA
    while(1){
        //A.1)verifica accensione
        RC0_VAL=PORTC.RC0;

        if (RC0_VAL!=RC0_OLD && RC0_VAL==1){ // notare che entro solo quando il valore cambio quindi come da richiesta LCD è aggiornato solo quanod è necessario
          
           stato_accensione=!stato_accensione;

           //A.2 e A.3)pilota motore e stampa
           if (stato_accensione==1){
            
            LATE.RE2=1;
            Lcd_cmd(_LCD_CLEAR);
            Lcd_out(1,1,"ACCESO"); 

           }
          else{
            LATE.RE2=0;
            Lcd_cmd(_LCD_CLEAR);
            Lcd_out(1,1,"SPENTO"); 
          }
        }
        RC0_OLD=RC0_VAL; 

        
        
    }
}