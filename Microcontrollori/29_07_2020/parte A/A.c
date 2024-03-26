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
//VARIABILI
      unsigned short int stato_accensione=0;
      unsigned short int RC0_new;
      unsigned short int RC0_old;
      unsigned short int RC3_new;
      unsigned short int RC3_old;
      unsigned short int RC4_new;
      unsigned short int RC4_old;
    //PORTE
       //porta C pin 0,3,4 input
         TRISC=0b00011001;
         ANSELC=0b11100110;
       //porta E pin 2 output
        TRISE.RE2=0;
        ANSELE.RE2=1;
       //porta A pin 4 output
        TRISA.RA4=0;
        ANSELA.RA4=1;
    //LCD
     Lcd_init();
     Lcd_cmd(_LCD_CLEAR);
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Out(1,1,"SPENTO");

//PROGRAMMA
    while (1){
        RC0_new=PORTC.RC0;

        if(RC0_new==1 && RC0_new!=RC0_old){  //ACCENSIONE
            stato_accensione=!stato_accensione; //cambia stato
            
            
            if (stato_accensione==0){  
                 Lcd_cmd(_LCD_CLEAR);
                 Lcd_Out(1,1,"SPENTO"); //comunica stato
                 LATE.RE2=0; //spegni motore
                 LATA.RA4=0; //spegni led
            }

            if (stato_accensione==1){
                 Lcd_cmd(_LCD_CLEAR);
                 Lcd_Out(1,1,"ACCESO");//comunica stato
                 LATE.RE2=1;   //accendi motore
                 LATA.RA4=1;   //accendi led
            }
        }

        RC0_old=RC0_new; //salvo vecchio valore per vedere se cambia   

    }
}