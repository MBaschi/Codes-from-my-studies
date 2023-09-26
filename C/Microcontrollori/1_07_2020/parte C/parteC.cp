#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/1_07_2020/parte C/parteC.c"


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



int clk=0;

unsigned short int abs(int x){
 if (x>=0){
 return x;
 }
 else {
 return -x;
 }

}

void main() {


 unsigned short int stato_accensione=0;
 unsigned short int RC0_VAL=0;
 unsigned short int RC0_OLD=0;
 unsigned short int setpoint_temperatura=25;
 unsigned short int RC3_VAL=0;
 unsigned short int RC3_OLD=0;
 unsigned short int RC4_VAL=0;
 unsigned short int RC4_OLD=0;

 int adc_res_V=0;
 unsigned short int T;
 unsigned short int delta_T;
 unsigned short int sigma;
 char T_char[7];
 char setpoint_temperatura_char[7];
 char delta_T_char[7];



 TRISC.RC0=1;
 ANSELC.RC0=0;



 TRISC.RC3=1;
 ANSELC.RC3=0;
 TRISC.RC4=1;
 ANSELC.RC4=0;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_out(1,1,"SPENTO");



 TRISA.RA0=1;
 ANSELA.RA0=1;

 ADCON0.CHS0= 0;
 ADCON0.CHS1= 0;
 ADCON0.CHS2= 0;
 ADCON0.CHS3= 0;
 ADCON0.CHS4= 0;


 ADCON2.ADCS0=1;
 ADCON2.ADCS1=0;
 ADCON2.ADCS2=0;

 ADCON2.ACQT0=0;
 ADCON2.ACQT1=0;
 ADCON2.ACQT2=1;

 ADCON2.ADFM=0;

 ADCON2.ADON=1;


 TRISE.RE2=1;
 ANSELE.RE2=1;

 CCPTMRS1=0;
 T2CON = 0b00000111;

 PR2=255;

 CCP5CON.CCP5M3=1;
 CCP5CON.CCP5M2=1;

 CCPR5L=0;

 TRISE.RE2=0;


 ADCON0.ADON=1;



 T0CON=0b11000011;
 INTCON.TMR0IE=1;
 INTCON.TMR0IF=0;
 INTCON.GIE=1;
#line 128 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/1_07_2020/parte C/parteC.c"
 ADCON0.GO_NOT_DONE=1;
 while(1){

 RC0_VAL=PORTC.RC0;

 if (RC0_VAL!=RC0_OLD && RC0_VAL==1){

 stato_accensione=!stato_accensione;


 if (stato_accensione==1){


 Lcd_cmd(_LCD_CLEAR);
 Lcd_out(1,1,"ACCESO");

 }
 else{

 Lcd_cmd(_LCD_CLEAR);
 Lcd_out(1,1,"SPENTO");
 }
 }
 RC0_OLD=RC0_VAL;


 if (stato_accensione==1){

 RC3_VAL=PORTC.RC3;
 RC4_VAL=PORTC.RC4;
 if(RC3_VAL!=RC3_OLD && RC3_VAL==1 && setpoint_temperatura<50 ){
 setpoint_temperatura+=1;
 }

 if(RC4_VAL!=RC4_OLD && RC4_VAL==1 && setpoint_temperatura>10 ){
 setpoint_temperatura-=1;
 }
 RC3_OLD=RC3_VAL;
 RC4_OLD=RC4_VAL;




 if(clk>1000){


 clk=0;
 ADCON0.GO_NOT_DONE=1;
 adc_res_V=ADRESH;
 adc_res_V=adc_res_V*4*5/1000;
 T=adc_res_V*8+10;


 delta_T=abs(T-setpoint_temperatura);
 if (delta_T<1){
 CCPR5L=0;
 CCP5CON.DC5B0=0;
 CCP5CON.DC5B1=0;
 }
 else if(1<=delta_T<=4) {
 sigma=33*delta_T-33;

 CCPR5L=(PR2+1)*sigma/100;

 }
 else {
 CCPR5L=255;
 CCP5CON.DC5B0=1;
 CCP5CON.DC5B1=1;
 }

 }

 IntToStr(sigma,setpoint_temperatura_char);
 Lcd_out(2,4,setpoint_temperatura_char);
 IntToStr(CCPR5L,T_char);
 Lcd_out(2,1,T_char);
 IntToStr(delta_T,delta_T_char);
 Lcd_out(2,7,delta_T_char);



 }

 }
}


void interrupt(){
 INTCON.GIE=0;
 if (INTCON.TMR0IF){
 INTCON.TMR0IF=0;
 clk+=1;

 }

 INTCON.GIE=1;
}
