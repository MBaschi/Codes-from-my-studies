#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/29_07_2020/parte A/A.c"

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

 unsigned short int stato_accensione=0;
 unsigned short int RC0_new;
 unsigned short int RC0_old;
 unsigned short int RC3_new;
 unsigned short int RC3_old;
 unsigned short int RC4_new;
 unsigned short int RC4_old;


 TRISC=0b00011001;
 ANSELC=0b11100110;

 TRISE.RE2=0;
 ANSELE.RE2=1;

 TRISA.RA4=0;
 ANSELA.RA4=1;

 Lcd_init();
 Lcd_cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"SPENTO");


 while (1){
 RC0_new=PORTC.RC0;

 if(RC0_new==1 && RC0_new!=RC0_old){
 stato_accensione=!stato_accensione;


 if (stato_accensione==0){
 Lcd_cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"SPENTO");
 LATE.RE2=0;
 LATA.RA4=0;
 }

 if (stato_accensione==1){
 Lcd_cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"ACCESO");
 LATE.RE2=1;
 LATA.RA4=1;
 }
 }

 RC0_old=RC0_new;

 }
}
