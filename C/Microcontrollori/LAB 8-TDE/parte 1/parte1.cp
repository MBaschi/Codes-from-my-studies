#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 8-TDE/parte 1/parte1.c"

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


void main() {

 unsigned short int conteggio=0;

 unsigned short int RD5X=0;
 unsigned short int RD6X=0;
 unsigned short int RD7X=0;

 unsigned short int RD5_old=0;
 unsigned short int RD6_old=0;
 unsigned short int RD7_old=0;

 char conteggio_char [7];


 TRISD.RD5=1;
 TRISD.RD6=1;
 TRISD.RD7=1;
 ANSELD=0;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,conteggio_char);




 while (1){

 RD5X=PORTD.RD5;
 RD6X=PORTD.RD6;
 RD7X=PORTD.RD7;

 if(RD5X && RD5X!=RD5_old && conteggio<255 ){
 conteggio+=1;
 }

 if(RD6X && RD6X!=RD6_old && conteggio>0 ){
 conteggio-=1;
 }

 if(RD7X && RD7X!=RD7_old ){
 conteggio=0;
 }

 RD5_old=RD5X;
 RD6_old=RD6X;
 RD7_old=RD7X;

 IntToStr(conteggio,conteggio_char);
 Lcd_Out(1,1,conteggio_char);
 }
}
