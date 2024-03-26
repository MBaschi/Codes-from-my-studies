#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 6-ADC/es noi/es_noi.c"



 unsigned short int new_value=0;



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

 unsigned int adc_10bit;
 unsigned short int adc_8bit;
 unsigned short int channel=1;
 char pot1_mv[9];
 char pot2_mv[7];



 TRISA.RA0=1;
 ANSELA.RA0=1;
 TRISD.RD0=1;
 ANSELD.RD0=1;

 TRISC=0;



 ADCON2.ADCS0=1;
 ADCON2.ADCS0=0;
 ADCON2.ADCS0=0;

 ADCON2.ACQT0=0;
 ADCON2.ACQT1=0;
 ADCON2.ACQT2=1;

 ADCON0.CHS0=0;
 ADCON0.CHS1=0;
 ADCON0.CHS2=0;
 ADCON0.CHS3=0;
 ADCON0.CHS4=0;

 ADCON2.ADFM=0;


 ADCON0.ADON=1;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,4,"ciaooooooooooooooooooo");

 PIE1.ADIE=1;
 PIR1.ADIF=0;
 INTCON.PEIE=1;
 INTCON.GIE=1;





 ADCON0.GO_NOT_DONE=1;
 Lcd_Out(2,4,"ciaoooooooooooooooooo");

 while (1){


 if (new_value==1){


 if (channel==1){
 ADRESL>>6;
 adc_10bit=5*(ADRESH*4+ADRESL);
 IntToStr(pot1_mv,adc_10bit);


 ADCON0.CHS0=0;
 ADCON0.CHS1=0;
 ADCON0.CHS2=1;
 ADCON0.CHS3=0;
 ADCON0.CHS4=1;
 }

 if (channel==0){
 adc_8bit=5*4*ADRESH;
 IntToStr(pot2_mv,adc_8bit);

 ADCON0.CHS0=0;
 ADCON0.CHS1=0;
 ADCON0.CHS2=0;
 ADCON0.CHS3=0;
 ADCON0.CHS4=0;
 LATC=ADRESH;
 }



 new_value=0;
 channel!=channel;
 ADCON0.GO_NOT_DONE=1;
 }


 }

}

void interrupt(){

 if (PIR1.ADIF==1){
 PIR1.ADIE=0;
 PIR1.ADIF=0;
 new_value=1;

 PIR1.ADIE=1;
 }


}
