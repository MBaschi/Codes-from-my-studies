void main() {
     //1-spegnere buffer d'uscita della porta che usiamo come PWM: la CCP5
     TRISE.RE2 = 1;

     //2-connettere timer 2 a PWM di CCP5
     CCPTMRS1.C5TSEL0 = 0;
     CCPTMRS1.C5TSEL1 = 0;
     
     //3-imposto prescaler timer 2
     T2CON = 0b00000111;
    
     //4-imposto CCP5 in modalità PWM
     CCP5CON.CCP5M3 = 1;
     CCP5CON.CCP5M2 = 1;
     // CCP5CON = 0b00001100;

     //5-imposto Ton e T
     CCPR5L=128;
     PR2=255; // quindi duty cycle del 50%

     //6-lo balziamo

     //7-accendo CCP5
     TRISE.RE2=0;

     while (1){ 
          delay_ms(100);  
          CCPR5L++; // aumenta duty cycle ogni MS 
     }
}