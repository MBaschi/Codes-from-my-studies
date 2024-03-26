
_main:

;pwm.c,1 :: 		void main() {
;pwm.c,3 :: 		TRISE.RE2 = 1;
	BSF         TRISE+0, 2 
;pwm.c,6 :: 		CCPTMRS1.C5TSEL0 = 0;
	BCF         CCPTMRS1+0, 2 
;pwm.c,7 :: 		CCPTMRS1.C5TSEL1 = 0;
	BCF         CCPTMRS1+0, 3 
;pwm.c,10 :: 		PR2=255;
	MOVLW       255
	MOVWF       PR2+0 
;pwm.c,13 :: 		CCPR5L=128;
	MOVLW       128
	MOVWF       CCPR5L+0 
;pwm.c,16 :: 		CCP5CON.CCP5M3 = 1;
	BSF         CCP5CON+0, 3 
;pwm.c,17 :: 		CCP5CON.CCP5M2 = 1;
	BSF         CCP5CON+0, 2 
;pwm.c,21 :: 		T2CON = 0b00000111;
	MOVLW       7
	MOVWF       T2CON+0 
;pwm.c,24 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;pwm.c,25 :: 		while (1){
L_main0:
;pwm.c,26 :: 		delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	DECFSZ      R11, 1, 1
	BRA         L_main2
	NOP
;pwm.c,27 :: 		CCPR5L++;
	MOVF        CCPR5L+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       CCPR5L+0 
;pwm.c,28 :: 		}
	GOTO        L_main0
;pwm.c,29 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
