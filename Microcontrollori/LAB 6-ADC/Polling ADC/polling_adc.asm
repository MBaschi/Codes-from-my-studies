
_main:

;polling_adc.c,2 :: 		void main() {
;polling_adc.c,4 :: 		TRISC=0; // C output
	CLRF        TRISC+0 
;polling_adc.c,6 :: 		TRISA.RA0=1; // C input : valore che l'adc andrà a leggere
	BSF         TRISA+0, 0 
;polling_adc.c,7 :: 		ANSELA.RA0=1; //
	BSF         ANSELA+0, 0 
;polling_adc.c,10 :: 		ADCON0.CHS0= 0;
	BCF         ADCON0+0, 2 
;polling_adc.c,11 :: 		ADCON0.CHS1= 0;
	BCF         ADCON0+0, 3 
;polling_adc.c,12 :: 		ADCON0.CHS2= 0;
	BCF         ADCON0+0, 4 
;polling_adc.c,13 :: 		ADCON0.CHS3= 0;
	BCF         ADCON0+0, 5 
;polling_adc.c,14 :: 		ADCON0.CHS4= 0;
	BCF         ADCON0+0, 6 
;polling_adc.c,19 :: 		ADCON2.ADCS0=1;
	BSF         ADCON2+0, 0 
;polling_adc.c,20 :: 		ADCON2.ADCS1=0;
	BCF         ADCON2+0, 1 
;polling_adc.c,21 :: 		ADCON2.ADCS2=0;
	BCF         ADCON2+0, 2 
;polling_adc.c,27 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;polling_adc.c,28 :: 		ADCON2.ACQT1=0;
	BCF         ADCON2+0, 4 
;polling_adc.c,29 :: 		ADCON2.ACQT2=1;
	BSF         ADCON2+0, 5 
;polling_adc.c,33 :: 		ADCON2.ADFM=0;
	BCF         ADCON2+0, 7 
;polling_adc.c,36 :: 		ADCON0.ADON=1; // accendo adc
	BSF         ADCON0+0, 0 
;polling_adc.c,37 :: 		ADCON0.GO_NOT_DONE=1; // do il go
	BSF         ADCON0+0, 1 
;polling_adc.c,39 :: 		while (1){
L_main0:
;polling_adc.c,41 :: 		if (ADCON0.GO_NOT_DONE == 0){ // la conversione è finita
	BTFSC       ADCON0+0, 1 
	GOTO        L_main2
;polling_adc.c,42 :: 		LATC=ADRESH; // stampa il risultato su port C
	MOVF        ADRESH+0, 0 
	MOVWF       LATC+0 
;polling_adc.c,43 :: 		ADCON0.GO_NOT_DONE=1; // riprendi la conversione
	BSF         ADCON0+0, 1 
;polling_adc.c,44 :: 		}
L_main2:
;polling_adc.c,45 :: 		}
	GOTO        L_main0
;polling_adc.c,46 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
