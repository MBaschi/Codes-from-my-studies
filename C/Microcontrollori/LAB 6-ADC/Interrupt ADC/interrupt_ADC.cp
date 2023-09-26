#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 6-ADC/Interrupt ADC/interrupt_ADC.c"

void main() {

 TRISC=0;

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


 PIE1.ADIE=1;
 PIR1.ADIF=0;
 INTCON.PEIE=1;
 INTCON.GIE=1;

 ADCON0.ADON=1;
 ADCON0.GO_NOT_DONE=1;

 while (1){

 }
}

void interrupt(){
 if(PIR1.ADIF){
 PIR1.ADIF=0;
 LATC=ADRESH;
 ADCON0.GO_NOT_DONE=1;
 }
}
