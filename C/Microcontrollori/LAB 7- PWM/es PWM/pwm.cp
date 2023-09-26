#line 1 "C:/Users/mbasc/Desktop/uni/1 anno magistrale/Secondo semstre/Microcontrollori/LAB/LAB 7- PWM/es PWM/pwm.c"
void main() {

 TRISE.RE2 = 1;


 CCPTMRS1.C5TSEL0 = 0;
 CCPTMRS1.C5TSEL1 = 0;


 PR2=255;


 CCPR5L=128;


 CCP5CON.CCP5M3 = 1;
 CCP5CON.CCP5M2 = 1;



 T2CON = 0b00000111;


 TRISE.RE2=0;
 while (1){
 delay_ms(100);
 CCPR5L++;
 }
}
