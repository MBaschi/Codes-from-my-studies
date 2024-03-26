// Leggi dalla porta RA0 collegata ad un poteziomento uno il valore di tensione, considera solo gli 8 bit più significativi
// Leggi dalla porta RD0 collegata ad un poteziomento due il valore di tensione, considera tutti e 10 i bit
// stampa il valore di tensione del potenziometro 1 alla prima riga del LCD e del potenziometro 2 alla riga 2
 unsigned short int new_value=0;



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

void main() {
  //VARIABILI
      unsigned int adc_10bit;  // da RA0
      unsigned short int adc_8bit; // da RD0
      unsigned short int channel=1; // channel=1 leggi pin A0 channel=0 leggi pin D0
      char pot1_mv[9];
      char pot2_mv[7];
      
 // SETTING 
    //Setting porte 
      TRISA.RA0=1; //port RA0 input
      ANSELA.RA0=1;
      TRISD.RD0=1;//port RD0 input
      ANSELD.RD0=1;

      TRISC=0;
    
    //setting ADC  
       // T_AD=1us
       ADCON2.ADCS0=1;
       ADCON2.ADCS0=0;
       ADCON2.ADCS0=0;
       // T_ACQT=8us
       ADCON2.ACQT0=0;
       ADCON2.ACQT1=0;
       ADCON2.ACQT2=1;
       //selezione porta iniziale
       ADCON0.CHS0=0;
       ADCON0.CHS1=0;
       ADCON0.CHS2=0;
       ADCON0.CHS3=0;
       ADCON0.CHS4=0;
       //giustificazione: per entrambe la metto left
       ADCON2.ADFM=0;
       
       //accendo ADC
         ADCON0.ADON=1;
        // LCD setting
       Lcd_Init(); // inizzializza LCD
       Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
       Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
       Lcd_Out(1,4,"ciaooooooooooooooooooo"); 
       //setting interrupt 
       PIE1.ADIE=1;
       PIR1.ADIF=0;
       INTCON.PEIE=1;
       INTCON.GIE=1;
       
 
 //PROGAMMA
  
   // do il primo go
   ADCON0.GO_NOT_DONE=1;
   Lcd_Out(2,4,"ciaoooooooooooooooooo");   
        
   while (1){

     
     if (new_value==1){ // è arrivato un nuovo dato
        
        // converti valore, traformalo in stringa e cambia canale
        if (channel==1){ // devo leggere RA0
           ADRESL>>6; // shifto adress low di 6 posizioni in modo che assuma il suo valore reale
           adc_10bit=5*(ADRESH*4+ADRESL); // sommo ADRESL con ADRESH*4 con ADRESH non faccio il doppio shift perchè ADRESH  è a 8 bit e salvandola su se stessa perderei i 2 bit più significativi    
           IntToStr(pot1_mv,adc_10bit);  

           // cambia canale
           ADCON0.CHS0=0;
           ADCON0.CHS1=0;
           ADCON0.CHS2=1;
           ADCON0.CHS3=0;
           ADCON0.CHS4=1;   
        }

        if (channel==0){ // devo leggere RD0
           adc_8bit=5*4*ADRESH; // salvo solo i primi, moltiplico per 4 perche mancano due LSB e per 5 per avere il valore in mv
           IntToStr(pot2_mv,adc_8bit); 
           // cambia canale
           ADCON0.CHS0=0;
           ADCON0.CHS1=0;
           ADCON0.CHS2=0;
           ADCON0.CHS3=0;
           ADCON0.CHS4=0;
           LATC=ADRESH;
        }

        
        
        new_value=0;     // riazzera new value
        channel!=channel; // cambia canale
        ADCON0.GO_NOT_DONE=1; // riprarti con conversione
     }
        
       
   }       
     
}

void interrupt(){
   
    if (PIR1.ADIF==1){
        PIR1.ADIE=0; 
        PIR1.ADIF=0;
        new_value=1; // di al programma chè è arrivato un nuovo valore
        
        PIR1.ADIE=1; 
    }
    

}