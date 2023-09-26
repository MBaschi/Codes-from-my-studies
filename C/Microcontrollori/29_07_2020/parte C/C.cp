#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/29_07_2020/parte C/C.c"

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


unsigned short int vu_meter(unsigned short int vel);

unsigned short int clk;
void main() {

 unsigned short int stato_accensione=0;
 unsigned short int RC0_new;
 unsigned short int RC0_old;
 unsigned short int RC3_new;
 unsigned short int RC3_old;
 unsigned short int RC4_new;
 unsigned short int RC4_old;
 unsigned short int velocita_motore=1;
 unsigned short int vel_change=0;
 unsigned short int vel;
 unsigned short int duty_cycle;
 unsigned short int T;
 int V;
 char velocita_motore_char[7];




 TRISC=0b00011001;
 ANSELC=0b11100110;

 TRISA.RA4=0;
 ANSELA.RA4=1;

 TRISD=0;
 ANSELD=255;
 LATD=1;

 Lcd_init();
 Lcd_cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"SPENTO");



 TRISE.RE2=1;
 ANSELE.RE2=0;

 CCPTMRS1=0;

 PR2=255;

 CCP5CON.CCP5M3=1;
 CCP5CON.CCP5M2=1;

 CCPR5L=0;

 T2CON=0b00000111;

 TRISE.RE2=0;



 TRISA.RA0=1;
 ANSELA.RA0=0;
 ADCON2=00100001;
 ADCON0=00000001;


 T0CON=11000110;

 INTCON=10100000;

 ADCON0.GO_NOT_DONE=1;

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


 if (stato_accensione==1){

 RC3_new=PORTC.RC3;
 RC4_new=PORTC.RC4;

 if (RC3_new==1 && RC3_new!=RC3_old && velocita_motore<8){
 velocita_motore+=1;
 vel_change=1;
 LATD=LATD+2^(velocita_motore);
 }

 if (RC4_new==1 && RC4_new!=RC4_old && velocita_motore>0){
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


 CCPR5L=PR2*velocita_motore/8;
 vel_change=0;
 }

 if (clk>1000){
 clk=0;
 V=ADRESH*5*4;
 }


 }



 }
}

void interrupt(){
 if (INTCON.TMR0IF){
 INTCON.TMR0IE=0;
 clk+=32
 INTCON.TMR0IF=0;
 INTCON.TMR0IE=1;
 }
}
unsigned short int vu_meter(unsigned short int vel){

 unsigned short int latd=0;
 int i;

 for (i=0;i++;i<vel){
 latd=latd+2^(i);
 }
 return latd;
}
