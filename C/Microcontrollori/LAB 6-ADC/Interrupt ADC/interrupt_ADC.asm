
_main:

;interrupt_ADC.c,2 :: 		void main() {
;interrupt_ADC.c,4 :: 		TRISC=0; // C output
	CLRF        TRISC+0 
;interrupt_ADC.c,6 :: 		TRISA.RA0=1; // C input : valore che l'adc andrà a leggere
	BSF         TRISA+0, 0 
;interrupt_ADC.c,7 :: 		ANSELA.RA0=1; //
	BSF         ANSELA+0, 0 
;interrupt_ADC.c,10 :: 		ADCON0.CHS0= 0;
	BCF         ADCON0+0, 2 
;interrupt_ADC.c,11 :: 		ADCON0.CHS1= 0;
	BCF         ADCON0+0, 3 
;interrupt_ADC.c,12 :: 		ADCON0.CHS2= 0;
	BCF         ADCON0+0, 4 
;interrupt_ADC.c,13 :: 		ADCON0.CHS3= 0;
	BCF         ADCON0+0, 5 
;interrupt_ADC.c,14 :: 		ADCON0.CHS4= 0;
	BCF         ADCON0+0, 6 
;interrupt_ADC.c,19 :: 		ADCON2.ADCS0=1;
	BSF         ADCON2+0, 0 
;interrupt_ADC.c,20 :: 		ADCON2.ADCS1=0;
	BCF         ADCON2+0, 1 
;interrupt_ADC.c,21 :: 		ADCON2.ADCS2=0;
	BCF         ADCON2+0, 2 
;interrupt_ADC.c,27 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;interrupt_ADC.c,28 :: 		ADCON2.ACQT1=0;
	BCF         ADCON2+0, 4 
;interrupt_ADC.c,29 :: 		ADCON2.ACQT2=1;
	BSF         ADCON2+0, 5 
;interrupt_ADC.c,33 :: 		ADCON2.ADFM=0;
	BCF         ADCON2+0, 7 
;interrupt_ADC.c,36 :: 		PIE1.ADIE=1; // enable interrupt adc
	BSF         PIE1+0, 6 
;interrupt_ADC.c,37 :: 		PIR1.ADIF=0; // interrupt flag =0
	BCF         PIR1+0, 6 
;interrupt_ADC.c,38 :: 		INTCON.PEIE=1;// enable interrupt periferiche
	BSF         INTCON+0, 6 
;interrupt_ADC.c,39 :: 		INTCON.GIE=1; // eanble interrupt globale
	BSF         INTCON+0, 7 
;interrupt_ADC.c,41 :: 		ADCON0.ADON=1; // accendo adc
	BSF         ADCON0+0, 0 
;interrupt_ADC.c,42 :: 		ADCON0.GO_NOT_DONE=1; // do il go
	BSF         ADCON0+0, 1 
;interrupt_ADC.c,44 :: 		while (1){
L_main0:
;interrupt_ADC.c,46 :: 		}
	GOTO        L_main0
;interrupt_ADC.c,47 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;interrupt_ADC.c,49 :: 		void interrupt(){
;interrupt_ADC.c,50 :: 		if(PIR1.ADIF){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt2
;interrupt_ADC.c,51 :: 		PIR1.ADIF=0;
	BCF         PIR1+0, 6 
;interrupt_ADC.c,52 :: 		LATC=ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       LATC+0 
;interrupt_ADC.c,53 :: 		ADCON0.GO_NOT_DONE=1; // riprendi la conversione
	BSF         ADCON0+0, 1 
;interrupt_ADC.c,54 :: 		}
L_interrupt2:
;interrupt_ADC.c,55 :: 		}
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt
