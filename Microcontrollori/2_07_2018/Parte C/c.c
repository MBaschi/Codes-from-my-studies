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

 int counter; //per il timer
 unsigned short int new_val_adc=0;

void main() {
//INIZZIALIZZAZIONE    
    //VARIABILI
    unsigned short int timer_value=30;
    char timer_value_char[7];
    unsigned short int timer_init_value=30;

    unsigned short int RA0_NEW;
    unsigned short int RA0_OLD;

    unsigned short int RA1_NEW;
    unsigned short int RA1_OLD;

    unsigned short int RA2_NEW;
    unsigned short int RA2_OLD;

    unsigned short int RA3_NEW;
    unsigned short int RA3_OLD;

    unsigned short int go=1;
    int val_adc; 
     
    //PORTE
    TRISD=0;
    ANSELD=255;
    

    TRISE.RE2=0;
    ANSELE.RE2=1;
    LATE.RE2=0;
    
    TRISA=0b00001111;
    ANSELA=0b11110000;
    //LCD
    Lcd_Init();
    Lcd_cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    //ADC:uso RA5=AN4
      ADCON0=00010001;
      ADCON2=10100001; //left justified, TAD=8*(8/fosc)=8us>7,45us ho cercato di avvicinarmi il più possibile al tempo minimo di conversione viste la necessità di essere particolarmente reattivi
      TRISA.RA5=1;
      //siccome il sensore ad ultrasuoni poera tra 2.5V e 5V sarebbe stato ottimale cambiare la tensione di riferivemnto VREF- ma RA2 è gia occupato
    //TIMER
    T0CON=0b11000111;  
    TMR0L=217;

    //INTERRUPT
    INTCON=0b11100000; //T_overflow=(4/fosc)*(256-TMR0L)*PSA, siccome è richiesta una precisione del 5%
                       // cioè 50 ms basta scegliere un overflow minore di 50ms e sicuramente avrò un passo minore della precisione
                       // con queste impostazioni TMR0L=4,99 ms
    PIE1.ADIE=1;
    PIR1.ADIF=0;
//PROGRAMMA
    ADCON0.GO_NOT_DONE=1;
    //MODIFICA VALORE INIZIALE TIMER
       while (PORTA.RA0==0){ // quando premo start non posso più cambiare il valore iniziale del cronometro
           
           RA2_NEW=PORTA.RA2;
           RA3_NEW=PORTA.RA3;

           if (RA2_NEW && RA2_NEW!=RA2_OLD){
              timer_init_value+=5;
           }

           if (RA3_NEW && RA3_NEW!=RA3_OLD){
               timer_init_value-=5;
           }
           
           timer_value=timer_init_value;
           IntToStr(timer_value,timer_value_char);
           Lcd_Out(1,1,timer_value_char);

           RA2_OLD=RA2_NEW;
           RA3_OLD=RA3_NEW;
       }
    LATD=timer_value;
    //CONTO ALLA ROVESCIA
       //CON DELAY_MS
       /*for(timer_value;timer_value-=1;timer_value>=0){
           delay_ms(1000);
           LATD=timer_value;
       }
       LATD=timer_value; //per stampare il valore 0
       LATE.RE2=1;*/
       
      while(timer_value>=0){
           
           RA0_NEW=PORTA.RA0;
           RA1_NEW=PORTA.RA1;

           if (RA0_NEW && RA0_NEW!=RA0_OLD){
              go=1;
              INTCON.TMR0IE=1; //il valore di clock può essere aggiornato

           }

           if (RA1_NEW && RA1_NEW!=RA1_OLD){
               go=0;
               INTCON.TMR0IE=0; //il valore di clock non deve essere aggiornato
           }

           RA0_OLD=RA2_NEW;
           RA3_OLD=RA3_NEW;
            
             
             if (counter>100 && go){
                 
                 IntToStr(timer_value,timer_value_char);
                 Lcd_Out(1,1,timer_value_char);
                 timer_value-=1;
                 LATD=timer_value;
                 counter=0;
                 LATE.RE2=1;
                
             }

             //VERIFICA PRESENZA DI OGGETTI
             if(new_val_adc){
                val_adc=ADRESH*4+ADRESL/64;
               //devo convertilo in metri: il sensore ha una dinamica da 2.5V a 5.5V, la distanza minima è di 15,24cm e quella massima 6,45
               //quindi (5.5-2.5)/(6.45-0.1524)=0.4764 V/m, perciò 1000mm=1m equivale a 2.5+0.4764*1=2.976V
               //l'adc ha una risoluzione di 5V/1024 =0.0049V quindi val_adc*0.0049 =distanza in metri, quindi
                 
              if (val_adc*5>2976 && timer_value<timer_init_value-1){ // ho dovuto inserire la seconda condizione perchè le prime letture del adc mi davano un valore alto che non corrispondeva a quello reale ed entrava subito nel if
                   Lcd_Out(2,1,"ABORTED");
                   go=0;
                }
                
             }
             
         }
         
         
      
      }
      


void interrupt(){
    if (INTCON.TMR0IF){
 
        INTCON.TMR0IE=0;
        counter+=5; //ms
        
        INTCON.TMR0IE=1;
        INTCON.TMR0IF=0;
    }

    if (PIR1.ADIF){
        PIR1.ADIE=0;
        new_val_adc=1;
        ADCON0.GO_NOT_DONE=1;
        PIR1.ADIF=1;
        PIR1.ADIE=0;       
    }
}

//2 ORE E 20