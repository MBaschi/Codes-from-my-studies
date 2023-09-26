#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 4-es noi/STEP_4/step_4.c"



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

 int delay_kitt=500;
 int delay_kitt_max=1500;
 int delay_kitt_min=100;

 char cron_char[7];
 unsigned short int cron_condition=0;


 unsigned short int A[4]={0};
 unsigned short int A_old[4]={0};
 unsigned short int C=0;
 unsigned short int C_old=0;

 unsigned short int h=0;
 unsigned short int m=0;
 unsigned short int s=0;
 unsigned short int ms=0;
 char h_char[7];
 char m_char[7];
 char s_char[7];
 char ms_char[7];
 char tot_char[3];
 strcpy(tot_char,"-");


 TRISD=0;
 LATD=0x00000000;

 TRISA=0b00011111;
 ANSELA=0b11100000;

 TRISC=0b00011111;
 ANSELC=0b11111110;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"0:0:0:0");

 T0CON=0b11000111;
 TMR0L=0x3D;
 INTCON=0b10100000;


 while (1){

 if(counter_1>delay_kitt) {
 if (dir==0){
 LATD=LATD+dx+sx;
 dx<<=1;
 sx>>=1;
 }
 else {
 dx>>=1;
 sx<<=1;
 LATD=LATD-dx-sx;
 }

 if (LATD==0b11111111){
 dir=1;
 }
 if (LATD==0b00000000){
 dir=0;
 }

 counter_1=0;
 }

 if (counter_2>1000 && cron_condition==1 ){
 counter_2=0;
 s+=1;

 if (s==60){
 s=0;
 m+=1;
 if (m==60){
 m=0;
 h+=1;
 }
 }
 Lcd_Cmd(_LCD_CLEAR);
 IntToStr(s,s_char);
 IntToStr(m,m_char);
 IntToStr(h,h_char);
 IntToStr(ms,ms_char);

 strcat(tot_char,s_char);
 Lcd_Out(1,1,tot_char);

 }

 A[0]=PORTA.RA0;
 A[1]=PORTA.RA1;
 A[2]=PORTA.RA2;
 A[3]=PORTA.RA3;
 A[4]=PORTA.RA4;

 if (A[0]&& A_old[0]!=A[0]){
 cron_condition=1;
 }
 if (A[1]&& A_old[1]!=A[1]){
 cron_condition=0;
 }
 if (A[2]&& A_old[2]!=A[2]){
 s=0;
 m=0;
 h=0;
 ms=0;
 Lcd_Out(1,1,"0:0:0:0");
 }
 if (A[3] && A_old[3]!=A[3] && delay_kitt<delay_kitt_max){
 delay_kitt+=50;
 }
 if (A[4] && A_old[4]!=A[4] && delay_kitt>delay_kitt_min){
 delay_kitt-=50;
 }
 A_old[0]=A[0];
 A_old[1]=A[1];
 A_old[2]=A[2];
 A_old[3]=A[3];
 A_old[4]=A[4];

 C=PORTC.RC0;
 if (C && C_old!=C){

 IntToStr(s,s_char);
 IntToStr(m,m_char);
 IntToStr(h,h_char);
 IntToStr(ms,ms_char);

 strcat(tot_char,ms_char);
 strcat(tot_char,":");
 strcat(tot_char,s_char);
 strcat(tot_char,":");
 strcat(tot_char,m_char);
 strcat(tot_char,":");
 strcat(tot_char,h_char);
 Lcd_Out(1,1,tot_char);
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
