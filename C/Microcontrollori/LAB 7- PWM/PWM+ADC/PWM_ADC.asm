
_main:

;PWM_ADC.c,1 :: 		void main() {
;PWM_ADC.c,4 :: 		TRISE.RE2 = 1;
	BSF         TRISE+0, 2 
;PWM_ADC.c,7 :: 		CCPTMRS1.C5TSEL0 = 0;
	BCF         CCPTMRS1+0, 2 
;PWM_ADC.c,8 :: 		CCPTMRS1.C5TSEL1 = 0;
	BCF         CCPTMRS1+0, 3 
;PWM_ADC.c,11 :: 		PR2=255;
	MOVLW       255
	MOVWF       PR2+0 
;PWM_ADC.c,14 :: 		CCPR5L=128;
	MOVLW       128
	MOVWF       CCPR5L+0 
;PWM_ADC.c,17 :: 		CCP5CON.CCP5M3 = 1;
	BSF         CCP5CON+0, 3 
;PWM_ADC.c,18 :: 		CCP5CON.CCP5M2 = 1;
	BSF         CCP5CON+0, 2 
;PWM_ADC.c,22 :: 		T2CON = 0b00000111;
	MOVLW       7
	MOVWF       T2CON+0 
;PWM_ADC.c,25 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;PWM_ADC.c,29 :: 		TRISA.RA0=1; // C input : valore che l'adc andrà a leggere
	BSF         TRISA+0, 0 
;PWM_ADC.c,30 :: 		ANSELA.RA0=1; //
	BSF         ANSELA+0, 0 
;PWM_ADC.c,33 :: 		ADCON0.CHS0= 0;
	BCF         ADCON0+0, 2 
;PWM_ADC.c,34 :: 		ADCON0.CHS1= 0;
	BCF         ADCON0+0, 3 
;PWM_ADC.c,35 :: 		ADCON0.CHS2= 0;
	BCF         ADCON0+0, 4 
;PWM_ADC.c,36 :: 		ADCON0.CHS3= 0;
	BCF         ADCON0+0, 5 
;PWM_ADC.c,37 :: 		ADCON0.CHS4= 0;
	BCF         ADCON0+0, 6 
;PWM_ADC.c,42 :: 		ADCON2.ADCS0=1;
	BSF         ADCON2+0, 0 
;PWM_ADC.c,43 :: 		ADCON2.ADCS1=0;
	BCF         ADCON2+0, 1 
;PWM_ADC.c,44 :: 		ADCON2.ADCS2=0;
	BCF         ADCON2+0, 2 
;PWM_ADC.c,50 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;PWM_ADC.c,51 :: 		ADCON2.ACQT1=0;
	BCF         ADCON2+0, 4 
;PWM_ADC.c,52 :: 		ADCON2.ACQT2=1;
	BSF         ADCON2+0, 5 
;PWM_ADC.c,56 :: 		ADCON2.ADFM=0;
	BCF         ADCON2+0, 7 
;PWM_ADC.c,60 :: 		PIE1.ADIE=1; // enable interrupt adc
	BSF         PIE1+0, 6 
;PWM_ADC.c,61 :: 		PIR1.ADIF=0; // interrupt flag =0
	BCF         PIR1+0, 6 
;PWM_ADC.c,62 :: 		INTCON.PEIE=1;// enable interrupt periferiche
	BSF         INTCON+0, 6 
;PWM_ADC.c,63 :: 		INTCON.GIE=1; // eanble interrupt globale
	BSF         INTCON+0, 7 
;PWM_ADC.c,65 :: 		ADCON0.ADON=1; // accendo adc
	BSF         ADCON0+0, 0 
;PWM_ADC.c,66 :: 		ADCON0.GO_NOT_DONE=1; // do il go
	BSF         ADCON0+0, 1 
;PWM_ADC.c,68 :: 		while (1){
L_main0:
;PWM_ADC.c,71 :: 		}
	GOTO        L_main0
;PWM_ADC.c,73 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;PWM_ADC.c,75 :: 		void interrupt() {
;PWM_ADC.c,76 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;PWM_ADC.c,77 :: 		if (PIR1.ADIF) {
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt2
;PWM_ADC.c,78 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;PWM_ADC.c,79 :: 		CCPR5L=ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       CCPR5L+0 
;PWM_ADC.c,80 :: 		ADCON0.GO_NOT_DONE = 1; // do il go
	BSF         ADCON0+0, 1 
;PWM_ADC.c,81 :: 		}
L_interrupt2:
;PWM_ADC.c,84 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;PWM_ADC.c,85 :: 		}
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt
