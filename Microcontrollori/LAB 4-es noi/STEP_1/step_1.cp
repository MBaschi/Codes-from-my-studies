#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 4-es noi/STEP_1/step_1.c"


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


int counter_1=0;
int counter_2=0;

void main() {



 unsigned short int dx=0b00000001;
 unsigned short int sx=0b10000000;
 unsigned short int dir=0;
 unsigned short int D=0;
 int delay_kitt=500;
 unsigned short int cron_val=0;
 char cron_char[7];


 TRISD=0;
 PORTD=0x00000000;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 T0CON=0b11000111;
 TMR0L=0x3D;
 INTCON=0b10100000;


 while (1){

 if(counter_1>delay_kitt) {
 if (dir==0){
 D=D+dx+sx;
 dx<<=1;
 sx>>=1;
 }
 else {
 dx>>=1;
 sx<<=1;
 D=D-dx-sx;
 }

 if (D==0b11111111){
 dir=1;
 }
 if (D==0b00000000){
 dir=0;
 }
 PORTD=D;
 counter_1=0;
 }

 if (counter_2>1000){
 counter_2=0;
 cron_val+=1;
 IntToStr(cron_val,cron_char);
 Lcd_Out(1,1,cron_char);

 }

 }

 }

void interrupt(){
 INTCON.GIE=0;
 if (INTCON.TMR0IF){
 INTCON.TMR0IF=0;
 counter_1+=25;
 counter_2+=25;
 }
 INTCON.GIE=1;
}
