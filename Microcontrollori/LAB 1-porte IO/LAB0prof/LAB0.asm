
_main:

;LAB0.c,1 :: 		void main() {
;LAB0.c,4 :: 		TRISC = 0xFF; // setto la porta c come input non devo scirver TRISC=1 perchè significa TRISC=0000 0001 che significa solo l'ultima porta è di input
	MOVLW       255
	MOVWF       TRISC+0 
;LAB0.c,5 :: 		TRISC = 255; // modo alternativo: traduce 255 decimale in binario che è appunto 111111111
	MOVLW       255
	MOVWF       TRISC+0 
;LAB0.c,7 :: 		ANSELC = 0; // setto la porta c come ingresso settanto ANSEL =0
	CLRF        ANSELC+0 
;LAB0.c,9 :: 		TRISD = 0; // setto la porta D come output
	CLRF        TRISD+0 
;LAB0.c,10 :: 		ANSELC = 0xFF; // alcune istruzioni potrebbero essere evitate perchè
	MOVLW       255
	MOVWF       ANSELC+0 
;LAB0.c,12 :: 		while(1)
L_main0:
;LAB0.c,13 :: 		LATD = PORTC;
	MOVF        PORTC+0, 0 
	MOVWF       LATD+0 
	GOTO        L_main0
;LAB0.c,14 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
