#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/2_07_2018/Parte A/A.c"

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


 TRISD=0;
 ANSELD=255;

 TRISE.RE2=0;
 ANSELE.RE2=1;

 LATE.RE2=0;
 LATD=timer_value;


 Lcd_Init();
 Lcd_cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);




 T0CON=0b11000111;
 TMR0L=217;

 INTCON=0b11100000;
#line 61 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/2_07_2018/Parte A/A.c"
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
 counter+=5;

 INTCON.TMR0IE=1;
 INTCON.TMR0IF=0;
 }
}
