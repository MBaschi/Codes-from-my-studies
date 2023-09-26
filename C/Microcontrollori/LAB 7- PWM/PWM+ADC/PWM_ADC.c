void main() {
 //PWM
    //spegnere buffer d'uscita della porta che usiamo
     TRISE.RE2 = 1;

     // impostare timer2 connesso a CCP5
     CCPTMRS1.C5TSEL0 = 0;
     CCPTMRS1.C5TSEL1 = 0;

     // impostare periodo del PWM
     PR2=255;

     //imposto Ton
     CCPR5L=128;

     //PWM in CCP5
     CCP5CON.CCP5M3 = 1;
     CCP5CON.CCP5M2 = 1;
     // CCP5CON = 0b00001100;

     //imposto timer2
     T2CON = 0b00000111;

     // accendo CCP5
     TRISE.RE2=0;

//ADC

   TRISA.RA0=1; // C input : valore che l'adc andrà a leggere
   ANSELA.RA0=1; // 

   // impostiamo A come canale del ADC, il codice é 00000
   ADCON0.CHS0= 0;
   ADCON0.CHS1= 0;
   ADCON0.CHS2= 0;
   ADCON0.CHS3= 0;
   ADCON0.CHS4= 0;

   // impostiamo T_AD ad 1us
   // siccome T_AD = Multiplexing/f_osc= Multiplexing/8MHZ -> Multiplexing=8 che equivale a porre il registro
   //ADCON2.ADCS=001
   ADCON2.ADCS0=1;
   ADCON2.ADCS1=0;
   ADCON2.ADCS2=0;

   // impostiamo ACQT
   // ACQT>ACQ=7,45us
   // siccome T_AD=1 us impostiamo ACQT=8ms cioè 8*T_AD che corrissponde a ADCON2.ACQT=100

   ADCON2.ACQT0=0;
   ADCON2.ACQT1=0;
   ADCON2.ACQT2=1;

   // impostiamo giustificazione
   // giustifichiamo a sinistra in modo tale che gli 8 bit più significativi siano nel ADRESH
   ADCON2.ADFM=0;

//INTERRUPT
   // impostiamo interrupt 
   PIE1.ADIE=1; // enable interrupt adc
   PIR1.ADIF=0; // interrupt flag =0
   INTCON.PEIE=1;// enable interrupt periferiche
   INTCON.GIE=1; // eanble interrupt globale
   
    ADCON0.ADON=1; // accendo adc
    ADCON0.GO_NOT_DONE=1; // do il go

     while (1){
           
          
     }

}

void interrupt() {
    INTCON.GIE = 0;
        if (PIR1.ADIF) {
             PIR1.ADIF = 0;
              CCPR5L=ADRESH; 
             ADCON0.GO_NOT_DONE = 1; // do il go
        }
    

    INTCON.GIE = 1;
}