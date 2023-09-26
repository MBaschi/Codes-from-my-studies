#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 8-TDE/sez.B/b.c"


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



unsigned short int new_value=0;

void main() {


 unsigned short int conteggio=0;

 unsigned short int RD5X=0;
 unsigned short int RD6X=0;
 unsigned short int RD7X=0;

 unsigned short int RD5_old=0;
 unsigned short int RD6_old=0;
 unsigned short int RD7_old=0;

 char conteggio_char[7];

 char adc_res_char[7];
 unsigned int adc_result=0;
 unsigned short int temp;
 unsigned short int porta_adc=0;
 char adc_res_char1[7];


 TRISD.RD5=1;
 TRISD.RD6=1;
 TRISD.RD7=1;
 ANSELD=0;

 TRISA.RA0=1;
 ANSELA.RA0=1;
 TRISD.RD0=1;
 ANSELD.RD0=1;

 TRISE.RE2=1;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,conteggio_char);
 Lcd_Out(2,1,adc_res_char);



 ADCON0.CHS0=0;
 ADCON0.CHS1=0;
 ADCON0.CHS2=0;
 ADCON0.CHS3=0;
 ADCON0.CHS4= 0;

 ADCON2.ADCS0=0;
 ADCON2.ADCS0=1;
 ADCON2.ADCS0=0;

 ADCON2.ACQT0=0;
 ADCON2.ACQT0=1;
 ADCON2.ACQT0=0;

 ADCON2.ADFM=1;

 ADCON0.ADON=1;

 ADCON1.PVCFG0=0;
 ADCON1.PVCFG1=0;

 ADCON1.NVCFG0=0;
 ADCON1.NVCFG1=0;



 CCPTMRS1.C5TSEL0=0;
 CCPTMRS1.C5TSEL1=1;

 PR6=255;

 CCP5CON.CCP5M3=1;
 CCP5CON.CCP5M2=1;

 T6CON = 0b00000111;

 TRISE.RE2=0;

 PIE1.ADIE=1;
 PIR1.ADIF=0;
 INTCON.PEIE=1;
 INTCON.GIE=1;





 ADCON0.GO_NOT_DONE=1;

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

 if (new_value==1 && porta_adc==0){

 temp =ADRESH;
 temp<<6;
 adc_result=ADRESL;
 adc_result=(ADRESL+temp*4)*5;
 new_value=0;

 ADCON0.CHS0=0;
 ADCON0.CHS1=0;
 ADCON0.CHS2=1;
 ADCON0.CHS3=0;
 ADCON0.CHS4= 1;
 porta_adc=1;
 new_value=0;
 }
 else{

 CCPR5L=ADRESH;

 ADCON0.CHS0=0;
 ADCON0.CHS1=0;
 ADCON0.CHS2=0;
 ADCON0.CHS3=0;
 ADCON0.CHS4= 0;
 porta_adc=0;
 new_value=0;
 IntToStr(ADRESL,adc_res_char1);
 Lcd_Out(2,6,adc_res_char1);
 }

 IntToStr(conteggio,conteggio_char);
 Lcd_Out(1,1,conteggio_char);

 IntToStr(adc_result,adc_res_char);
 Lcd_Out(2,1,adc_res_char);
 }
}

void interrupt(){
 if (PIR1.ADIF){
 new_value=1;
 PIR1.ADIF=0;
 ADCON0.GO_NOT_DONE=1;
 }

}
