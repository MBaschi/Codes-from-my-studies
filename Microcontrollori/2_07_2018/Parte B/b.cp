#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/2_07_2018/Parte B/b.c"

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


 int counter;

void main() {


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


 TRISD=0;
 ANSELD=255;


 TRISE.RE2=0;
 ANSELE.RE2=1;
 LATE.RE2=0;

 TRISA=0b00001111;
 ANSELA=0b11110000;

 Lcd_Init();
 Lcd_cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);




 T0CON=0b11000111;
 TMR0L=217;

 INTCON=0b11100000;





 while (PORTA.RA0==0){

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
#line 98 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/2_07_2018/Parte B/b.c"
 while(timer_value>=0){

 RA0_NEW=PORTA.RA0;
 RA1_NEW=PORTA.RA1;

 if (RA0_NEW && RA0_NEW!=RA0_OLD){
 go=1;
 INTCON.TMR0IE=1;
 }

 if (RA1_NEW && RA1_NEW!=RA1_OLD){
 go=0;
 INTCON.TMR0IE=0;
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

 }



 }



void interrupt(){
 if (INTCON.TMR0IF){

 INTCON.TMR0IE=0;
 counter+=5;

 INTCON.TMR0IE=1;
 INTCON.TMR0IF=0;
 }
}
