#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/27_07_2018/ParteC/C.c"

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

 int tmr0_overflof=0;
unsigned short int clk_pwm=0;
void main() {


 unsigned short int RA0_NEW=0;
 unsigned short int RA0_OLD=0;
 unsigned short int RA1_NEW=0;

 unsigned short int stato_accensione=0;
 unsigned short int potenza_motore=0;
 unsigned short int potenza_motore_percent=0;
 char potenza_motore_char[8];
 unsigned short int potenza_motore_anteriore=0;


 TRISA=0b00000111;
 ANSELA=0b11111000;

 TRISE=0b00000100;
 LATE=0;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_out(1,1,"VEICOLO SPENTO");

 CCPTMRS1.C5TSEL0=0;
 CCPTMRS1.C5TSEL1=1;

 PR6=255;

 CCP5CON.CCP5M3=1;
 CCP5CON.CCP5M2=1;

 CCPR5L=0;

 T6CON.TMR6ON=1;

 TRISE.RE2=0;

 T0CON=0b11001000;
 TMR0L=255;

 INTCON=0b10100000;


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

 if (PORTA.RA1 && tmr0_overflof>20000){
 potenza_motore+=1;
 tmr0_overflof=0;
 CCPR5L=potenza_motore;
 }
 if (PORTA.RA2 && tmr0_overflof>20000){
 potenza_motore-=1;
 tmr0_overflof=0;
 CCPR5L=potenza_motore;
 }
 potenza_motore_percent=potenza_motore*0.39;

 IntToStr(potenza_motore_percent,potenza_motore_char);
 Lcd_Out(2,1,"MOTORE:");
 Lcd_Out(2,5,potenza_motore_char);
 Lcd_Out(2,11,"%");


 potenza_motore_anteriore=potenza_motore;
 potenza_motore_anteriore>>1;

 if (clk_pwm < potenza_motore_anteriore){
 LATE.RE1=1;
 }

 if(clk_pwm> potenza_motore_anteriore && clk_pwm<256){
 LATE.RE1=0;
 }
 else {
 clk_pwm=0;
 }

 }

 }
 }

void interrupt(){
 if (INTCON.TMR0IF){
 INTCON.TMR0IE=0;
 tmr0_overflof+=128;
 clk_pwm+=1;
 INTCON.TMR0IF=0;
 INTCON.TMR0IE=1;

 }
}
