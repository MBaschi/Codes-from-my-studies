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


int clk=0;

unsigned short int abs(int x){
    if (x>=0){
      return x;
    }
  else {
   return -x;
   }

}

void main() {
//INIZZIALIZZAZIONE
    //VARIABILI
       unsigned short int stato_accensione=0;
       unsigned short int RC0_VAL=0;
       unsigned short int RC0_OLD=0;
       unsigned short int setpoint_temperatura=25;
       unsigned short int RC3_VAL=0;
       unsigned short int RC3_OLD=0;
       unsigned short int RC4_VAL=0;
       unsigned short int RC4_OLD=0;

        int adc_res_V=0; //risulato del adc in volt
        unsigned short int T; //temperatura
        unsigned short int delta_T;
        unsigned short int sigma;
        char T_char[7];
        char setpoint_temperatura_char[7];
        char delta_T_char[7];
    

    //PORTE
      TRISC.RC0=1;  //pulsante di accensione
      ANSELC.RC0=0;
    
      
    
      TRISC.RC3=1;   // aumenta temperatura
      ANSELC.RC3=0;
      TRISC.RC4=1;   // diminuisci temperatura
      ANSELC.RC4=0;
    //LCD
      Lcd_Init();
      Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
      Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
      Lcd_out(1,1,"SPENTO"); 

    //ADC
      //porta a
        TRISA.RA0=1;
        ANSELA.RA0=1;
      //channel selection
         ADCON0.CHS0= 0;
         ADCON0.CHS1= 0;
         ADCON0.CHS2= 0;
         ADCON0.CHS3= 0;
         ADCON0.CHS4= 0;
      //acquisition time: basta che sia maggiore di 7,45 us 
        //Tad=n/fosc=n/16 MHz mettiamo n=16 in modo da avere Tad=1us
           ADCON2.ADCS0=1;
           ADCON2.ADCS1=0;
           ADCON2.ADCS2=0;
        //Tacqt lo pongo uguale a 8 us
         ADCON2.ACQT0=0;
         ADCON2.ACQT1=0;
         ADCON2.ACQT2=1;
      // giustificazione
        ADCON2.ADFM=0; // a sinistra perchè usiamo gli 8 but più significativi
      //accendere adc
        ADCON2.ADON=1;
    
    //PWM
      TRISE.RE2=1;   // controllo motore :CCP5
      ANSELE.RE2=1;  // è necessaria alta impedenza in ingresso per pilotare il motore quindi spengo buffer d'ingresso
      //select timer con CCPTMRSx
      CCPTMRS1=0; //timer 2
      T2CON = 0b00000111;
      //seleziona PRx
      PR2=255;
      //configuare ccpx come pwm con CCPxCON
      CCP5CON.CCP5M3=1;
      CCP5CON.CCP5M2=1;
      // caricre CCPRLx e DCxB in CCPxCON
      CCPR5L=0; //cominciamo con motore spento 
      //abilitare porta d'uscita
      TRISE.RE2=0;

// CODICE
 ADCON0.ADON=1; // accendo adc
       
    //TIMER0
       //tempro per overflow = (4/fosc)*PRS*256*=0,5*256*PRS=64*PRS us; sclego PRS=16 così ho overflow ogni 1 ms
         T0CON=0b11000011;
         INTCON.TMR0IE=1;
         INTCON.TMR0IF=0;
         INTCON.GIE=1;
     //INTERRUPT 
       //metto solo un interrupt sul timer0 per far partire l'adc ogni secondo
       
      // INTCON=0b10100000;
      


     
    

//PROGRAMMA
    ADCON0.GO_NOT_DONE=1; //faccio partire la prima conversione del ADC
    while(1){
        //A.1)verifica accensione
        RC0_VAL=PORTC.RC0;

        if (RC0_VAL!=RC0_OLD && RC0_VAL==1){ // notare che entro solo quando il valore cambio quindi come da richiesta LCD è aggiornato solo quanod è necessario
          
           stato_accensione=!stato_accensione;

           //A.2 e A.3)pilota motore e stampa
           if (stato_accensione==1){
            
            
            Lcd_cmd(_LCD_CLEAR);
            Lcd_out(1,1,"ACCESO"); 

           }
          else{
            
            Lcd_cmd(_LCD_CLEAR);
            Lcd_out(1,1,"SPENTO"); 
          }
        }
        RC0_OLD=RC0_VAL; 
      
      //SEZIONE B
       if (stato_accensione==1){
          //B1)
           RC3_VAL=PORTC.RC3;
           RC4_VAL=PORTC.RC4;
           if(RC3_VAL!=RC3_OLD && RC3_VAL==1 && setpoint_temperatura<50 ){ //aumenta
            setpoint_temperatura+=1;
           }
        
           if(RC4_VAL!=RC4_OLD && RC4_VAL==1 && setpoint_temperatura>10 ){ //diminuisce
            setpoint_temperatura-=1;
           }
           RC3_OLD=RC3_VAL;   
           RC4_OLD=RC4_VAL;  

             
             
          //B2)
          if(clk>1000){
            //LEGGO E CONVERTO RISULTATO ADC
             // V=(T-10)*1/8 -> T=V*8+10 (quindi adndiamo da 10 gradi a 50)
             clk=0;
             ADCON0.GO_NOT_DONE=1;
             adc_res_V=ADRESH;
             adc_res_V=adc_res_V*4*5/1000;
             T=adc_res_V*8+10;

             //C)
            delta_T=abs(T-setpoint_temperatura);
             if (delta_T<1){
                 CCPR5L=0;
                 CCP5CON.DC5B0=0;
                 CCP5CON.DC5B1=0;
             }
             else if(1<=delta_T<=4) {
                 sigma=33*delta_T-33;
                 //siccome sigma=(CCPxl:DCB)/(4*(PRx+1))
                 CCPR5L=(PR2+1)*sigma/100; //sarebbe 4(PR2+1)*sigma/4 perchè considero solo i bit più significativi ma ovvimanete il 4 si semplifica
                 
             }
             else {
                CCPR5L=255;
                CCP5CON.DC5B0=1;
                CCP5CON.DC5B1=1;
             }
             
          }
         //B4)
             IntToStr(setpoint_temperatura,setpoint_temperatura_char);
             Lcd_out(2,4,setpoint_temperatura_char);
             IntToStr(T,T_char);
             Lcd_out(2,1,T_char);
             IntToStr(delta_T,delta_T_char);
             Lcd_out(2,7,delta_T_char);   

        //SEZIONE C
                     
       }

    }
}
//2 ore

void interrupt(){
  INTCON.GIE=0;
  if (INTCON.TMR0IF){     
     INTCON.TMR0IF=0;
     clk+=1;//ms   
    }
  INTCON.GIE=1;
}

//DOMANDE: COME STAMPARE CON PRECISIONE DECIMALE
//         COME 