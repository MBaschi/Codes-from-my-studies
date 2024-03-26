
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

//VARIABILI VOLATILI
unsigned short int new_value=0;

void main() {
// VARIABILI
   //per contatore
   unsigned short int conteggio=0;
 
   unsigned short int RD5X=0;
   unsigned short int RD6X=0;
   unsigned short int RD7X=0;

   unsigned short int RD5_old=0;
   unsigned short int RD6_old=0;
   unsigned short int RD7_old=0;

   char conteggio_char[7];
   //per adc
   char adc_res_char[7];
   unsigned int adc_result=0;
   unsigned short int temp; //variabile temporanea per convertire valore adc in mv
   unsigned short int porta_adc=0; //se =0 sto leggendo da RA0 se =1 sto leggendo RE2
   char adc_res_char1[7];
//INIZZIALIZZAZIONE 
  //PORTE 
    TRISD.RD5=1; //incremento
    TRISD.RD6=1; //decremento
    TRISD.RD7=1; //azzeramento
    ANSELD=0; 
    //adc input
    TRISA.RA0=1; 
    ANSELA.RA0=1; 
    TRISD.RD0=1;
    ANSELD.RD0=1; 
    //pwm output
    TRISE.RE2=1;
  
  //LCD
   Lcd_Init(); // inizzializza LCD
   Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
   Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
   Lcd_Out(1,1,conteggio_char);
   Lcd_Out(2,1,adc_res_char);

  //ADC
   //channel:RA0
   ADCON0.CHS0=0;
   ADCON0.CHS1=0;
   ADCON0.CHS2=0;
   ADCON0.CHS3=0;
   ADCON0.CHS4= 0;
   //Tad
   ADCON2.ADCS0=0;
   ADCON2.ADCS0=1;
   ADCON2.ADCS0=0;
   //Tacqt
   ADCON2.ACQT0=0; 
   ADCON2.ACQT0=1; 
   ADCON2.ACQT0=0; 
   //giustifizazione
   ADCON2.ADFM=1;
   //accendere
   ADCON0.ADON=1;
   //reference
   ADCON1.PVCFG0=0;
   ADCON1.PVCFG1=0;

   ADCON1.NVCFG0=0;
   ADCON1.NVCFG1=0;
   
  //PWM
   //seleziona timer
   CCPTMRS1.C5TSEL0=0;
   CCPTMRS1.C5TSEL1=1;
   //periodo pwm
   PR6=255;
   //imposto ccp5 in modalità pwm
   CCP5CON.CCP5M3=1;
   CCP5CON.CCP5M2=1;
   //prescaler di timer 6 non mi interessa
   T6CON = 0b00000111;
   //accendo buffer d'uscita
   TRISE.RE2=0;
  //INTERRUPT
    PIE1.ADIE=1; //ADC interrupt enable
    PIR1.ADIF=0; //ADC interrupt flag
    INTCON.PEIE=1;// enable interrupt periferiche
    INTCON.GIE=1; // global interrupt enable

    

//PROGRAMMA
  
  ADCON0.GO_NOT_DONE=1; //faccio partire adc
  
  while (1){
    //POLLING PORT D
     RD5X=PORTD.RD5;
     RD6X=PORTD.RD6;
     RD7X=PORTD.RD7;

     if(RD5X && RD5X!=RD5_old && conteggio<255 ){ // aumenta conteggio, NOTA non ho scritto if(PORTD.RD5 && PORTD.RD5!=RD5_old ) perchè avrei letto la porta 2 volte
       conteggio+=1;
     }
     
     if(RD6X && RD6X!=RD6_old && conteggio>0 ){ // diminuisci conteggio
       conteggio-=1;
     }

     if(RD7X && RD7X!=RD7_old ){ // azzera conteggio
       conteggio=0;
     }
    
     RD5_old=RD5X;
     RD6_old=RD6X;
     RD7_old=RD7X;
     //GESTIONE ADC
     if (new_value==1 && porta_adc==0){ // sto ricevendo il dato da AD0
          //converto
          temp =ADRESH;
          temp<<6;
          adc_result=ADRESL;
          adc_result=(ADRESL+temp*4)*5;
          new_value=0;
          //cambio canale
          ADCON0.CHS0=0;
          ADCON0.CHS1=0;
          ADCON0.CHS2=1;
          ADCON0.CHS3=0;
          ADCON0.CHS4= 1;
          porta_adc=1;
          new_value=0;
     }
     else{ // dato da RD0
          //setto pwm
          CCPR5L=ADRESH;
          //cambio canale
          ADCON0.CHS0=0;
          ADCON0.CHS1=0;
          ADCON0.CHS2=0;
          ADCON0.CHS3=0;
          ADCON0.CHS4= 0;
          porta_adc=0;
          new_value=0;
          IntToStr(ADRESL,adc_res_char1); //adc
          Lcd_Out(2,6,adc_res_char1);
     }
    //STAMPA
    IntToStr(conteggio,conteggio_char); //conteggio
    Lcd_Out(1,1,conteggio_char);

    IntToStr(adc_result,adc_res_char); //adc
    Lcd_Out(2,1,adc_res_char);
  }
}

void interrupt(){
      if (PIR1.ADIF){
          new_value=1;
          PIR1.ADIF=0;
          ADCON0.GO_NOT_DONE=1;
      }

}