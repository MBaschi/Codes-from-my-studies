
_main:

;LAB0_.c,1 :: 		void main() {
;LAB0_.c,2 :: 		int i=0;
;LAB0_.c,3 :: 		TRISC = 0xFF; // Spengo buffer uscita digitale
	MOVLW       255
	MOVWF       TRISC+0 
;LAB0_.c,4 :: 		ANSELC = 0; // Accendo il buffer ingresso digitale
	CLRF        ANSELC+0 
;LAB0_.c,6 :: 		TRISD = 0; // Accendo buffer uscita digitale
	CLRF        TRISD+0 
;LAB0_.c,7 :: 		ANSELD = 0xFF; // Spengo il buffer ingresso digitale
	MOVLW       255
	MOVWF       ANSELD+0 
;LAB0_.c,9 :: 		while(1)
L_main0:
;LAB0_.c,10 :: 		LATD = PORTC;
	MOVF        PORTC+0, 0 
	MOVWF       LATD+0 
	GOTO        L_main0
;LAB0_.c,12 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
