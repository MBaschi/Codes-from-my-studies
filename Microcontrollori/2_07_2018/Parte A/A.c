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

void main() {
//INIZZIALIZZAZIONE    
    //VARIABILI
    unsigned short int timer_value=30;
    char timer_value_char[7];
        
    //PORTE
    TRISD=0;
    ANSELD=255;

    TRISE.RE2=0;
    ANSELE.RE2=1;

    LATE.RE2=0;
    LATD=timer_value;

    //LCD
    Lcd_Init();
    Lcd_cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);


    
    //TIMER
    T0CON=0b11000111;  
    TMR0L=217;
    //INTERRUPT
    INTCON=0b11100000; //T_overflow=(4/fosc)*(256-TMR0L)*PSA, siccome è richiesta una precisione del 5%
                      // cioè 50 ms basta scegliere un overflow minore di 50ms e sicuramente avrò un passo minore della precisione
                     // con queste impostazioni TMR0L=4,99 ms

//PROGRAMMA
    
    //CONTO ALLA ROVESCIA
       //CON DELAY_MS
       /*for(timer_value;timer_value-=1;timer_value>=0){
           delay_ms(1000);
           LATD=timer_value;
       }
       LATD=timer_value; //per stampare il valore 0
       LATE.RE2=1;*/
       
      while(timer_value>=0){
             
             if (counter>100){
                 
                 IntToStr(timer_value,timer_value_char);
                 Lcd_Out(1,1,timer_value_char);
                 timer_value-=1;
                 LATD=timer_value;
                 counter=0;
                 LATE.RE2=1;
                
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
}