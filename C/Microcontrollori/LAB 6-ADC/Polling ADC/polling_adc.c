 // misuriamo ADC e buttiamo il risultato sulla porta C (i primi 8 bit più significativi)
void main() {
 //SETTING
   TRISC=0; // C output

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

// CODICE
 ADCON0.ADON=1; // accendo adc
 ADCON0.GO_NOT_DONE=1; // do il go
 
 while (1){

   if (ADCON0.GO_NOT_DONE == 0){ // la conversione è finita
    LATC=ADRESH; // stampa il risultato su port C
    ADCON0.GO_NOT_DONE=1; // riprendi la conversione
   }
 }
}