#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/27_07_2018/ParteA/A.c"

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


 unsigned short int RA0_NEW=0;
 unsigned short int RA0_OLD=0;
 unsigned short int RA1_NEW=0;
 unsigned short int RA1_OLD=0;
 unsigned short int RA2_NEW=0;
 unsigned short int RA2_OLD=0;

 unsigned short int stato_accensione;

 TRISA=0b00000111;
 ANSELA=0b11111000;

 TRISE=0;
 LATE=0;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_out(1,1,"VEICOLO SPENTO");


 while(1){

 RA0_NEW=PORTA.RA0;

 if (RA0_NEW && RA0_NEW!=RA0_OLD){
 stato_accensione=!stato_accensione;
 if (stato_accensione==1){
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_out(1,1,"VEICOLO ACCESO");
 LATE.RE0=1;
 }
 else{
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_out(1,1,"VEICOLO SPENTO");
 LATE.RE0=0;
 }
 }
 RA0_OLD=RA0_NEW;


 if (stato_accensione==1){
 RA1_NEW=PORTA.RA1;
 RA2_NEW=PORTA.RA2;

 if (RA1_NEW && RA1_NEW!=RA1_OLD){
 LATE.RE2=1;
 }
 if (RA2_NEW && RA2_NEW!=RA2_OLD){
 LATE.RE2=0;
 }
 RA1_OLD=RA1_NEW;
 RA2_OLD=RA2_NEW;
 }

 }
 }
