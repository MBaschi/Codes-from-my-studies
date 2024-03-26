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

unsigned short int vu_meter(unsigned short int vel);

unsigned short int clk;
void main() {
//VARIABILI
      unsigned short int stato_accensione=0;
      unsigned short int RC0_new;
      unsigned short int RC0_old;
      unsigned short int RC3_new;
      unsigned short int RC3_old;
      unsigned short int RC4_new;
      unsigned short int RC4_old;
      unsigned short int velocita_motore=1;
      unsigned short int vel_change=0; //se =1 la velocità è stata modificata
      unsigned short int vel;
      unsigned short int duty_cycle;
      unsigned short int T; //temperatura
        int V;//volt adc
      char velocita_motore_char[7];
      
     
    //PORTE
       //porta C pin 0,3,4 input
         TRISC=0b00011001;
         ANSELC=0b11100110;
       //porta A pin 4 output
        TRISA.RA4=0;
        ANSELA.RA4=1;
       // porta D tutti i pin output
        TRISD=0;
        ANSELD=255;
        LATD=1;
    //LCD
     Lcd_init();
     Lcd_cmd(_LCD_CLEAR);
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Out(1,1,"SPENTO");

    //PWM
       //porta E inizialmente in input
        TRISE.RE2=1;
        ANSELE.RE2=0;
       //seleziona timer
        CCPTMRS1=0; //timer 2
       //imposto T
        PR2=255;
       //configura CCP5 come pwm
       CCP5CON.CCP5M3=1;
       CCP5CON.CCP5M2=1;
       //imposta il duty cycle
       CCPR5L=0;
      // imposta timer
       T2CON=0b00000111;
      //accendo buffer d'uscita
       TRISE.RE2=0;

    //ADC
      //port configuration
      TRISA.RA0=1;
      ANSELA.RA0=0;    
      ADCON2=00100001;//giustificazione a destra
      ADCON0=00000001;
    
    //TIMER 0
       T0CON=11000110; //PRS=128-> overflow time =(4/fosc)*256*PRS=32 ms
    //INTERRUPT
       INTCON=10100000;
      
     ADCON0.GO_NOT_DONE=1;
//PROGRAMMA
    while (1){
        //SEZIONE A
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
        
        //SEZIONE B
        if (stato_accensione==1){

            RC3_new=PORTC.RC3;
            RC4_new=PORTC.RC4;
            
            if (RC3_new==1 && RC3_new!=RC3_old && velocita_motore<8){ //acccendi motore
               velocita_motore+=1;
               vel_change=1;
               LATD=LATD+2^(velocita_motore);
            }

            if (RC4_new==1 && RC4_new!=RC4_old && velocita_motore>0){ //spegni motore
               velocita_motore-=1;
               vel_change=1;
               LATD=LATD-2^(velocita_motore);
            }
                  RC3_old=RC3_new;
                  RC4_old=RC4_new;

             IntToStr(velocita_motore,velocita_motore_char);
             Lcd_Out(2,1,velocita_motore_char);
             IntToStr(LATD,velocita_motore_char);
             Lcd_Out(2,5,velocita_motore_char);
                        
            if (vel_change==1){
                                     
                //pwm           
                CCPR5L=PR2*velocita_motore/8;
                vel_change=0;
            }
            
            if (clk>1000){
                clk=0;
                V=ADRESH*5*4;//=ADRES*5000/1024 *4
            }

                    
        }  



    }
}

void interrupt(){
    if (INTCON.TMR0IF){
        INTCON.TMR0IE=0;
        clk+=32//ms
        INTCON.TMR0IF=0;
        INTCON.TMR0IE=1;
    }
}
unsigned short int vu_meter(unsigned short int vel){
    //ogni unità di velocita_motore equivale a una potenza di 2 da sommare al registro latd es velocita_motore=3 implica latd=0000 0111= 2^0+2^1+2^2
    unsigned short int latd=0;
    int i;
    // siccome nel while non posso inserire la condizione vel>=0 per chè loopa al infinito a causa del overflow ho dovuto mettere un offset   
     for (i=0;i++;i<vel){
            latd=latd+2^(i);             
           }   
    return latd;
}
//2.24